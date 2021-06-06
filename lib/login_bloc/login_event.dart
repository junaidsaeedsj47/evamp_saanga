import 'package:equatable/equatable.dart';

abstract class LoginEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoginEmailChange extends LoginEvent {
  final String email;
  LoginEmailChange({required this.email});

  @override
  List<Object> get props => [this.email];
}

class LoginPasswordChange extends LoginEvent {
  final String password;
  LoginPasswordChange({required this.password});

  @override
  List<Object> get props => [this.password];
}

class LoginWithCredentialsPressed extends LoginEvent {
  final String email;
  final String password;

  LoginWithCredentialsPressed({
    required this.email,
    required this.password,
  });

  @override
  List<Object> get props => [this.email, this.password];
}
