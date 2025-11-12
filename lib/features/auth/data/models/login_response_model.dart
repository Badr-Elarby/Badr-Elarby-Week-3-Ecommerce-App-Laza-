import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

// OPTIMIZATION: @immutable annotation enables Dart analyzer optimizations
@immutable
class LoginResponseModel extends Equatable {
  final String accessToken;
  final DateTime expiresAtUtc;
  final String refreshToken;

  const LoginResponseModel({
    required this.accessToken,
    required this.expiresAtUtc,
    required this.refreshToken,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      accessToken: json['accessToken'] as String,
      expiresAtUtc: DateTime.parse(json['expiresAtUtc'] as String),
      refreshToken: json['refreshToken'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'accessToken': accessToken,
      'expiresAtUtc': expiresAtUtc.toIso8601String(),
      'refreshToken': refreshToken,
    };
  }

  @override
  List<Object?> get props => [accessToken, expiresAtUtc, refreshToken];
}
