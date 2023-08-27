class HoldOrderItemsModel {
  int? id;
  int? holdOrderId;
  String? itemName;
  int? itemQuantity;
  String? itemPrice;
  String? itemAmount;
  String? customer;
  String? customerTel;
  String? category;
  String? brand;
  String? date;
  String? holdText;
  String? discount;
  String? itemOption;
  int? productId;
  int? variationId;
  String? productType;

  HoldOrderItemsModel({this.id,this.holdOrderId,this.itemName,this.itemQuantity,this.itemAmount,this.customer,this.customerTel,this.category,this.brand,this.date,this.itemPrice,this.holdText,this.discount,this.itemOption,this.productId,this.variationId,this.productType});

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["id"] = id;
    data["holdOrderId"] = holdOrderId;
    data["itemName"] = itemName;
    data["itemQuantity"] = itemQuantity;
    data["itemAmount"] = itemAmount;
    data["customer"] = customer;
    data["customerTel"] = customerTel;
    data["category"] = category;
    data["brand"] = brand;
    data["date"] = date;
    data["itemPrice"] = itemPrice;
    data["holdText"] = holdText;
    data["discount"] = discount;
    data["itemOption"] = itemOption;
    data["productId"] = productId;
    data["variationId"] = variationId;
    data["productType"] = productType;
    return data;
  }

  HoldOrderItemsModel.fromMap(Map<String, dynamic> map) {
    id = map["id"];
    holdOrderId = map["holdOrderId"];
    itemName = map["itemName"];
    itemQuantity = map["itemQuantity"];
    itemAmount = map["itemAmount"];
    customer = map["customer"];
    customerTel = map["customerTel"];
    category = map["category"];
    brand = map["brand"];
    date = map["date"];
    itemPrice = map["itemPrice"];
    holdText = map["holdText"];
    discount = map["discount"];
    itemOption = map["itemOption"];
    productId = map["productId"];
    variationId = map["variationId"];
    productType = map["productType"];
  }
}

// List<HoldOrderItemsModel> listOfHoldOrderItems = [];