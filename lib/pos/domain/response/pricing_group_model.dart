import 'package:poslix_app/pos/domain/response/pricing_group_customers_model.dart';
import 'package:poslix_app/pos/domain/response/pricing_group_products_model.dart';

class PricingGroupResponse {
  PricingGroupResponse({
    required this.id,
    required this.name,
    required this.businessId,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    required this.locationId,
    required this.products,
    required this.customers,
  });
  late final int id;
  late final String name;
  late final int businessId;
  late final int isActive;
  late final String createdAt;
  late final String updatedAt;
  late final int locationId;
  late final List<PricingGroupProductsResponse> products;
  late final List<PricingGroupCustomersResponse> customers;

  PricingGroupResponse.fromJson(Map<String, dynamic> json){
    id = json['id'];
    name = json['name'];
    businessId = json['business_id'];
    isActive = json['is_active'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    locationId = json['location_id'];
    products = List.from(json['products']).map((e)=>PricingGroupProductsResponse.fromJson(e)).toList();
    customers = List.from(json['customers']).map((e)=>PricingGroupCustomersResponse.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['name'] = name;
    _data['business_id'] = businessId;
    _data['is_active'] = isActive;
    _data['created_at'] = createdAt;
    _data['updated_at'] = updatedAt;
    _data['location_id'] = locationId;
    _data['products'] = products.map((e)=>e.toJson()).toList();
    _data['customers'] = customers.map((e)=>e.toJson()).toList();
    return _data;
  }
}