import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

// OPTIMIZATION: @immutable annotation enables Dart analyzer optimizations
@immutable
class RefreshTokenRequestModel extends Equatable {
  final String? refreshToken;
  final bool useCookies;

  const RefreshTokenRequestModel({this.refreshToken, required this.useCookies});

  Map<String, dynamic> toJson() {
    return {'refreshToken': refreshToken, 'useCookies': useCookies};
  }

  @override
  List<Object?> get props => [refreshToken, useCookies];
}
