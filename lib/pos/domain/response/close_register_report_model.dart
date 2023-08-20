import 'close_register_report_data_model.dart';

class CloseRegisterReportResponse {
  CloseRegisterReportResponse({
    required this.totalHandCash,
    required this.totalCash,
    required this.totalCheque,
    required this.totalBank,
    required this.totalCart,
    required this.total,
    required this.data,
  });
  late final int totalHandCash;
  late final int totalCash;
  late final int totalCheque;
  late final int totalBank;
  late final int totalCart;
  late final int total;
  late final List<CloseRegisterReportDataResponse> data;

  CloseRegisterReportResponse.fromJson(Map<String, dynamic> json){
    totalHandCash = json['total_hand_cash'];
    totalCash = json['total_cash'];
    totalCheque = json['total_cheque'];
    totalBank = json['total_bank'];
    totalCart = json['total_cart'];
    total = json['total'];
    data = List.from(json['data']).map((e)=>CloseRegisterReportDataResponse.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['total_hand_cash'] = totalHandCash;
    _data['total_cash'] = totalCash;
    _data['total_cheque'] = totalCheque;
    _data['total_bank'] = totalBank;
    _data['total_cart'] = totalCart;
    _data['total'] = total;
    _data['data'] = data.map((e)=>e.toJson()).toList();
    return _data;
  }
}