class OrderModel {
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
  int? orderId;
  double? orderDiscount;
  String? itemOption;
  String? itemOptionValue;
  int? productId;
  int? variationId;

  OrderModel({this.id,this.itemName,this.itemQuantity,this.itemAmount,this.customer,this.category,this.brand,this.date,this.orderId,this.itemPrice,this.orderDiscount,this.customerTel,this.itemOption,
    this.itemOptionValue,this.productId,this.variationId,});

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["id"] = id;
    data["itemName"] = itemName;
    data["itemQuantity"] = itemQuantity;
    data["itemAmount"] = itemAmount;
    data["customer"] = customer;
    data["customerTel"] = customerTel;
    data["category"] = category;
    data["brand"] = brand;
    data["date"] = date;
    data["orderId"] = orderId;
    data["itemPrice"] = itemPrice;
    data["orderDiscount"] = orderDiscount;
    data["itemOption"] = itemOption;
    data["itemOptionValue"] = itemOptionValue;
    data["productId"] = productId;
    data["variationId"] = variationId;
    return data;
  }

  OrderModel.fromMap(Map<String, dynamic> map) {
    id = map["id"];
    itemName = map["itemName"];
    itemQuantity = map["itemQuantity"];
    itemAmount = map["itemAmount"];
    customer = map["customer"];
    customerTel = map["customerTel"];
    category = map["category"];
    brand = map["brand"];
    date = map["date"];
    orderId = map["orderId"];
    itemPrice = map["itemPrice"];
    orderDiscount = map["orderDiscount"];
    itemOption = map["itemOption"];
    itemOptionValue = map["itemOptionValue"];
    productId = map["productId"];
    variationId = map["variationId"];
  }
}

List<OrderModel> listOfOrders = [];