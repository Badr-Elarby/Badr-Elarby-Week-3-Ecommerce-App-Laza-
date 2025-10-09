import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:laza/features/auth/data/models/login_request_model.dart';
import 'package:laza/features/auth/data/repositories/auth_repository.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthRepository _authRepository;

  LoginCubit(this._authRepository) : super(LoginInitial());

  Future<void> login(String email, String password) async {
    emit(LoginLoading());
    try {
      final request = LoginRequestModel(email: email, password: password);
      await _authRepository.login(request);
      emit(const LoginSuccess('Login successful!'));
    } catch (e) {
      emit(LoginFailure(e.toString()));
    }
  }
}
