import 'package:poslix_app/pos/domain/response/checkout_data_model.dart';
import 'package:poslix_app/pos/domain/response/checkout_sales_data_model.dart';
import 'package:poslix_app/pos/domain/response/currency_model.dart';

class SalesPaymentResponse {
  SalesPaymentResponse({
    required this.subTotal,
    required this.payed,
    required this.due,
    required this.tax,
    required this.total,
    required this.currency,
    required this.data,
  });
  late final double subTotal;
  late final int payed;
  late final double due;
  late final int tax;
  late final double total;
  late final CurrencyResponse currency;
  late final List<CheckOutSalesDataResponse> data;

  SalesPaymentResponse.fromJson(Map<String, dynamic> json){
    subTotal = json['sub_total'];
    payed = json['payed'];
    due = json['due'];
    tax = json['tax'];
    total = json['total'];
    currency = CurrencyResponse.fromJson(json['currency']);
    data = List.from(json['data']).map((e)=>CheckOutSalesDataResponse.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['sub_total'] = subTotal;
    _data['payed'] = payed;
    _data['due'] = due;
    _data['tax'] = tax;
    _data['total'] = total;
    _data['currency'] = currency.toJson();
    _data['data'] = data.map((e)=>e.toJson()).toList();
    return _data;
  }
}