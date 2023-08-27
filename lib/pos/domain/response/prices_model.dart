class PricesResponse {
  String? name;
  String? from;
  String? to;
  String? price;

  PricesResponse({this.name, this.from, this.to, this.price});

  PricesResponse.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    from = json['from'];
    to = json['to'];
    price = json['price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['from'] = from;
    data['to'] = to;
    data['price'] = price;
    return data;
  }
}