abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSucceed extends LoginState {
  String token;
  String userLocations;
  LoginSucceed(this.token, this.userLocations);
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

class LoginNoInternetState extends LoginState{}


