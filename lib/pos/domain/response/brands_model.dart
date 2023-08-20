import 'package:poslix_app/pos/domain/response/products_model.dart';

class BrandsResponse {
  BrandsResponse({
    required this.id,
    required this.locationId,
    required this.name,
    required this.description,
    required this.createdBy,
    // this.taxId,
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
  // int? taxId;
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
    // taxId = json['taxId'] ?? '';
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
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['location_id'] = locationId;
    _data['name'] = name;
    _data['description'] = description;
    _data['created_by'] = createdBy;
    // _data['tax_id'] = taxId;
    _data['never_tax'] = neverTax;
    _data['deleted_at'] = deletedAt;
    _data['created_at'] = createdAt;
    _data['updated_at'] = updatedAt;
    _data['use_for_repair'] = useForRepair;
    _data['products_count'] = productsCount;
    _data['selected'] = selected;
    _data['products'] = products.map((e)=>e.toJson()).toList();
    return _data;
  }
}