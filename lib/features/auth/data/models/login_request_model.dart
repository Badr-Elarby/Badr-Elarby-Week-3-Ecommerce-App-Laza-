import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

// OPTIMIZATION: @immutable annotation enables Dart analyzer optimizations
@immutable
class LoginRequestModel extends Equatable {
  final String email;
  final String password;

  const LoginRequestModel({required this.email, required this.password});

  Map<String, dynamic> toJson() {
    return {'email': email, 'password': password};
  }

  @override
  List<Object?> get props => [email, password];
}
