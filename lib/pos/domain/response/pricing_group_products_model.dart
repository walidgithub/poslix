import 'package:poslix_app/pos/domain/response/pricing_group_variants_model.dart';

class PricingGroupProductsResponse {
  PricingGroupProductsResponse({
    required this.id,
    required this.name,
    required this.price,
    required this.variants,
    required this.oldPrice,
  });
  late final int id;
  late final String name;
  late final int? price;
  late final List<PricingGroupVariantsResponse> variants;
  late final int oldPrice;

  PricingGroupProductsResponse.fromJson(Map<String, dynamic> json){
    id = json['id'];
    name = json['name'];
    price = (json['price'] as num).toInt();
    variants = List.from(json['variants']).map((e)=>PricingGroupVariantsResponse.fromJson(e)).toList();
    oldPrice = json['old_price'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['name'] = name;
    _data['price'] = price;
    _data['variants'] = variants.map((e)=>e.toJson()).toList();
    _data['old_price'] = oldPrice;
    return _data;
  }
}