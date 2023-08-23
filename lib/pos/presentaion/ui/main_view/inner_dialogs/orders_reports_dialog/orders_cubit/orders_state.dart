abstract class OrdersState{}

class OrdersInitial extends OrdersState{}

class LoadingAllOrderReport extends OrdersState{}
class AllOrderReportSucceed extends OrdersState{}
class AllOrderReportError extends OrdersState{
  String errorText;

  AllOrderReportError(this.errorText);
}

class LoadingOrderReport extends OrdersState{}
class OrderReportSucceed extends OrdersState{}
class OrderReportError extends OrdersState{
  String errorText;

  OrderReportError(this.errorText);
}

class LoadingOrderReportItems extends OrdersState{}
class OrderReportItemsSucceed extends OrdersState{}
class OrderReportItemsError extends OrdersState{
  String errorText;

  OrderReportItemsError(this.errorText);
}

class OrdersNoInternetState extends OrdersState{}
