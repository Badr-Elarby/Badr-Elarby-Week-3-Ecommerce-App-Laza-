import 'dart:convert';

import 'package:dio/dio.dart';

class PaymobService {
  final Dio _dio;

  // Replace these with your provided/test values if different
  final String apiKey;
  final int integrationId;
  final int iframeId;

  PaymobService({Dio? dio, String? apiKey, int? integrationId, int? iframeId})
    : _dio = dio ?? Dio(),
      apiKey =
          apiKey ??
          'ZXlKaGJHY2lPaUpJVXpVeE1pSXNJblI1Y0NJNklrcFhWQ0o5LmV5SmpiR0Z6Y3lJNklrMWxjbU5vWVc1MElpd2ljSEp2Wm1sc1pWOXdheUk2TVRBek1UWXdPU3dpYm1GdFpTSTZJakUzTkRZd05qQTRNakF1TWpZME1UZzJJbjAuejZ6MEN6aHdQUzkwU08xRTdsLWEtRmJsNFBGR3JGMGxXbjhRWUtqeFYwazNidDRJdFZjVUgwVzFwczJaRzNCdDZ2NmhFaTh4X3RjejJmbWk2czFyTUE=',
      integrationId = integrationId ?? 5017893,
      iframeId = iframeId ?? 908239;

  /// Obtain auth token from Paymob
  Future<String> getAuthToken() async {
    final url = 'https://accept.paymob.com/api/auth/tokens';
    final body = {'api_key': apiKey};

    try {
      final resp = await _dio.post(
        url,
        data: jsonEncode(body),
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      final status = resp.statusCode ?? 0;
      if (status == 200 || status == 201) {
        final token = resp.data['token'] as String?;
        if (token == null) throw Exception('Paymob auth token missing');
        return token;
      }

      throw Exception('Paymob auth failed ($status): ${resp.data}');
    } on DioException catch (e) {
      final resp = e.response;
      final status = resp?.statusCode;
      final data = resp?.data;
      throw Exception(
        'Paymob auth error (${status ?? 'no status'}): ${data ?? e.message}',
      );
    }
  }

  /// Register an order and return the order id and response map
  Future<Map<String, dynamic>> registerOrder({
    required int amountCents,
    String currency = 'EGP',
    Map<String, dynamic>? items,
    required String authToken,
  }) async {
    final url = 'https://accept.paymob.com/api/ecommerce/orders';
    final body = {
      'auth_token': authToken,
      'delivery_needed': false,
      'amount_cents': amountCents,
      'currency': currency,
      'items': items ?? [],
    };

    try {
      final resp = await _dio.post(
        url,
        data: jsonEncode(body),
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      final status = resp.statusCode ?? 0;
      if (status == 200 || status == 201) {
        return resp.data as Map<String, dynamic>;
      }

      throw Exception('Register order failed ($status): ${resp.data}');
    } on DioException catch (e) {
      final resp = e.response;
      final status = resp?.statusCode;
      final data = resp?.data;
      throw Exception(
        'Register order error (${status ?? 'no status'}): ${data ?? e.message}',
      );
    }
  }

  /// Request a payment key for the iframe
  Future<String> requestPaymentKey({
    required int amountCents,
    required int orderId,
    required Map<String, dynamic> billingData,
    required String authToken,
  }) async {
    final url = 'https://accept.paymob.com/api/acceptance/payment_keys';

    final body = {
      'auth_token': authToken,
      'amount_cents': amountCents,
      'expiration': 3600,
      'order_id': orderId,
      'billing_data': billingData,
      'currency': 'EGP',
      'integration_id': integrationId,
    };

    try {
      final resp = await _dio.post(
        url,
        data: jsonEncode(body),
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      final status = resp.statusCode ?? 0;
      if (status == 200 || status == 201) {
        final key = resp.data['token'] as String?;
        if (key == null) throw Exception('Payment key missing');
        return key;
      }

      throw Exception('Payment key failed ($status): ${resp.data}');
    } on DioException catch (e) {
      final resp = e.response;
      final status = resp?.statusCode;
      final data = resp?.data;
      throw Exception(
        'Payment key error (${status ?? 'no status'}): ${data ?? e.message}',
      );
    }
  }

  /// Build iframe url
  String buildIframeUrl(String paymentKey) {
    return 'https://accept.paymob.com/api/acceptance/iframes/$iframeId?payment_token=$paymentKey';
  }
}
