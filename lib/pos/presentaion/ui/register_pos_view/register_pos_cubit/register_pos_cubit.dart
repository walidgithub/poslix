import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:poslix_app/pos/domain/response/locations_model.dart';
import 'package:poslix_app/pos/domain/response/taxes_model.dart';
import 'package:poslix_app/pos/presentaion/ui/register_pos_view/register_pos_cubit/register_pos_state.dart';

import '../../../../domain/repositories/pos_repo_impl.dart';
import '../../../../domain/requests/close_register_report_model.dart';
import '../../../../domain/requests/open_register_model.dart';
import '../../../../domain/requests/user_model.dart';
import '../../../../domain/response/authorization_model.dart';
import '../../../../domain/response/business_model.dart';
import '../../../../domain/response/close_register_report_data_model.dart';
import '../../../../domain/response/login_model.dart';
import '../../../../domain/response/open_register_response.dart';
import '../../../../domain/response/user_model.dart';
import '../../../../shared/core/network/network_info.dart';
import '../../../../shared/preferences/app_pref.dart';
import '../../../di/di.dart';

class RegisterPOSCubit extends Cubit<RegisterPOSState> {
  RegisterPOSCubit(this.posRepositoryImpl) : super(RegisterPOSInitial());

  POSRepositoryImpl posRepositoryImpl;
  final NetworkInfo networkInfo = sl<NetworkInfo>();

  static RegisterPOSCubit get(context) => BlocProvider.of(context);

  final AppPreferences _appPreferences = sl<AppPreferences>();

  List<BusinessResponse> listOfBusinesses = [];
  List<LocationsResponse> listOfLocations = [];
  List<TaxesResponse> listOfTaxes = [];

  int? cashInHand;

  String? userName;
  String? password;
  UserRequest? userRequest;
  List<UserResponse> userResponse = [];

  Future<void> getUserParameters() async {
    userName = _appPreferences.getUserName(USER_NAME)!;
    password = _appPreferences.getPassword(PASS)!;
    userRequest = UserRequest(email: userName!, password: password!);
  }

  // Business ----------------------------------------------------
  Future<List<BusinessResponse>> getBusiness() async {
    try {
      var res;
      if (await networkInfo.isConnected) {
        await Future.delayed(const Duration(seconds: 1));
        emit(RegisterPOSLoading());
        String token = _appPreferences.getToken(LOGGED_IN_TOKEN)!;
        bool hasExpired = JwtDecoder.isExpired(token);
        if (hasExpired) {
          await getUserParameters();
          await login(userRequest!);

          res = await posRepositoryImpl.getBusinesses(_appPreferences.getToken(LOGGED_IN_TOKEN)!);

          emit(RegisterPOSLoaded());
          listOfBusinesses = res.toList();

          listOfLocations = listOfBusinesses[0].locations;
          return res;
        }

        res = await posRepositoryImpl.getBusinesses(token);

        emit(RegisterPOSLoaded());
        listOfBusinesses = res.toList();

        listOfLocations = listOfBusinesses[0].locations;
        return res;
      } else {
        emit(RegisterNoInternetState());
        return [];
      }
    } catch (e) {
      emit(RegisterPOSLoadingFailed(e.toString()));
      return Future.error(e);
    }
  }

  // Taxes ----------------------------------------------------
  Future<List<TaxesResponse>> getTaxes(int locationId) async {
    try {
      var res;
      if (await networkInfo.isConnected) {
        String token = _appPreferences.getToken(LOGGED_IN_TOKEN)!;
        bool hasExpired = JwtDecoder.isExpired(token);
        if (hasExpired) {
          await getUserParameters();
          await login(userRequest!);

          res = await posRepositoryImpl.getTaxes(_appPreferences.getToken(LOGGED_IN_TOKEN)!, locationId);

          emit(TaxesLoaded());
          listOfTaxes = res.toList();
          return res;
        }
        res = await posRepositoryImpl.getTaxes(token, locationId);

        emit(TaxesLoaded());
        listOfTaxes = res.toList();
        return res;
      } else {
        emit(RegisterNoInternetState());
        return [];
      }
    } catch (e) {
      emit(TaxesLoadingFailed(e.toString()));
      return Future.error(e);
    }
  }

  // open register ------------------
  Future<OpenRegisterResponse> openRegister(
      OpenRegisterRequest parameters, int locationId) async {
    try {
      var res;
      if (await networkInfo.isConnected) {
        String token = _appPreferences.getToken(LOGGED_IN_TOKEN)!;
        bool hasExpired = JwtDecoder.isExpired(token);
        if (hasExpired) {
          await getUserParameters();
          await login(userRequest!);

          res = await posRepositoryImpl.openRegister(
              parameters, locationId, _appPreferences.getToken(LOGGED_IN_TOKEN)!);
          emit(OpenRegisterSucceed());
          return res;
        }

        res =
            await posRepositoryImpl.openRegister(parameters, locationId, token);
        emit(OpenRegisterSucceed());
        return res;
      } else {
        emit(RegisterNoInternetState());
        return res;
      }
    } catch (e) {
      emit(OpenRegisterError(e.toString()));
      return Future.error(e);
    }
  }

  // open and close register report------------------
  Future<List<CloseRegisterReportDataResponse>> openCloseRegister(
      CloseRegisterReportRequest parameters, int locationId) async {
    try {
      var res;
      String? userInfo;
      UserResponse? userResponse;
      userInfo = _appPreferences.getUserInfo(PREFS_KEY_USER_INFO)!;
      userResponse = UserResponse.fromJson(jsonDecode(userInfo));
      List closed = [];
      List opened = [];
      if (await networkInfo.isConnected) {
        String token = _appPreferences.getToken(LOGGED_IN_TOKEN)!;
        bool hasExpired = JwtDecoder.isExpired(token);
        if (hasExpired) {
          await getUserParameters();
          await login(userRequest!);

          res = await posRepositoryImpl.openCloseRegister(
              parameters, locationId, _appPreferences.getToken(LOGGED_IN_TOKEN)!);

          var statusCounts  = res.where((element) => element.firstName == userResponse!.firstName);
          for (var i in statusCounts) {
            if (i.status == 'open') {
              opened.add('open');
            } else {
              closed.add('close');
            }
          }
          if (opened.length > closed.length) {
            emit(UserHasOpenedRegister());
          } else {
            emit(UserHasNoOpenedRegister());
          }
          return res;
        }

        res = await posRepositoryImpl.openCloseRegister(
            parameters, locationId, token);

        print('starttttttt');
        var statusCounts  = res.where((element) => element.firstName == userResponse!.firstName);
        print(statusCounts);
        for (var i in statusCounts) {
          if (i.status == 'open') {
            opened.add('open');
          } else {
            closed.add('close');
          }
        }
        print(opened.length);
        print(closed.length);

        if (opened.length > closed.length) {
          emit(UserHasOpenedRegister());
        } else {
          emit(UserHasNoOpenedRegister());
        }
        return res;
      } else {
        emit(RegisterNoInternetState());
        return [];
      }
    } catch (e) {
      emit(OpenCloseRegisterError(e.toString()));
      return Future.error(e);
    }
  }

  Future<LoginResponse> login(UserRequest parameters) async {
    try {
      var res;
      if (await networkInfo.isConnected) {
        res = await posRepositoryImpl.login(parameters);
        await _appPreferences.setToken(LOGGED_IN_TOKEN, res.authorization.token);
        return res;
      } else {
        emit(RegisterNoInternetState());
        return res;
      }
    } catch (e) {
      return Future.error(e);
    }
  }
}
