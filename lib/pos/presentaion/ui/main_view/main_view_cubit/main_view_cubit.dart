import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:poslix_app/pos/domain/response/check_out_model.dart';
import 'package:poslix_app/pos/domain/response/currency_code_model.dart';
import 'package:poslix_app/pos/domain/response/customer_model.dart';
import 'package:poslix_app/pos/domain/response/packages_model.dart';
import 'package:poslix_app/pos/domain/response/products_model.dart';
import 'package:poslix_app/pos/domain/response/register_data_model.dart';
import 'package:poslix_app/pos/domain/response/variations_model.dart';
import '../../../../domain/entities/customer_model.dart';
import '../../../../domain/repositories/pos_repo_impl.dart';
import '../../../../domain/requests/check_out_model.dart';
import '../../../../domain/requests/close_register_model.dart';
import '../../../../domain/requests/close_register_report_model.dart';
import '../../../../domain/requests/user_model.dart';
import '../../../../domain/response/appearance_model.dart';
import '../../../../domain/response/authorization_model.dart';
import '../../../../domain/response/brands_model.dart';
import '../../../../domain/response/categories_model.dart';
import '../../../../domain/response/close_register_model.dart';
import '../../../../domain/response/close_register_report_data_model.dart';
import '../../../../domain/response/stocks_model.dart';
import '../../../../domain/response/tailoring_types_model.dart';
import '../../../../shared/core/network/network_info.dart';
import '../../../../shared/preferences/app_pref.dart';
import '../../../di/di.dart';
import 'main_view_state.dart';

class MainViewCubit extends Cubit<MainViewState> {
  MainViewCubit(this.posRepositoryImpl) : super(MainViewInitial());

  POSRepositoryImpl posRepositoryImpl;

  static MainViewCubit get(context) => BlocProvider.of(context);

  final AppPreferences _appPreferences = sl<AppPreferences>();
  final NetworkInfo networkInfo = sl<NetworkInfo>();

  List<CategoriesResponse> listOfCategories = [];
  List<BrandsResponse> listOfBrands = [];

  List<ProductsResponse> listOfProducts = [];
  List<VariationsResponse> listOfVariations = [];
  List<StocksResponse> listOfStocks = [];

  List<TailoringTypesModel> listOfTailoringTypes = [];

  List<CustomerResponse> listOfCustomers = [];

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

          // Currency ----
          var res3 = await posRepositoryImpl.getCurrency(_appPreferences.getToken(LOGGED_IN_TOKEN)!, locationId);
          currencyCode = res3.code;

          // Tailoring types
          var res4 = await posRepositoryImpl.getTailoringTypes(_appPreferences.getToken(LOGGED_IN_TOKEN)!, locationId);
          listOfTailoringTypes = res4.toList();

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

        // Currency ----
        var res3 = await posRepositoryImpl.getCurrency(token, locationId);
        currencyCode = res3.code;

        // Tailoring types
        var res4 = await posRepositoryImpl.getTailoringTypes(token, locationId);
        listOfTailoringTypes = res4.toList();

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

  Future<CustomerResponse> getCustomer(int customerId) async {
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

  Future<void> addCustomer(CustomerModel parameters, int locationId) async {
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

  Future<void> updateCustomer(int customerId, CustomerModel parameters) async {
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
      var res;
      if (await networkInfo.isConnected) {
        String token = _appPreferences.getToken(LOGGED_IN_TOKEN)!;
        bool hasExpired = JwtDecoder.isExpired(token);
        if (hasExpired) {
          await getUserParameters();
          await login(userRequest!);

          res = await posRepositoryImpl.openCloseRegister(
              parameters, locationId, _appPreferences.getToken(LOGGED_IN_TOKEN)!);
          if (res[0].status == 'open') {
            String handCash_ = res[0].handCash;
            cashInHand =
                int.parse(handCash_.substring(0, handCash_.indexOf('.')));
          } else {
            cashInHand = 0;
          }
          emit(OpenCloseRegisterSucceed());
          return res;
        }

        res = await posRepositoryImpl.openCloseRegister(
            parameters, locationId, token);
        if (res[0].status == 'open') {
          String handCash_ = res[0].handCash;
          cashInHand =
              int.parse(handCash_.substring(0, handCash_.indexOf('.')));
        } else {
          cashInHand = 0;
        }
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

  //Tailoring
  Future<List<TailoringTypesModel>> getTailoringTypes(int locationId) async {
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

          res = await posRepositoryImpl.getTailoringTypes(_appPreferences.getToken(LOGGED_IN_TOKEN)!, locationId);
          emit(LoadedTailoringTypes());
          listOfTailoringTypes = res.toList();
          return res;
        }

        res = await posRepositoryImpl.getTailoringTypes(token, locationId);
        emit(LoadedTailoringTypes());
        listOfTailoringTypes = res.toList();
        return res;
      } else {
        emit(MainNoInternetState());
        return [];
      }
    } catch (e) {
      emit(LoadingErrorTailoringTypes(e.toString()));
      return Future.error(e);
    }
  }

  Future<AuthorizationResponse> login(UserRequest parameters) async {
    try {
      var res;
      if (await networkInfo.isConnected) {
        res = await posRepositoryImpl.login(parameters);
        await _appPreferences.setToken(LOGGED_IN_TOKEN, res.token);
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
