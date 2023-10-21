abstract class RegisterPOSState {}

class RegisterPOSInitial extends RegisterPOSState {}

class RegisterPOSLoading extends RegisterPOSState {}
class RegisterPOSLoaded extends RegisterPOSState {}
class RegisterPOSLoadingFailed extends RegisterPOSState {
  String errorText;

  RegisterPOSLoadingFailed(this.errorText);
}

class TaxesLoaded extends RegisterPOSState {}
class TaxesLoadingFailed extends RegisterPOSState {
  String errorText;

  TaxesLoadingFailed(this.errorText);
}

class OpenRegisterSucceed extends RegisterPOSState{}
class OpenRegisterError extends RegisterPOSState{
  String errorText;

  OpenRegisterError(this.errorText);
}

class UserHasOpenedRegister extends RegisterPOSState{}
class UserHasNoOpenedRegister extends RegisterPOSState{}
class OpenCloseRegisterError extends RegisterPOSState{
  String errorText;

  OpenCloseRegisterError(this.errorText);
}

class GetPermissionsSucceed extends RegisterPOSState {}
class GetPermissionsFailed extends RegisterPOSState {
  String errorText;

  GetPermissionsFailed(this.errorText);
}

class GetUserInfoSucceed extends RegisterPOSState {}
class GetUserInfoFailed extends RegisterPOSState {
  String errorText;

  GetUserInfoFailed(this.errorText);
}

class RegisterNoInternetState extends RegisterPOSState{}

