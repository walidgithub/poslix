import 'dart:convert';

import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:poslix_app/pos/domain/requests/user_model.dart';
import '../../../../domain/repositories/pos_repo_impl.dart';
import '../../../../domain/response/authorization_model.dart';
import '../../../../domain/response/login_model.dart';
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

  Future<LoginResponse> login(UserRequest parameters) async {
    try {
      print('11111111111');
      print(parameters.email);
      var res;
      if (await networkInfo.isConnected) {

        emit(LoginLoading());
        res = await posRepositoryImpl.login(parameters);
        print(res.authorization.token);
        print(res.user);
        print('22222222222');
        final String encodedLocationData = json.encode(res.user);
        emit(LoginSucceed(res.authorization.token, encodedLocationData));
        print(res);
        print('333333333');
        return res;
      } else {
        print('4444444444');
        emit(LoginNoInternetState());
        return res;
      }
    } catch (e) {
      print('5555555555');
      if (e.toString() == 'Unauthorized') {
        emit(WrongEmailOrPass(e.toString()));
      } else {
        emit(LoginFailed(e.toString()));
      }
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

          res = await posRepositoryImpl.logout(_appPreferences.getToken(LOGGED_IN_TOKEN)!);
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
