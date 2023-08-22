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
    final data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['location_id'] = locationId;
    data['short_code'] = shortCode;
    data['parent_id'] = parentId;
    data['created_by'] = createdBy;
    data['woocommerce_cat_id'] = woocommerceCatId;
    data['category_type'] = categoryType;
    data['description'] = description;
    data['slug'] = slug;
    data['tax_id'] = taxId;
    data['never_tax'] = neverTax;
    data['deleted_at'] = deletedAt;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['show_in_list'] = showInList;
    data['products_count'] = productsCount;
    data['selected'] = selected;
    data['products'] = products.map((e)=>e.toJson()).toList();
    return data;
  }
}