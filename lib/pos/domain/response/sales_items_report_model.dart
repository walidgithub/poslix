import 'package:poslix_app/pos/domain/response/sales_report_items_model.dart';

import 'currency_model.dart';

class SalesItemsReportResponse {
  SalesItemsReportResponse({
    required this.cost,
    required this.subTotal,
    required this.tax,
    required this.total,
    required this.currency,
    required this.data,
  });
  late final int cost;
  late final int subTotal;
  late final double tax;
  late final double total;
  late final CurrencyResponse currency;
  late final List<SalesReportItemsResponse> data;

  SalesItemsReportResponse.fromJson(Map<String, dynamic> json){
    cost = json['cost'];
    subTotal = json['sub_total'];
    tax = (json['tax'] as num).toDouble();
    total = (json['total'] as num).toDouble();
    currency = CurrencyResponse.fromJson(json['currency']);
    data = List.from(json['data']).map((e)=>SalesReportItemsResponse.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['cost'] = cost;
    _data['sub_total'] = subTotal;
    _data['tax'] = tax;
    _data['total'] = total;
    _data['currency'] = currency.toJson();
    _data['data'] = data.map((e)=>e.toJson()).toList();
    return _data;
  }
}