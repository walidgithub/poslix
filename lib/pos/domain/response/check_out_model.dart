import 'package:poslix_app/pos/domain/response/checkout_data_model.dart';
import 'package:poslix_app/pos/domain/response/sales_payment_model.dart';

class CheckOutResponse {
  CheckOutResponse({
    required this.data,
    required this.sales,
  });
  late final CheckOutDataResponse data;
  late final SalesPaymentResponse sales;

  CheckOutResponse.fromJson(Map<String, dynamic> json){
    data = CheckOutDataResponse.fromJson(json['data']);
    sales = SalesPaymentResponse.fromJson(json['sales']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['data'] = data.toJson();
    _data['sales'] = sales.toJson();
    return _data;
  }
}