class TmpOrderModel {
  int? id;
  String? itemName;
  int? itemQuantity;
  String? itemPrice;
  String? itemAmount;
  String? customer;
  String? customerTel;
  String? category;
  String? brand;
  String? date;
  double? orderDiscount;
  String? itemOption;
  int? productId;
  int? variationId;
  String? productType;
  int? pricingGroupId;

  TmpOrderModel({this.id,this.itemName,this.itemQuantity,this.itemAmount,this.customer,this.category,this.brand,this.date,this.itemPrice,this.orderDiscount,this.customerTel,this.itemOption,this.productId,this.variationId,this.productType,this.pricingGroupId});

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["id"] = id;
    data["itemName"] = itemName;
    data["itemQuantity"] = itemQuantity;
    data["itemAmount"] = itemAmount;
    data["customer"] = customer;
    data["category"] = category;
    data["brand"] = brand;
    data["date"] = date;
    data["itemPrice"] = itemPrice;
    data["orderDiscount"] = orderDiscount;
    data["customerTel"] = customerTel;
    data["itemOption"] = itemOption;
    data["productId"] = productId;
    data["variationId"] = variationId;
    data["productType"] = productType;
    data["pricingGroupId"] = pricingGroupId ?? 0;
    return data;
  }

  TmpOrderModel.fromMap(Map<String, dynamic> map) {
    id = map["id"];
    itemName = map["itemName"];
    itemQuantity = map["itemQuantity"];
    itemAmount = map["itemAmount"];
    customer = map["customer"];
    category = map["category"];
    brand = map["brand"];
    date = map["date"];
    itemPrice = map["itemPrice"];
    orderDiscount = map["orderDiscount"];
    customerTel = map["customerTel"];
    itemOption = map["itemOption"];
    productId = map["productId"];
    variationId = map["variationId"];
    productType = map["productType"];
    pricingGroupId = map["pricingGroupId"] ?? 0;
  }
}

List<TmpOrderModel> listOfTmpOrder = [];