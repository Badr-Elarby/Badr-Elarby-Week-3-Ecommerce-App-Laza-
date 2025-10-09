import 'package:equatable/equatable.dart';

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
