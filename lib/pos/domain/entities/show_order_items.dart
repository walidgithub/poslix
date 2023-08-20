class OrderItemsModel {
  int? id;
  String? itemName;
  int? itemQuantity;
  String? itemPrice;
  int? orderId;
  double? orderDiscount;

  OrderItemsModel(
      {this.id,
        this.itemName,
        this.itemQuantity,
        this.itemPrice,this.orderId,this.orderDiscount});

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["id"] = id;
    data["itemName"] = itemName;
    data["itemQuantity"] = itemQuantity;
    data["itemPrice"] = itemPrice;
    data["orderId"] = orderId;
    data["orderDiscount"] = orderDiscount;
    return data;
  }

  OrderItemsModel.fromMap(Map<String, dynamic> map) {
    id = map["id"];
    itemName = map["itemName"];
    itemQuantity = map["itemQuantity"];
    itemPrice = map["itemPrice"];
    orderId = map["orderId"];
    orderDiscount = map["orderDiscount"];
  }
}