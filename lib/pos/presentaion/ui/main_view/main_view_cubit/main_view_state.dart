import '../../../../domain/response/appearance_model.dart';
import '../../../../domain/response/check_out_model.dart';

abstract class MainViewState{}

class MainViewInitial extends MainViewState{}

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

class LoadingCustomer extends MainViewState{}
class LoadedCustomer extends MainViewState{}
class LoadingErrorCustomer extends MainViewState{
  String errorText;

  LoadingErrorCustomer(this.errorText);
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

class OpenCloseRegisterSucceed extends MainViewState{}
class OpenCloseRegisterError extends MainViewState{
  String errorText;

  OpenCloseRegisterError(this.errorText);
}

class LoadedCurrency extends MainViewState{
  String currencyCode;

  LoadedCurrency(this.currencyCode);
}
class LoadingErrorCurrency extends MainViewState{
  String errorText;

  LoadingErrorCurrency(this.errorText);
}

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

class MainNoInternetState extends MainViewState{}