import '../../../../domain/response/appearance_model.dart';
import '../../../../domain/response/check_out_model.dart';
import '../../../../domain/response/location_settings_model.dart';
import '../../../../domain/entities/printing_settings_model.dart';

abstract class MainViewState{}

class MainViewInitial extends MainViewState{}

class LoadingHomeData extends MainViewState{}
class LoadedHomeData extends MainViewState{}
class LoadingErrorHomeData extends MainViewState{
  String errorText;

  LoadingErrorHomeData(this.errorText);
}

class LoadingCategories extends MainViewState{}
class LoadedCategories extends MainViewState{}
class LoadingErrorCategories extends MainViewState{
  String errorText;

  LoadingErrorCategories(this.errorText);
}

class LoadingBrands extends MainViewState{}
class LoadedBrands extends MainViewState{}
class LoadingErrorBrands extends MainViewState{
  String errorText;

  LoadingErrorBrands(this.errorText);
}

class LoadingCustomers extends MainViewState{}
class LoadedCustomers extends MainViewState{}
class LoadingErrorCustomers extends MainViewState{
  String errorText;

  LoadingErrorCustomers(this.errorText);
}

class LoadedPricingGroups extends MainViewState{}
class LoadingErrorPricingGroups extends MainViewState{
  String errorText;

  LoadingErrorPricingGroups(this.errorText);
}

class LoadingCustomer extends MainViewState{}
class LoadedCustomer extends MainViewState{}
class LoadingErrorCustomer extends MainViewState{
  String errorText;

  LoadingErrorCustomer(this.errorText);
}

class LoadingPaymentMethods extends MainViewState{}
class LoadedPaymentMethods extends MainViewState{}
class LoadingPaymentMethodsError extends MainViewState{
  String errorText;

  LoadingPaymentMethodsError(this.errorText);
}

class CustomerAddedSucceed extends MainViewState{}
class CustomerAddError extends MainViewState{
  String errorText;

  CustomerAddError(this.errorText);
}

class CustomerUpdatedSucceed extends MainViewState{}
class CustomerUpdateError extends MainViewState{
  String errorText;

  CustomerUpdateError(this.errorText);
}

class CheckOutSucceed extends MainViewState{
  CheckOutResponse checkOutRes;

  CheckOutSucceed(this.checkOutRes);
}
class CheckOutError extends MainViewState{
  String errorText;

  CheckOutError(this.errorText);
}

class CloseRegisterSucceed extends MainViewState{}
class CloseRegisterError extends MainViewState{
  String errorText;

  CloseRegisterError(this.errorText);
}

class OpenCloseRegisterLoading extends MainViewState{}
class OpenCloseRegisterSucceed extends MainViewState{}
class OpenCloseRegisterError extends MainViewState{
  String errorText;

  OpenCloseRegisterError(this.errorText);
}

class LoadingCurrency extends MainViewState{}
class LoadedCurrency extends MainViewState{
  String currencyCode;

  LoadedCurrency(this.currencyCode);
}
class LoadingErrorCurrency extends MainViewState{
  String errorText;

  LoadingErrorCurrency(this.errorText);
}

class InsertPrintingSettings  extends MainViewState{}
class InsertErrorPrintingSettings extends MainViewState{
  String errorText;

  InsertErrorPrintingSettings(this.errorText);
}

class DeletePrintingSettings extends MainViewState{}
class DeleteErrorPrintingSettings  extends MainViewState{
  String errorText;

  DeleteErrorPrintingSettings(this.errorText);
}

class UpdatePrintingSettings extends MainViewState{}
class UpdateErrorPrintingSettings  extends MainViewState{
  String errorText;

  UpdateErrorPrintingSettings(this.errorText);
}

class LoadedPrintingSettings extends MainViewState{
  List<PrintSettingModel> printSettingResponse;

  LoadedPrintingSettings(this.printSettingResponse);
}
class LoadingErrorPrintingSettings extends MainViewState{
  String errorText;

  LoadingErrorPrintingSettings(this.errorText);
}

class LoadedByIdPrintingSettings extends MainViewState{
  PrintSettingModel printSettingResponse;

  LoadedByIdPrintingSettings(this.printSettingResponse);
}
class LoadingByIdErrorPrintingSettings extends MainViewState{
  String errorText;

  LoadingByIdErrorPrintingSettings(this.errorText);
}

class LoadedLocationSettings extends MainViewState{
  LocationSettingsResponse locationSettingResponse;

  LoadedLocationSettings(this.locationSettingResponse);
}
class LoadingErrorLocationSettings extends MainViewState{
  String errorText;

  LoadingErrorLocationSettings(this.errorText);
}

class LoadingAppearance extends MainViewState{}
class LoadedAppearance extends MainViewState{
  AppearanceResponse appearanceResponse;

  LoadedAppearance(this.appearanceResponse);
}
class LoadingErrorAppearance extends MainViewState{
  String errorText;

  LoadingErrorAppearance(this.errorText);
}

class LoadedRegisterData extends MainViewState{}
class LoadingErrorRegisterData extends MainViewState{
  String errorText;

  LoadingErrorRegisterData(this.errorText);
}

class LoadingTailoringTypes extends MainViewState{}
class LoadedTailoringTypes  extends MainViewState{}
class LoadingErrorTailoringTypes  extends MainViewState{
  String errorText;

  LoadingErrorTailoringTypes (this.errorText);
}

class MainNoInternetState extends MainViewState{}
