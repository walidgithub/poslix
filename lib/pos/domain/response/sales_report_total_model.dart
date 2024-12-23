import 'package:poslix_app/pos/domain/response/sales_report_data_model.dart';

import 'currency_model.dart';

class SalesReportModel {
  SalesReportModel({
    required this.subTotal,
    required this.tax,
    required this.total,
    required this.currency,
    required this.data,
  });
  late final double subTotal;
  late final int tax;
  late final double total;
  late final CurrencyResponse currency;
  late final List<SalesReportDataModel> data;

  SalesReportModel.fromJson(Map<String, dynamic> json){
    subTotal = json['sub_total'];
    tax = json['tax'];
    total = json['total'];
    currency = CurrencyResponse.fromJson(json['currency']);
    data = List.from(json['data']).map((e)=>SalesReportDataModel.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['sub_total'] = subTotal;
    _data['tax'] = tax;
    _data['total'] = total;
    _data['currency'] = currency.toJson();
    _data['data'] = data.map((e)=>e.toJson()).toList();
    return _data;
  }
}