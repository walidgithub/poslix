import 'package:poslix_app/pos/domain/response/products_model.dart';

class BrandsResponse {
  BrandsResponse({
    required this.id,
    required this.locationId,
    required this.name,
    required this.description,
    required this.createdBy,
    required this.neverTax,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
    this.useForRepair,
    required this.productsCount,
    required this.products,
    required this.selected,
  });
  late final int id;
  late final int locationId;
  late final String name;
  late final String description;
  late final int createdBy;
  late final int neverTax;
  String? deletedAt;
  String? createdAt;
  String? updatedAt;
  String? useForRepair;
  late final int productsCount;
  bool? selected;
  late final List<ProductsResponse> products;

  BrandsResponse.fromJson(Map<String, dynamic> json){
    id = json['id'];
    locationId = json['location_id'];
    name = json['name'];
    description = json['description'];
    createdBy = json['created_by'];
    neverTax = json['never_tax'];
    deletedAt = json['deletedAt'] ?? '';
    createdAt = json['createdAt'] ?? '';
    updatedAt = json['updatedAt'] ?? '';
    useForRepair = json['useForRepair'] ?? '';
    productsCount = json['products_count'];
    selected = json['selected'];
    products = List.from(json['products']).map((e)=>ProductsResponse.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['location_id'] = locationId;
    data['name'] = name;
    data['description'] = description;
    data['created_by'] = createdBy;
    data['never_tax'] = neverTax;
    data['deleted_at'] = deletedAt;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['use_for_repair'] = useForRepair;
    data['products_count'] = productsCount;
    data['selected'] = selected;
    data['products'] = products.map((e)=>e.toJson()).toList();
    return data;
  }
}