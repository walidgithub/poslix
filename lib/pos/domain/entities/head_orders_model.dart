class HeadOrderModel {
  int? id;
  int? orderId;
  double? orderTotal;
  String? customer;
  String? date;
  double? orderDiscount;
  String? category;
  String? brand;
  String? customerTel;

  HeadOrderModel({this.id,this.orderId,this.orderTotal,this.category,this.brand,this.customerTel,this.date,this.orderDiscount,this.customer});

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["id"] = id;
    data["orderId"] = orderId;
    data["orderTotal"] = orderTotal;
    data["category"] = category;
    data["brand"] = brand;
    data["customerTel"] = customerTel;
    data["date"] = date;
    data["customer"] = customer;
    data["orderDiscount"] = orderDiscount;
    return data;
  }

  HeadOrderModel.fromMap(Map<String, dynamic> map) {
    id = map["id"];
    orderId = map["orderId"];
    orderTotal = map["orderTotal"];
    category = map["category"];
    brand = map["brand"];
    customerTel = map["customerTel"];
    date = map["date"];
    customer = map["customer"];
    orderDiscount = map["orderDiscount"];
  }
}


