import 'package:poslix_app/pos/domain/response/products_model.dart';

class CategoriesResponse {
  CategoriesResponse({
    required this.id,
    required this.name,
    required this.locationId,
    this.shortCode,
    required this.parentId,
    required this.createdBy,
    this.woocommerceCatId,
    this.categoryType,
    required this.description,
    this.slug,
    this.taxId,
    required this.neverTax,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
    required this.showInList,
    required this.productsCount,
    required this.products,
    required this.selected,
  });
  late final int id;
  late final String name;
  late final int locationId;
  String? shortCode;
  late final int parentId;
  late final int createdBy;
  int? woocommerceCatId;
  String? categoryType;
  late final String description;
  String? slug;
  int? taxId;
  late final int neverTax;
  String? deletedAt;
  String? createdAt;
  String? updatedAt;
  late final String showInList;
  late final int productsCount;
  bool? selected;
  late final List<ProductsResponse> products;

  CategoriesResponse.fromJson(Map<String, dynamic> json){
    id = json['id'];
    name = json['name'];
    locationId = json['location_id'] ?? '';
    shortCode = json['shortCode'] ?? '';
    parentId = json['parent_id'] ?? '';
    createdBy = json['created_by'] ?? '';
    woocommerceCatId = json['woocommerceCatId'] ?? 0;
    categoryType = json['categoryType'] ?? '';
    description = json['description'] ?? '';
    slug = json['slug'] ?? '';
    taxId = json['taxId'] ?? 0;
    neverTax = json['never_tax'] ?? '';
    deletedAt = json['deletedAt'] ?? '';
    createdAt = json['createdAt'] ?? '';
    updatedAt = json['updatedAt'] ?? '';
    showInList = json['show_in_list'] ?? '';
    productsCount = json['products_count'] ?? '';
    selected = json['selected'];
    products = List.from(json['products']).map((e)=>ProductsResponse.fromJson(e)).toList();

  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['name'] = name;
    _data['location_id'] = locationId;
    _data['short_code'] = shortCode;
    _data['parent_id'] = parentId;
    _data['created_by'] = createdBy;
    _data['woocommerce_cat_id'] = woocommerceCatId;
    _data['category_type'] = categoryType;
    _data['description'] = description;
    _data['slug'] = slug;
    _data['tax_id'] = taxId;
    _data['never_tax'] = neverTax;
    _data['deleted_at'] = deletedAt;
    _data['created_at'] = createdAt;
    _data['updated_at'] = updatedAt;
    _data['show_in_list'] = showInList;
    _data['products_count'] = productsCount;
    _data['selected'] = selected;
    _data['products'] = products.map((e)=>e.toJson()).toList();
    return _data;
  }
}