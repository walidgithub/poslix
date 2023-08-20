import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:poslix_app/pos/domain/requests/user_model.dart';
import '../../../../domain/repositories/pos_repo_impl.dart';
import '../../../../domain/response/authorization_model.dart';
import '../../../../domain/response/logout_response.dart';
import '../../../../domain/response/permissions_model.dart';
import '../../../../domain/response/user_model.dart';
import '../../../../shared/core/network/network_info.dart';
import '../../../../shared/preferences/app_pref.dart';
import '../../../di/di.dart';
import 'login_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit(this.posRepositoryImpl) : super(LoginInitial());

  final AppPreferences _appPreferences = sl<AppPreferences>();

  POSRepositoryImpl posRepositoryImpl;

  static LoginCubit get(context) => BlocProvider.of(context);

  final NetworkInfo networkInfo = sl<NetworkInfo>();

  String? userName;
  String? password;
  UserRequest? userRequest;

  Future<void> getUserParameters() async {
    userName = _appPreferences.getUserName(USER_NAME)!;
    password = _appPreferences.getPassword(PASS)!;
    userRequest = UserRequest(email: userName!, password: password!);
  }

  Future<AuthorizationResponse> login(UserRequest parameters) async {
    try {
      var res;
      if (await networkInfo.isConnected) {
        emit(LoginLoading());
        res = await posRepositoryImpl.login(parameters);
        emit(LoginSucceed(res.token));
        return res;
      } else {
        emit(LoginNoInternetState());
        return res;
      }
    } catch (e) {
      if (e.toString() == 'Unauthorized') {
        emit(WrongEmailOrPass(e.toString()));
      } else {
        emit(LoginFailed(e.toString()));
      }
      return Future.error(e);
    }
  }

  Future<UserResponse> getUserInfo(UserRequest parameters) async {
    try {
      var res;
      if (await networkInfo.isConnected) {
        String token = _appPreferences.getToken(LOGGED_IN_TOKEN)!;
        bool hasExpired = JwtDecoder.isExpired(token);
        if (hasExpired) {
          await getUserParameters();
          await login(userRequest!);

          res = await posRepositoryImpl.getUserInfo(parameters, token);
          emit(GetUserInfoSucceed());
          return res;
        }

        res = await posRepositoryImpl.getUserInfo(parameters, token);
        emit(GetUserInfoSucceed());
        return res;
      } else {
        emit(LoginNoInternetState());
        return res;
      }
    } catch (e) {
      emit(GetUserInfoFailed(e.toString()));
      return Future.error(e);
    }
  }

  Future<LogoutResponse> logout() async {
    try {
      var res;
      if (await networkInfo.isConnected) {
        String token = _appPreferences.getToken(LOGGED_IN_TOKEN)!;
        bool hasExpired = JwtDecoder.isExpired(token);
        if (hasExpired) {
          await getUserParameters();
          await login(userRequest!);

          res = await posRepositoryImpl.logout(token);
          emit(LogoutSucceed());
          return res;
        }

        res = await posRepositoryImpl.logout(token);
        emit(LogoutSucceed());
        return res;
      } else {
        emit(LoginNoInternetState());
        return res;
      }
    } catch (e) {
      emit(LogoutFailed(e.toString()));
      return Future.error(e);
    }
  }
}
