import 'hold_order_items_model.dart';

class HoldOrderNamesModel {
  int? id;
  String? holdText;
  String? customerTel;
  String? customer;
  String? discount;
  String? date;

  HoldOrderNamesModel({this.id,this.holdText,this.customerTel,this.customer,this.date,this.discount});

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["id"] = id;
    data["holdText"] = holdText;
    data["customerTel"] = customerTel;
    data["customer"] = customer;
    data["date"] = date;
    data["discount"] = discount;
    return data;
  }

  HoldOrderNamesModel.fromMap(Map<String, dynamic> map) {
    id = map["id"];
    holdText = map["holdText"];
    customerTel = map["customerTel"];
    customer = map["customer"];
    date = map["date"];
    discount = map["discount"];
  }
}