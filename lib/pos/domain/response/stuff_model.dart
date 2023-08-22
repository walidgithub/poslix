class StuffResponse {
  StuffResponse({
    required this.sales,
    required this.quotations,
    required this.products,
    required this.pos,
  });
  late final List<String> sales;
  late final List<String> quotations;
  late final List<String> products;
  late final List<String> pos;

  StuffResponse.fromJson(Map<String, dynamic> json){
    sales = List.castFrom<dynamic, String>(json['sales']);
    quotations = List.castFrom<dynamic, String>(json['quotations']);
    products = List.castFrom<dynamic, String>(json['products']);
    pos = List.castFrom<dynamic, String>(json['pos']);
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['sales'] = sales;
    data['quotations'] = quotations;
    data['products'] = products;
    data['pos'] = pos;
    return data;
  }
}