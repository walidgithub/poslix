import 'package:poslix_app/pos/domain/requests/close_register_model.dart';
import 'package:poslix_app/pos/domain/requests/save_order_model.dart';
import 'package:poslix_app/pos/domain/requests/user_model.dart';
import 'package:poslix_app/pos/domain/response/appearance_model.dart';

import 'package:poslix_app/pos/domain/response/authorization_model.dart';
import 'package:poslix_app/pos/domain/response/business_model.dart';
import 'package:poslix_app/pos/domain/response/check_out_model.dart';
import 'package:poslix_app/pos/domain/response/tailoring_types_model.dart';
import 'package:poslix_app/pos/domain/response/taxes_model.dart';

import 'package:poslix_app/pos/domain/response/user_model.dart';

import '../../data/data_sources/remote/pos_repo.dart';
import '../../shared/constant/constant_values_manager.dart';
import '../../shared/core/network/dio_manager.dart';
import '../entities/customer_model.dart';
import '../requests/check_out_model.dart';
import '../requests/close_register_report_model.dart';
import '../requests/open_register_model.dart';
import '../response/brands_model.dart';
import '../response/categories_model.dart';
import '../response/close_register_model.dart';
import '../response/close_register_report_data_model.dart';
import '../response/currency_code_model.dart';
import '../response/customer_model.dart';
import '../response/logout_response.dart';
import '../response/open_register_response.dart';
import '../response/register_data_model.dart';
import '../response/sales_report_data_model.dart';
import '../response/sales_report_items_model.dart';

class POSRepositoryImpl extends POSRepository {
  final DioManager _dio;
  POSRepositoryImpl(this._dio);

  @override
  Future<UserResponse> getUserInfo(UserRequest parameters, String token) async {
    var res;
    try {
      return await _dio
          .post('${AppConstants.baseUrl}api/users',
          headers: {'Authorization': 'Bearer $token'},
          body: parameters.toJson())
          .then((response) {
        res = response.data['result']['user'];
        return UserResponse.fromJson(res);
      });
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Future<AuthorizationResponse> login(UserRequest parameters) async {
    var res;
    var statusMessage;
    try {
      return await _dio
          .post('${AppConstants.baseUrl}api/login', body: parameters.toJson())
          .then((response) {
        statusMessage = response.statusMessage;
        res = response.data['result']['authorization'];
        return AuthorizationResponse.fromJson(res);
      });
    } catch (e) {
      throw statusMessage;
    }
  }

  @override
  Future<AuthorizationResponse> refreshToken(String token) async {
    var res;
    try {
      return await _dio
          .post('${AppConstants.baseUrl}api/refresh',
              headers: {'Authorization': 'Bearer $token'})
          .then((response) {
        res = response.data['result']['authorisation'];
        return AuthorizationResponse.fromJson(res);
      });
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Future<List<UserResponse>> getPermissions(String token, int locationId) async {
    List<UserResponse> res = <UserResponse>[];
    try {
      return await _dio.get('api/users?location_id=$locationId',
          headers: {'Authorization': 'Bearer $token'}).then((response) {
        res = (response.data['result'] as List).map((e) {
          return UserResponse.fromJson(e);
        }).toList();
        return res;
      });
    } catch (e) {
      throw e.toString();
    }
  }

  // logout ------------------
  @override
  Future<LogoutResponse> logout(String token) async {
    var res;
    try {
      return await _dio.post('${AppConstants.baseUrl}api/logout',
          headers: {'Authorization': 'Bearer $token'}).then((response) {
        res = response.data['result'];
        return LogoutResponse.fromJson(res);
      });
    } catch (e) {
      throw e.toString();
    }
  }

  // Category -----------------------------------------------
  @override
  Future<List<CategoriesResponse>> getCategories(
      String token, int locationId) async {
    List<CategoriesResponse> res = <CategoriesResponse>[];
    try {
      return await _dio.get('api/categories/$locationId',
          headers: {'Authorization': 'Bearer $token'}).then((response) {
        res = (response.data['result'] as List).map((e) {
          return CategoriesResponse.fromJson(e);
        }).toList();
        return res;
      });
    } catch (e) {
      throw e.toString();
    }
  }

  // Brand -----------------------------------------------
  @override
  Future<List<BrandsResponse>> getBrands(String token, int locationId) async {
    List<BrandsResponse> res = <BrandsResponse>[];
    try {
      return await _dio.get('api/brands/$locationId',
          headers: {'Authorization': 'Bearer $token'}).then((response) {
        res = (response.data['result'] as List).map((e) {
          return BrandsResponse.fromJson(e);
        }).toList();
        return res;
      });
    } catch (e) {
      throw e.toString();
    }
  }

  // Customer -----------------------------------------------
  @override
  Future<List<CustomerResponse>> getCustomers(
      String token, int locationId) async {
    List<CustomerResponse> res = <CustomerResponse>[];
    try {
      return await _dio.get('api/customers/$locationId',
          headers: {'Authorization': 'Bearer $token'}).then((response) {
        res = (response.data['result'] as List).map((e) {
          return CustomerResponse.fromJson(e);
        }).toList();
        return res;
      });
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Future<CustomerResponse> getCustomer(int customerId, String token) async {
    var res;
    try {
      return await _dio.get('api/customers/$customerId/show',
          headers: {'Authorization': 'Bearer $token'}).then((response) {
        res = response.data['result'];
        return CustomerResponse.fromJson(res);
      });
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Future<void> addCustomer(
      String token, CustomerModel parameters, int locationId) async {
    try {
      await _dio.post('${AppConstants.baseUrl}api/customers/$locationId',
          body: parameters.toJson(),
          headers: {'Authorization': 'Bearer $token'});
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Future<void> updateCustomer(
      int customerId, String token, CustomerModel parameters) async {
    try {
      await _dio.put('${AppConstants.baseUrl}api/customers/$customerId',
          body: parameters.toJson(),
          headers: {'Authorization': 'Bearer $token'});
    } catch (e) {
      throw e.toString();
    }
  }

  // Business --------------------------------------------------------------------------
  @override
  Future<List<BusinessResponse>> getBusinesses(String token) async {
    List<BusinessResponse> res = <BusinessResponse>[];
    try {
      return await _dio.get('api/business',
          headers: {'Authorization': 'Bearer $token'}).then((response) {
        res = (response.data['result'] as List).map((e) {
          return BusinessResponse.fromJson(e);
        }).toList();
        return res;
      });
    } catch (e) {
      throw e.toString();
    }
  }

  //Taxes ---------------------------------------------------------------------------
  @override
  Future<List<TaxesResponse>> getTaxes(String token, int locationId) async {
    List<TaxesResponse> res = <TaxesResponse>[];
    try {
      return await _dio.get('api/taxes/$locationId',
          headers: {'Authorization': 'Bearer $token'}).then((response) {
        res = (response.data['result']['taxes'] as List).map((e) {
          return TaxesResponse.fromJson(e);
        }).toList();
        return res;
      });
    } catch (e) {
      throw e.toString();
    }
  }

  // Checkout ----------------------------------------------------------------------
  @override
  Future<CheckOutResponse> checkout(
      CheckOutRequest parameters, String token) async {
    var res;
    try {
      return await _dio
          .post('${AppConstants.baseUrl}api/checkout',
              headers: {'Authorization': 'Bearer $token'},
              body: parameters.toJson())
          .then((response) {
        res = response.data['result'];
        return CheckOutResponse.fromJson(res);
      });
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Future<CheckOutResponse> saveOrder(
      SaveOrder parameters, String token, int orderId) async {
    var res;
    try {
      return await _dio
          .post('${AppConstants.baseUrl}api/sales/$orderId',
          headers: {'Authorization': 'Bearer $token'},
          body: parameters.toJson())
          .then((response) {
        res = response.data['result'];
        return CheckOutResponse.fromJson(res);
      });
    } catch (e) {
      throw e.toString();
    }
  }

  // Order report
  @override
  Future<List<SalesReportDataModel>> getOrderReportByPage(
      String token, int locationId, int pageNum) async {
    List<SalesReportDataModel> res = <SalesReportDataModel>[];
    // var res;
    try {
      return await _dio.get('api/reports/sales/$locationId/?page=$pageNum',
          headers: {'Authorization': 'Bearer $token'}).then((response) {
        res = (response.data['result']['data'] as List).map((e) {
          return SalesReportDataModel.fromJson(e);
        }).toList();

        return res;
      });
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Future<List<SalesReportDataModel>> getOrderReport(
      String token, int locationId) async {
    List<SalesReportDataModel> res = <SalesReportDataModel>[];
    // var res;
    try {
      return await _dio.get('api/reports/sales/$locationId/?all_data=1',
          headers: {'Authorization': 'Bearer $token'}).then((response) {
        res = (response.data['result']['data'] as List).map((e) {
          return SalesReportDataModel.fromJson(e);
        }).toList();

        return res;
      });
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Future<List<SalesReportItemsResponse>> getOrderReportItems(
      String token, int locationId, int orderId) async {
    List<SalesReportItemsResponse> res = <SalesReportItemsResponse>[];
    try {
      return await _dio.get('api/reports/item-sales/$locationId/$orderId',
          headers: {'Authorization': 'Bearer $token'}).then((response) {
        res = (response.data['result']['data'] as List).map((e) {
          return SalesReportItemsResponse.fromJson(e);
        }).toList();
        return res;
      });
    } catch (e) {
      throw e.toString();
    }
  }

  // get register data
  @override
  Future<RegisterDataResponse> getRegisterData(int locationId, String token) async {
    var res;
    try {
      return await _dio.get('api/registration/$locationId/close',
          headers: {'Authorization': 'Bearer $token'}).then((response) {
        res = response.data['result'];
        return RegisterDataResponse.fromJson(res);
      });
    } catch (e) {
      throw e.toString();
    }
  }

  // close register ------------------
  @override
  Future<CloseRegisterResponse> closeRegister(
      CloseRegisterRequest parameters, int locationId, String token) async {
    var res;
    try {
      return await _dio.post(
          '${AppConstants.baseUrl}api/registration/$locationId/close',
          body: parameters.toJson(),
          headers: {'Authorization': 'Bearer $token'}).then((response) {
        res = response.data['result'];
        return CloseRegisterResponse.fromJson(res);
      });
    } catch (e) {
      throw e.toString();
    }
  }

  // open register ------------------
  @override
  Future<OpenRegisterResponse> openRegister(
      final OpenRegisterRequest parameters,
      int locationId,
      String token) async {
    var res;
    try {
      return await _dio.post(
          '${AppConstants.baseUrl}api/registration/$locationId/open',
          body: parameters.toJson(),
          headers: {'Authorization': 'Bearer $token'}).then((response) {
        res = response.data['result'];
        return OpenRegisterResponse.fromJson(res);
      });
    } catch (e) {
      throw e.toString();
    }
  }

  // open and close register report
  @override
  Future<List<CloseRegisterReportDataResponse>> openCloseRegister(final CloseRegisterReportRequest parameters,
      int locationId, String token) async {
      List<CloseRegisterReportDataResponse> res = <CloseRegisterReportDataResponse>[];
      try {
        return await _dio.get('api/reports/register/$locationId',
            parameters: parameters.toJson(),
            headers: {'Authorization': 'Bearer $token'}).then((response) {
          res = (response.data['result']['data']['data'] as List).map((e) {
            return CloseRegisterReportDataResponse.fromJson(e);
          }).toList();
          return res;
        });
    } catch (e) {
      throw e.toString();
    }
  }

  // currency -----------------------------
  @override
  Future<CurrencyCodeResponse> getCurrency(
      String token, final int locationId) async {
    var res;
    try {
      return await _dio.get('api/currencies?location_id=$locationId',
          headers: {'Authorization': 'Bearer $token'}).then((response) {
        res = response.data['result'];
        return CurrencyCodeResponse.fromJson(res);
      });
    } catch (e) {
      throw e.toString();
    }
  }

  // Appearance -----------------------------
  @override
  Future<AppearanceResponse> getAppearance(String token, int locationId) async {
    var res;
    try {
      return await _dio.get('api/appearance/$locationId',
          headers: {'Authorization': 'Bearer $token'}).then((response) {
        res = response.data['result'];
        return AppearanceResponse.fromJson(res);
      });
    } catch (e) {
      throw e.toString();
    }
  }

  //Tailoring
  @override
  Future<TailoringTypesModel> getTailoringTypeById(String token, int typeId) async {
    var res;
    try {
      return await _dio.get('api/tailoring-package-types/$typeId/show',
          headers: {'Authorization': 'Bearer $token'}).then((response) {
        res = response.data['result'];
        return TailoringTypesModel.fromJson(res);
      });
    } catch (e) {
      throw e.toString();
    }
  }
}
