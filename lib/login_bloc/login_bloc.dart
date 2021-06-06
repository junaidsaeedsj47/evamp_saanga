import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:evamp_saanga/services/auth_service.dart';
import 'login_event.dart';
import 'login_state.dart';
class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthService _authService;
  LoginBloc({required AuthService authService})
      : _authService = authService,
        super(LoginState.initial());

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is LoginEmailChange) {
      yield* _mapLoginEmailChangeToState(event.email);
    } else if (event is LoginPasswordChange) {
      yield* _mapLoginPasswordChangeToState(event.password);
    } else if (event is LoginWithCredentialsPressed) {
      yield* _mapLoginWithCredentialsPressedToState(
        event.email,
        event.password,
      );
    }
  }

  Stream<LoginState> _mapLoginEmailChangeToState(String email) async* {
    yield state.update(isEmailValid: email.isNotEmpty);
  }

  Stream<LoginState> _mapLoginPasswordChangeToState(String password) async* {
    yield state.update(isPasswordValid: password.length < 6 ? false : true);
  }

  Stream<LoginState> _mapLoginWithCredentialsPressedToState(
      String email, String password) async* {
    yield LoginState.loading();
    try {
      final result = await _authService.loginWithCredentials(email, password);
      if (result != null) {
        yield LoginState.success();
      } else {
        yield LoginState.failure();
      }
    } catch (e) {
      yield LoginState.failure();
    }
  }
}
