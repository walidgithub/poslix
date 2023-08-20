abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSucceed extends LoginState {
  String token;
  LoginSucceed(this.token);
}

class LoginFailed extends LoginState {
  String errorText;

  LoginFailed(this.errorText);
}

class WrongEmailOrPass extends LoginState {
  String errorText;

  WrongEmailOrPass(this.errorText);
}

class LogoutSucceed extends LoginState {}
class LogoutFailed extends LoginState {
  String errorText;

  LogoutFailed(this.errorText);
}

class GetUserInfoSucceed extends LoginState {}
class GetUserInfoFailed extends LoginState {
  String errorText;

  GetUserInfoFailed(this.errorText);
}

class LoginNoInternetState extends LoginState{}


