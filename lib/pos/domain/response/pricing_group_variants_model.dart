class PricingGroupVariantsResponse {
  PricingGroupVariantsResponse({
    required this.id,
    required this.name,
    required this.price,
    required this.oldPrice,
  });
  late final int id;
  late final String name;
  late final int? price;
  late final int oldPrice;

  PricingGroupVariantsResponse.fromJson(Map<String, dynamic> json){
    id = json['id'];
    name = json['name'];
    price = (json['price'] as num).toInt();
    oldPrice = json['old_price'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['name'] = name;
    _data['price'] = price;
    _data['old_price'] = oldPrice;
    return _data;
  }
}