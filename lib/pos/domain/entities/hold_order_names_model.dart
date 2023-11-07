import 'hold_order_items_model.dart';

class HoldOrderNamesModel {
  int? id;
  String? holdText;
  String? customerTel;
  String? customer;
  String? discount;
  String? date;
  int? pricingGroupId;

  HoldOrderNamesModel({this.id,this.holdText,this.customerTel,this.customer,this.date,this.discount,this.pricingGroupId});

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["id"] = id;
    data["holdText"] = holdText;
    data["customerTel"] = customerTel;
    data["customer"] = customer;
    data["date"] = date;
    data["discount"] = discount;
    data["pricingGroupId"] = pricingGroupId ?? 0;
    return data;
  }

  HoldOrderNamesModel.fromMap(Map<String, dynamic> map) {
    id = map["id"];
    holdText = map["holdText"];
    customerTel = map["customerTel"];
    customer = map["customer"];
    date = map["date"];
    discount = map["discount"];
    pricingGroupId = map["pricingGroupId"] ?? 0;
  }
}