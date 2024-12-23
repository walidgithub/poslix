import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:poslix_app/pos/domain/response/check_out_model.dart';
import 'package:poslix_app/pos/domain/response/currency_code_model.dart';
import 'package:poslix_app/pos/domain/response/customer_model.dart';
import 'package:poslix_app/pos/domain/response/products_model.dart';
import 'package:poslix_app/pos/domain/response/register_data_model.dart';
import 'package:poslix_app/pos/domain/response/variations_model.dart';
import '../../../../domain/repositories/pos_local_repo_impl.dart';
import '../../../../domain/repositories/pos_repo_impl.dart';
import '../../../../domain/requests/check_out_model.dart';
import '../../../../domain/requests/close_register_model.dart';
import '../../../../domain/requests/close_register_report_model.dart';
import '../../../../domain/requests/customer_model.dart';
import '../../../../domain/requests/user_model.dart';
import '../../../../domain/response/appearance_model.dart';
import '../../../../domain/response/authorization_model.dart';
import '../../../../domain/response/brands_model.dart';
import '../../../../domain/response/categories_model.dart';
import '../../../../domain/response/close_register_model.dart';
import '../../../../domain/response/close_register_report_data_model.dart';
import '../../../../domain/response/get_customer_model.dart';
import '../../../../domain/response/location_settings_model.dart';
import '../../../../domain/response/login_model.dart';
import '../../../../domain/response/payment_method_model.dart';
import '../../../../domain/response/payment_methods_model.dart';
import '../../../../domain/response/pricing_group_model.dart';
import '../../../../domain/entities/printing_settings_model.dart';
import '../../../../domain/response/stocks_model.dart';
import '../../../../domain/response/tailoring_types_model.dart';
import '../../../../domain/response/user_model.dart';
import '../../../../shared/core/network/network_info.dart';
import '../../../../shared/preferences/app_pref.dart';
import '../../../di/di.dart';
import 'main_view_state.dart';

class MainViewCubit extends Cubit<MainViewState> {
  MainViewCubit(this.posRepositoryImpl, this.posLocalRepositoryImpl) : super(MainViewInitial());

  POSRepositoryImpl posRepositoryImpl;
  POSLocalRepositoryImp posLocalRepositoryImpl;

  static MainViewCubit get(context) => BlocProvider.of(context);

  final AppPreferences _appPreferences = sl<AppPreferences>();
  final NetworkInfo networkInfo = sl<NetworkInfo>();

  List<CategoriesResponse> listOfCategories = [];
  List<BrandsResponse> listOfBrands = [];

  List<ProductsResponse> listOfProducts = [];
  List<VariationsResponse> listOfVariations = [];
  List<StocksResponse> listOfStocks = [];

  List<PaymentMethodModel> listOfPaymentMethods = [];

  TailoringTypesModel? tailoringType;

  List<CustomerResponse> listOfCustomers = [];
  List<PricingGroupResponse> listOfPricingGroups = [];

  int? cashInHand;
  double? totalCash;
  double? totalCheque;
  double? totalBank;
  double? totalCart;

  String? userName;
  String? password;
  UserRequest? userRequest;

  String currencyCode = '';

  Future<void> getUserParameters() async {
    userName = _appPreferences.getUserName(USER_NAME)!;
    password = _appPreferences.getPassword(PASS)!;
    userRequest = UserRequest(email: userName!, password: password!);
  }

  Future<void> getHomeData(int locationId) async {
    try {
      if (await networkInfo.isConnected) {
        await Future.delayed(const Duration(seconds: 1));
        emit(LoadingHomeData());

        String token = _appPreferences.getToken(LOGGED_IN_TOKEN)!;

        bool hasExpired = JwtDecoder.isExpired(token);
        if (hasExpired) {
          await getUserParameters();
          await login(userRequest!);

         // Categories -----
          var res = await posRepositoryImpl.getCategories(
              _appPreferences.getToken(LOGGED_IN_TOKEN)!, locationId);
          listOfCategories = res.toList();

          listOfProducts = listOfCategories[0].products;
          listOfVariations = listOfCategories[0].products.isNotEmpty
              ? listOfCategories[0].products[0].variations
              : [];
          listOfStocks = listOfCategories[0].products.isNotEmpty
              ? listOfCategories[0].products[0].stocks
              : [];

          // Customers -----
          var res2 = await posRepositoryImpl.getCustomers(_appPreferences.getToken(LOGGED_IN_TOKEN)!, locationId);
          listOfCustomers = res2.toList();

          // PricingGroups ----
          var res4 = await posRepositoryImpl.getPricingGroups(_appPreferences.getToken(LOGGED_IN_TOKEN)!, locationId);
          listOfPricingGroups = res4.toList();

          // Currency ----
          var res3 = await posRepositoryImpl.getCurrency(_appPreferences.getToken(LOGGED_IN_TOKEN)!, locationId);
          currencyCode = res3.code;

          emit(LoadedHomeData());
        }

        // Categories -----
        var res = await posRepositoryImpl.getCategories(
            token, locationId);
        listOfCategories = res.toList();

        listOfProducts = listOfCategories[0].products;
        listOfVariations = listOfCategories[0].products.isNotEmpty
            ? listOfCategories[0].products[0].variations
            : [];
        listOfStocks = listOfCategories[0].products.isNotEmpty
            ? listOfCategories[0].products[0].stocks
            : [];

        // Customers -----
        var res2 = await posRepositoryImpl.getCustomers(token, locationId);
        listOfCustomers = res2.toList();

        // PricingGroups ----
        var res4 = await posRepositoryImpl.getPricingGroups(token, locationId);
        listOfPricingGroups = res4.toList();

        // Currency ----
        var res3 = await posRepositoryImpl.getCurrency(token, locationId);
        currencyCode = res3.code;

        emit(LoadedHomeData());
      } else {
        emit(MainNoInternetState());
      }
    } catch (e) {
      emit(LoadingErrorHomeData(e.toString()));
      return Future.error(e);
    }
  }

  // Category ----------------------------------------------------------------
  Future<List<CategoriesResponse>> getCategories(int locationId) async {
    try {
      var res;
      if (await networkInfo.isConnected) {
        await Future.delayed(const Duration(seconds: 1));
        emit(LoadingCategories());
        String token = _appPreferences.getToken(LOGGED_IN_TOKEN)!;

        bool hasExpired = JwtDecoder.isExpired(token);
        if (hasExpired) {
          await getUserParameters();
          await login(userRequest!);

          res = await posRepositoryImpl.getCategories(
              _appPreferences.getToken(LOGGED_IN_TOKEN)!, locationId);
          listOfCategories = res.toList();

          listOfProducts = listOfCategories[0].products;
          listOfVariations = listOfCategories[0].products.isNotEmpty
              ? listOfCategories[0].products[0].variations
              : [];
          listOfStocks = listOfCategories[0].products.isNotEmpty
              ? listOfCategories[0].products[0].stocks
              : [];
          emit(LoadedCategories());
          return res;
        }

        res = await posRepositoryImpl.getCategories(token, locationId);
        listOfCategories = res.toList();

        listOfProducts = listOfCategories[0].products;
        listOfVariations = listOfCategories[0].products.isNotEmpty
            ? listOfCategories[0].products[0].variations
            : [];
        listOfStocks = listOfCategories[0].products.isNotEmpty
            ? listOfCategories[0].products[0].stocks
            : [];
        emit(LoadedCategories());
        return res;
      } else {
        emit(MainNoInternetState());
        return [];
      }
    } catch (e) {
      emit(LoadingErrorCategories(e.toString()));
      return Future.error(e);
    }
  }

  // Brand ----------------------------------------------------------------
  Future<List<BrandsResponse>> getBrands(int locationId) async {
    try {
      var res;
      if (await networkInfo.isConnected) {
        await Future.delayed(const Duration(seconds: 1));
        emit(LoadingBrands());
        String token = _appPreferences.getToken(LOGGED_IN_TOKEN)!;
        bool hasExpired = JwtDecoder.isExpired(token);
        if (hasExpired) {
          await getUserParameters();
          await login(userRequest!);

          res = await posRepositoryImpl.getBrands(
              _appPreferences.getToken(LOGGED_IN_TOKEN)!, locationId);

          emit(LoadedBrands());
          listOfBrands = res.toList();

          listOfProducts = listOfBrands[0].products;
          listOfVariations = listOfCategories[0].products.isNotEmpty
              ? listOfCategories[0].products[0].variations
              : [];
          listOfStocks = listOfCategories[0].products.isNotEmpty
              ? listOfCategories[0].products[0].stocks
              : [];
          return res;
        }
        res = await posRepositoryImpl.getBrands(token, locationId);

        emit(LoadedBrands());
        listOfBrands = res.toList();

        listOfProducts = listOfBrands[0].products;
        listOfVariations = listOfCategories[0].products.isNotEmpty
            ? listOfCategories[0].products[0].variations
            : [];
        listOfStocks = listOfCategories[0].products.isNotEmpty
            ? listOfCategories[0].products[0].stocks
            : [];
        return res;
      } else {
        emit(MainNoInternetState());
        return [];
      }
    } catch (e) {
      emit(LoadingErrorBrands(e.toString()));
      return Future.error(e);
    }
  }

  // Customer ----------------------------------------------------------------
  Future<List<CustomerResponse>> getCustomers(int locationId) async {
    try {
      var res;
      if (await networkInfo.isConnected) {
        await Future.delayed(const Duration(seconds: 1));
        emit(LoadingCustomers());
        String token = _appPreferences.getToken(LOGGED_IN_TOKEN)!;
        bool hasExpired = JwtDecoder.isExpired(token);
        if (hasExpired) {
          await getUserParameters();
          await login(userRequest!);

          res = await posRepositoryImpl.getCustomers(_appPreferences.getToken(LOGGED_IN_TOKEN)!, locationId);
          emit(LoadedCustomers());
          listOfCustomers = res.toList();
          return res;
        }

        res = await posRepositoryImpl.getCustomers(token, locationId);
        emit(LoadedCustomers());
        listOfCustomers = res.toList();
        return res;
      } else {
        emit(MainNoInternetState());
        return [];
      }
    } catch (e) {
      emit(LoadingErrorCustomers(e.toString()));
      return Future.error(e);
    }
  }

  Future<List<PricingGroupResponse>> getPricingGroups(int locationId) async {
    try {
      var res;
      if (await networkInfo.isConnected) {
        String token = _appPreferences.getToken(LOGGED_IN_TOKEN)!;
        bool hasExpired = JwtDecoder.isExpired(token);
        if (hasExpired) {
          await getUserParameters();
          await login(userRequest!);

          res = await posRepositoryImpl.getPricingGroups(_appPreferences.getToken(LOGGED_IN_TOKEN)!, locationId);
          emit(LoadedPricingGroups());
          listOfPricingGroups = res.toList();
          return res;
        }

        res = await posRepositoryImpl.getPricingGroups(token, locationId);
        emit(LoadedPricingGroups());
        listOfPricingGroups = res.toList();
        return res;
      } else {
        emit(MainNoInternetState());
        return [];
      }
    } catch (e) {
      emit(LoadingErrorPricingGroups(e.toString()));
      return Future.error(e);
    }
  }

  Future<GetCustomerResponse> getCustomer(int customerId) async {
    try {
      var res;
      if (await networkInfo.isConnected) {
        await Future.delayed(const Duration(seconds: 1));
        emit(LoadingCustomer());
        String token = _appPreferences.getToken(LOGGED_IN_TOKEN)!;
        bool hasExpired = JwtDecoder.isExpired(token);
        if (hasExpired) {
          await getUserParameters();
          await login(userRequest!);

          res = await posRepositoryImpl.getCustomer(customerId, _appPreferences.getToken(LOGGED_IN_TOKEN)!);
          emit(LoadedCustomer());
          return res;
        }

        res = await posRepositoryImpl.getCustomer(customerId, token);
        emit(LoadedCustomer());
        return res;
      } else {
        emit(MainNoInternetState());
        return res;
      }
    } catch (e) {
      emit(LoadingErrorCustomer(e.toString()));
      return Future.error(e);
    }
  }

  Future<void> addCustomer(CustomerRequest parameters, int locationId) async {
    try {
      if (await networkInfo.isConnected) {
        String token = _appPreferences.getToken(LOGGED_IN_TOKEN)!;
        bool hasExpired = JwtDecoder.isExpired(token);
        if (hasExpired) {
          await getUserParameters();
          await login(userRequest!);

          await posRepositoryImpl.addCustomer(_appPreferences.getToken(LOGGED_IN_TOKEN)!, parameters, locationId);
          emit(CustomerAddedSucceed());

          return;
        }

        await posRepositoryImpl.addCustomer(token, parameters, locationId);
        emit(CustomerAddedSucceed());
      } else {
        emit(MainNoInternetState());
      }
    } catch (e) {
      emit(CustomerAddError(e.toString()));
      return Future.error(e);
    }
  }

  Future<void> updateCustomer(int customerId, CustomerRequest parameters) async {
    try {
      if (await networkInfo.isConnected) {
        String token = _appPreferences.getToken(LOGGED_IN_TOKEN)!;
        bool hasExpired = JwtDecoder.isExpired(token);
        if (hasExpired) {
          await getUserParameters();
          await login(userRequest!);

          await posRepositoryImpl.updateCustomer(customerId, _appPreferences.getToken(LOGGED_IN_TOKEN)!, parameters);
          emit(CustomerUpdatedSucceed());

          return;
        }

        await posRepositoryImpl.updateCustomer(customerId, token, parameters);
        emit(CustomerUpdatedSucceed());
      } else {
        emit(MainNoInternetState());
      }
    } catch (e) {
      emit(CustomerUpdateError(e.toString()));
      return Future.error(e);
    }
  }

  // Check out-------------------------------------------------------------
  Future<CheckOutResponse> checkout(CheckOutRequest parameters) async {
    try {
      var res;
      if (await networkInfo.isConnected) {
        String token = _appPreferences.getToken(LOGGED_IN_TOKEN)!;
        bool hasExpired = JwtDecoder.isExpired(token);
        if (hasExpired) {
          await getUserParameters();
          await login(userRequest!);

          res = await posRepositoryImpl.checkout(parameters, _appPreferences.getToken(LOGGED_IN_TOKEN)!);
          emit(CheckOutSucceed(res));
          return res;
        }

        res = await posRepositoryImpl.checkout(parameters, token);
        emit(CheckOutSucceed(res));
        return res;
      } else {
        emit(MainNoInternetState());
        return res;
      }
    } catch (e) {
      emit(CheckOutError(e.toString()));
      return Future.error(e);
    }
  }

  Future<List<PaymentMethodModel>> getPaymentMethods(int locationId) async {
    try {
      var res;
      if (await networkInfo.isConnected) {
        await Future.delayed(const Duration(seconds: 1));
        emit(LoadingPaymentMethods());
        String token = _appPreferences.getToken(LOGGED_IN_TOKEN)!;
        bool hasExpired = JwtDecoder.isExpired(token);
        if (hasExpired) {
          await getUserParameters();
          await login(userRequest!);

          res = await posRepositoryImpl.getPaymentMethods(_appPreferences.getToken(LOGGED_IN_TOKEN)!, locationId);
          listOfPaymentMethods = res;
          emit(LoadedPaymentMethods());
          return res;
        }
        res = await posRepositoryImpl.getPaymentMethods(token, locationId);
        listOfPaymentMethods = res;
        emit(LoadedPaymentMethods());
        return res;
      } else {
        emit(MainNoInternetState());
        return res;
      }
    } catch (e) {
      emit(LoadingPaymentMethodsError(e.toString()));
      return Future.error(e);
    }
  }

  // close register ------------------
  Future<CloseRegisterResponse> closeRegister(
      CloseRegisterRequest parameters, int locationId) async {
    try {
      var res;
      if (await networkInfo.isConnected) {
        String token = _appPreferences.getToken(LOGGED_IN_TOKEN)!;
        bool hasExpired = JwtDecoder.isExpired(token);
        if (hasExpired) {
          await getUserParameters();
          await login(userRequest!);

          res = await posRepositoryImpl.closeRegister(
              parameters, locationId, _appPreferences.getToken(LOGGED_IN_TOKEN)!);
          emit(CloseRegisterSucceed());
          return res;
        }

        res = await posRepositoryImpl.closeRegister(
            parameters, locationId, token);
        emit(CloseRegisterSucceed());
        return res;
      } else {
        emit(MainNoInternetState());
        return res;
      }
    } catch (e) {
      emit(CloseRegisterError(e.toString()));
      return Future.error(e);
    }
  }

  // open and close register report------------------
  Future<List<CloseRegisterReportDataResponse>> openCloseRegister(
      CloseRegisterReportRequest parameters, int locationId) async {
    try {
      await Future.delayed(const Duration(seconds: 1));
      emit(OpenCloseRegisterLoading());
      var res;
      String? userInfo;
      UserResponse? userResponse;
      userInfo = _appPreferences.getUserInfo(PREFS_KEY_USER_INFO)!;
      userResponse = UserResponse.fromJson(jsonDecode(userInfo));
      if (await networkInfo.isConnected) {
        String token = _appPreferences.getToken(LOGGED_IN_TOKEN)!;
        bool hasExpired = JwtDecoder.isExpired(token);
        if (hasExpired) {
          await getUserParameters();
          await login(userRequest!);

          res = await posRepositoryImpl.openCloseRegister(
              parameters, locationId, _appPreferences.getToken(LOGGED_IN_TOKEN)!);

          var statusCounts  = res.firstWhere((element) => element.firstName == userResponse!.firstName && element.status == 'open');
          String handCash_ = statusCounts.handCash;
          cashInHand = int.parse(handCash_.substring(0, handCash_.indexOf('.')));

          emit(OpenCloseRegisterSucceed());
          return res;
        }

        res = await posRepositoryImpl.openCloseRegister(
            parameters, locationId, token);

        var statusCounts  = res.firstWhere((element) => element.firstName == userResponse!.firstName && element.status == 'open');
        String handCash_ = statusCounts.handCash;
        cashInHand = int.parse(handCash_.substring(0, handCash_.indexOf('.')));

        emit(OpenCloseRegisterSucceed());
        return res;
      } else {
        emit(MainNoInternetState());
        return [];
      }
    } catch (e) {
      emit(OpenCloseRegisterError(e.toString()));
      return Future.error(e);
    }
  }

  // get cash data ---------------
  Future<RegisterDataResponse> getRegisterData(int locationId) async {
    try {
      var res;
      if (await networkInfo.isConnected) {
        String token = _appPreferences.getToken(LOGGED_IN_TOKEN)!;
        bool hasExpired = JwtDecoder.isExpired(token);
        if (hasExpired) {
          await getUserParameters();
          await login(userRequest!);

          res = await posRepositoryImpl.getRegisterData(locationId, _appPreferences.getToken(LOGGED_IN_TOKEN)!);

          totalBank = res.bank;
          totalCheque = res.cheque;
          totalCash = res.cash;
          totalCart = res.card;

          emit(LoadedRegisterData());
          return res;
        }

        res = await posRepositoryImpl.getRegisterData(locationId, token);

        totalBank = res.bank;
        totalCheque = res.cheque;
        totalCash = res.cash;
        totalCart = res.card;

        emit(LoadedRegisterData());
        return res;
      } else {
        emit(MainNoInternetState());
        return res;
      }
    } catch (e) {
      emit(LoadingErrorRegisterData(e.toString()));
      return Future.error(e);
    }
  }

  // get currency -----------------------------------
  Future<CurrencyCodeResponse> getCurrency(int locationId) async {
    try {
      var res;
      if (await networkInfo.isConnected) {
        await Future.delayed(const Duration(seconds: 1));
        emit(LoadingCurrency());
        String token = _appPreferences.getToken(LOGGED_IN_TOKEN)!;
        bool hasExpired = JwtDecoder.isExpired(token);
        if (hasExpired) {
          await getUserParameters();
          await login(userRequest!);

          res = await posRepositoryImpl.getCurrency(_appPreferences.getToken(LOGGED_IN_TOKEN)!, locationId);
          emit(LoadedCurrency(res.code));
          return res;
        }

        res = await posRepositoryImpl.getCurrency(token, locationId);
        emit(LoadedCurrency(res.code));
        return res;
      } else {
        emit(MainNoInternetState());
        return res;
      }
    } catch (e) {
      emit(LoadingErrorCurrency(e.toString()));
      return Future.error(e);
    }
  }

  // Appearance -----------------------------
  Future<AppearanceResponse> getAppearance(int locationId) async {
    try {
      var res;
      if (await networkInfo.isConnected) {
        await Future.delayed(const Duration(seconds: 1));
        emit(LoadingAppearance());
        String token = _appPreferences.getToken(LOGGED_IN_TOKEN)!;
        bool hasExpired = JwtDecoder.isExpired(token);
        if (hasExpired) {
          await getUserParameters();
          await login(userRequest!);

          res = await posRepositoryImpl.getAppearance(_appPreferences.getToken(LOGGED_IN_TOKEN)!, locationId);
          emit(LoadedAppearance(res));
          return res;
        }

        res = await posRepositoryImpl.getAppearance(token, locationId);
        emit(LoadedAppearance(res));
        return res;
      } else {
        emit(MainNoInternetState());
        return res;
      }
    } catch (e) {
      emit(LoadingErrorAppearance(e.toString()));
      return Future.error(e);
    }
  }

  // Printing Settings -----------------------------
  Future<void> addPrintingSetting(PrintSettingModel printSettingModel) async {
    try {
      await posLocalRepositoryImpl.addPrintingSetting(printSettingModel);
      emit(InsertPrintingSettings());
    } catch (e) {
      emit(InsertErrorPrintingSettings(e.toString()));
    }
  }

  Future<void> deletePrintingSetting(int printerId) async {
    try {
      await posLocalRepositoryImpl.deletePrintingSetting(printerId);
      emit(DeletePrintingSettings());
    } catch (e) {
      emit(DeleteErrorPrintingSettings(e.toString()));
    }
  }

  Future<void> updateAllPrintingSetting() async {
    try {
      await posLocalRepositoryImpl.updateAllPrintingSetting();
      emit(UpdatePrintingSettings());
    } catch (e) {
      emit(UpdateErrorPrintingSettings(e.toString()));
    }
  }

  Future<void> updatePrintingSetting(PrintSettingModel printSettingModel, int printerId) async {
    try {
      await posLocalRepositoryImpl.updatePrintingSetting(printSettingModel, printerId);
      emit(UpdatePrintingSettings());
    } catch (e) {
      emit(UpdateErrorPrintingSettings(e.toString()));
    }
  }

  Future<List<PrintSettingModel>> getPrintingSettings() async {
    try {
      final res = await posLocalRepositoryImpl.getPrintingSettings();
      emit(LoadedPrintingSettings(res));
      return res;
    } catch (e) {
      emit(LoadingErrorPrintingSettings(e.toString()));
      return Future.error(e);
    }
  }

  Future<PrintSettingModel> getPrinterById(int printerId) async {
    try {
      final res = await posLocalRepositoryImpl.getPrinterById(printerId);
      emit(LoadedByIdPrintingSettings(res));
      return res;
    } catch (e) {
      emit(LoadingByIdErrorPrintingSettings(e.toString()));
      return Future.error(e);
    }
  }

  Future<LocationSettingsResponse> getLocationSettings(int locationId) async {
    try {
      var res;
      if (await networkInfo.isConnected) {
        String token = _appPreferences.getToken(LOGGED_IN_TOKEN)!;
        bool hasExpired = JwtDecoder.isExpired(token);
        if (hasExpired) {
          await getUserParameters();
          await login(userRequest!);

          res = await posRepositoryImpl.getLocationSettings(_appPreferences.getToken(LOGGED_IN_TOKEN)!, locationId);
          emit(LoadedLocationSettings(res));
          return res;
        }

        res = await posRepositoryImpl.getLocationSettings(token, locationId);
        emit(LoadedLocationSettings(res));
        return res;
      } else {
        emit(MainNoInternetState());
        return res;
      }
    } catch (e) {
      emit(LoadingErrorLocationSettings(e.toString()));
      return Future.error(e);
    }
  }

  // Tailoring Types Id
  Future<TailoringTypesModel> getTailoringTypeById(int typeId) async {
    try {
      var res;
      if (await networkInfo.isConnected) {
        await Future.delayed(const Duration(seconds: 1));
        emit(LoadingTailoringTypes());
        String token = _appPreferences.getToken(LOGGED_IN_TOKEN)!;
        bool hasExpired = JwtDecoder.isExpired(token);
        if (hasExpired) {
          await getUserParameters();
          await login(userRequest!);

          res = await posRepositoryImpl.getTailoringTypeById(_appPreferences.getToken(LOGGED_IN_TOKEN)!, typeId);
          tailoringType = res;
          emit(LoadedTailoringTypes());
          return res;
        }

        res = await posRepositoryImpl.getTailoringTypeById(token, typeId);
        tailoringType = res;
        emit(LoadedTailoringTypes());
        return res;
      } else {
        emit(MainNoInternetState());
        return res;
      }
    } catch (e) {
      emit(LoadingErrorTailoringTypes(e.toString()));
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
        emit(MainNoInternetState());
        return res;
      }
    } catch (e) {
      return Future.error(e);
    }
  }
}
