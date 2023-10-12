import 'package:poslix_app/pos/domain/requests/close_register_model.dart';
import 'package:poslix_app/pos/domain/requests/open_register_model.dart';
import 'package:poslix_app/pos/domain/response/business_model.dart';
import 'package:poslix_app/pos/domain/response/register_data_model.dart';
import 'package:poslix_app/pos/domain/response/sales_report_items_model.dart';

import '../../../domain/entities/customer_model.dart';
import '../../../domain/requests/check_out_model.dart';
import '../../../domain/requests/close_register_report_model.dart';
import '../../../domain/requests/save_order_model.dart';
import '../../../domain/requests/user_model.dart';
import '../../../domain/response/appearance_model.dart';
import '../../../domain/response/authorization_model.dart';
import '../../../domain/response/brands_model.dart';
import '../../../domain/response/categories_model.dart';
import '../../../domain/response/check_out_model.dart';
import '../../../domain/response/close_register_model.dart';
import '../../../domain/response/close_register_report_data_model.dart';
import '../../../domain/response/currency_code_model.dart';
import '../../../domain/response/customer_model.dart';
import '../../../domain/response/get_customer_model.dart';
import '../../../domain/response/location_settings_model.dart';
import '../../../domain/response/login_model.dart';
import '../../../domain/response/logout_response.dart';
import '../../../domain/response/open_register_response.dart';
import '../../../domain/response/payment_method_model.dart';
import '../../../domain/response/payment_methods_model.dart';
import '../../../domain/response/printing_settings_model.dart';
import '../../../domain/response/sales_report_data_model.dart';
import '../../../domain/response/tailoring_types_model.dart';
import '../../../domain/response/taxes_model.dart';
import '../../../domain/response/user_model.dart';

abstract class POSRepository {
  Future<LoginResponse> login(final UserRequest parameters);
  Future<AuthorizationResponse> refreshToken(final String token);

  Future<LogoutResponse> logout(final String token);

  Future<List<BusinessResponse>> getBusinesses(final String token);
  Future<List<PrintSettingResponse>> getPrintingSettings(final String token, final int locationId);
  Future<LocationSettingsResponse> getLocationSettings(String token, int locationId);
  Future<List<TaxesResponse>> getTaxes(final String token, final int locationId);

  Future<List<CategoriesResponse>> getCategories(final String token, final int locationId);
  Future<List<BrandsResponse>> getBrands(final String token, final int locationId);

  Future<TailoringTypesModel> getTailoringTypeById(final String token, int typeId);

  Future<List<CustomerResponse>> getCustomers(final String token, final int locationId);
  Future<GetCustomerResponse> getCustomer(final int customerId, final String token);
  Future<void> addCustomer(final String token, final CustomerModel parameters, final int locationId);
  Future<void> updateCustomer(final int customerId, final String token, final CustomerModel parameters);

  Future<CheckOutResponse> checkout(final CheckOutRequest parameters, String token);
  Future<CheckOutResponse> saveOrder(final SaveOrder parameters, String token, int orderId);
  Future<List<PaymentMethodModel>> getPaymentMethods(final String token, final int locationId);

  Future<CloseRegisterResponse> closeRegister(final CloseRegisterRequest parameters, int locationId, String token);
  Future<RegisterDataResponse> getRegisterData(int locationId, String token);
  Future<OpenRegisterResponse> openRegister(final OpenRegisterRequest parameters, int locationId, String token);
  Future<List<CloseRegisterReportDataResponse>> openCloseRegister(final CloseRegisterReportRequest parameters, int locationId, String token);

  Future<List<SalesReportDataModel>> getOrderReportByPage(String token, final int locationId, int pageNum);
  Future<List<SalesReportDataModel>> getOrderReport(String token, final int locationId);
  Future<List<SalesReportItemsResponse>> getOrderReportItems(String token, final int locationId, final int orderId);

  Future<CurrencyCodeResponse> getCurrency(String token, final int locationId);

  Future<AppearanceResponse> getAppearance(String token, final int locationId);
}