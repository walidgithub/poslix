import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import '../../../../../../domain/repositories/pos_repo_impl.dart';
import '../../../../../../domain/requests/user_model.dart';
import '../../../../../../domain/response/authorization_model.dart';
import '../../../../../../domain/response/sales_report_data_model.dart';
import '../../../../../../domain/response/sales_report_items_model.dart';
import '../../../../../../shared/core/network/network_info.dart';
import '../../../../../../shared/preferences/app_pref.dart';
import '../../../../../di/di.dart';
import 'orders_state.dart';

class OrdersCubit extends Cubit<OrdersState> {
  OrdersCubit(this.posRepositoryImpl) : super(OrdersInitial());

  POSRepositoryImpl posRepositoryImpl;
  final NetworkInfo networkInfo = sl<NetworkInfo>();

  static OrdersCubit get(context) => BlocProvider.of(context);

  final AppPreferences _appPreferences = sl<AppPreferences>();

  List<SalesReportDataModel> listOfOrderHead = [];
  List<SalesReportDataModel> listOfAllOrderHead = [];
  List<SalesReportItemsResponse> listOfOrderItems = [];

  String? userName;
  String? password;
  UserRequest? userRequest;

  Future<void> getUserParameters() async {
    userName = _appPreferences.getUserName(USER_NAME)!;
    password = _appPreferences.getPassword(PASS)!;
    userRequest = UserRequest(email: userName!, password: password!);
  }

  // Order Report-------------------------------------------------------------
  Future<List<SalesReportDataModel>> getOrderReportByPage(
      int locationId, int pageNum) async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      emit(LoadingOrderReport());
      var res;
      String token = _appPreferences.getToken(LOGGED_IN_TOKEN)!;
      bool hasExpired = JwtDecoder.isExpired(token);
      if (hasExpired) {
        await getUserParameters();
        await login(userRequest!);

        res =
            await posRepositoryImpl.getOrderReportByPage(_appPreferences.getToken(LOGGED_IN_TOKEN)!, locationId, pageNum);
        emit(OrderReportSucceed());
        listOfOrderHead = res;
        return res;
      }

      if (await networkInfo.isConnected) {
        res =
            await posRepositoryImpl.getOrderReportByPage(token, locationId, pageNum);
        emit(OrderReportSucceed());
        listOfOrderHead = res;
        return res;
      } else {
        emit(OrdersNoInternetState());
        return res;
      }
    } catch (e) {
      emit(OrderReportError(e.toString()));
      return Future.error(e);
    }
  }

  Future<List<SalesReportDataModel>> getOrderReport(int locationId) async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      emit(LoadingAllOrderReport());
      var res;
      String token = _appPreferences.getToken(LOGGED_IN_TOKEN)!;
      bool hasExpired = JwtDecoder.isExpired(token);
      if (hasExpired) {
        await getUserParameters();
        await login(userRequest!);

        res =
        await posRepositoryImpl.getOrderReport(_appPreferences.getToken(LOGGED_IN_TOKEN)!, locationId);
        emit(AllOrderReportSucceed());
        listOfAllOrderHead = res;
        return res;
      }

      if (await networkInfo.isConnected) {
        res =
        await posRepositoryImpl.getOrderReport(token, locationId);
        emit(AllOrderReportSucceed());
        listOfAllOrderHead = res;
        return res;
      } else {
        emit(OrdersNoInternetState());
        return res;
      }
    } catch (e) {
      emit(AllOrderReportError(e.toString()));
      return Future.error(e);
    }
  }

  // Order Report Items-------------------------------------------------------------
  Future<List<SalesReportItemsResponse>> getOrderReportItems(
      int locationId, int orderId) async {
    try {
      var res;
      if (await networkInfo.isConnected) {
        await Future.delayed(const Duration(milliseconds: 500));
        emit(LoadingOrderReportItems());
        String token = _appPreferences.getToken(LOGGED_IN_TOKEN)!;
        bool hasExpired = JwtDecoder.isExpired(token);
        if (hasExpired) {
          await getUserParameters();
          await login(userRequest!);

          res = await posRepositoryImpl.getOrderReportItems(
              _appPreferences.getToken(LOGGED_IN_TOKEN)!, locationId, orderId);
          emit(OrderReportItemsSucceed());
          listOfOrderItems = res;
          return res;
        }

        res = await posRepositoryImpl.getOrderReportItems(
            token, locationId, orderId);
        emit(OrderReportItemsSucceed());
        listOfOrderItems = res;
        return res;
      } else {
        emit(OrdersNoInternetState());
        return res;
      }
    } catch (e) {
      emit(OrderReportItemsError(e.toString()));
      return Future.error(e);
    }
  }

  Future<AuthorizationResponse> login(UserRequest parameters) async {
    try {
      var res;
      if (await networkInfo.isConnected) {
        res = await posRepositoryImpl.login(parameters);
        await _appPreferences.setToken(LOGGED_IN_TOKEN, res.authorization.token);
        return res;
      } else {
        emit(OrdersNoInternetState());
        return res;
      }
    } catch (e) {
      return Future.error(e);
    }
  }
}
