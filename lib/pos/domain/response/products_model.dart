import 'package:poslix_app/pos/domain/response/pivot_model.dart';
import 'package:poslix_app/pos/domain/response/stocks_model.dart';
import 'package:poslix_app/pos/domain/response/variations_model.dart';

class ProductsResponse {
  ProductsResponse({
    required this.id,
    required this.name,
    this.businessId,
    required this.locationId,
    required this.type,
    required this.isTailoring,
    required this.isService,
    required this.isFabric,
    required this.subproductname,
    required this.unitId,
    required this.brandId,
    required this.categoryId,
    this.subCategoryId,
    this.tax,
    required this.neverTax,
    required this.alertQuantity,
    required this.sku,
    required this.barcodeType,
    required this.image,
    this.productDescription,
    required this.createdBy,
    required this.isDisabled,
    required this.sellPrice,
    required this.costPrice,
    required this.sellOverStock,
    required this.qtyOverSold,
    this.createdAt,
    this.updatedAt,
    required this.isSellingMultiPrice,
    required this.isFifo,
    required this.variations,
    required this.packages,
    required this.stock,
    // required this.pivot,
    required this.stocks,
  });
  late final int id;
  late final String name;
  int? businessId;
  late final int locationId;
  late final String type;
  late final int isTailoring;
  late final int isService;
  late final int isFabric;
  late final String subproductname;
  late final int unitId;
  late final int brandId;
  late final int categoryId;
  int? subCategoryId;
  double? tax;
  late final int neverTax;
  late final String alertQuantity;
  late final String sku;
  late final String barcodeType;
  late final String image;
  String? productDescription;
  late final int createdBy;
  late final int isDisabled;
  late final String sellPrice;
  late final String costPrice;
  late final String sellOverStock;
  late final String qtyOverSold;
  String? createdAt;
  String? updatedAt;
  late final int isSellingMultiPrice;
  late final int isFifo;
  late final List<VariationsResponse> variations;
  late final List<dynamic> packages;
  late final int stock;
  // late final PivotResponse pivot;
  late final List<StocksResponse> stocks;

  ProductsResponse.fromJson(Map<String, dynamic> json){
    id = json['id'];
    name = json['name'] ?? '';
    businessId = json['businessId'] ?? 0;
    locationId = json['location_id'] ?? '';
    type = json['type'] ?? '';
    isTailoring = json['is_tailoring'] ?? 0;
    isService = json['is_service'] ?? 0;
    isFabric = json['is_fabric'] ?? 0;
    subproductname = json['subproductname'] ?? '';
    unitId = json['unit_id'] ?? 0;
    brandId = json['brand_id'] ?? 0;
    categoryId = json['category_id'] ?? 0;
    subCategoryId = json['subCategoryId'] ?? 0;
    tax = json['tax'] ?? 0.0;
    neverTax = json['never_tax'] ?? 0;
    alertQuantity = json['alert_quantity'] ?? '';
    sku = json['sku'] ?? '';
    barcodeType = json['barcode_type'] ?? '';
    image = json['image'] ?? '';
    productDescription = json['productDescription'] ?? '';
    createdBy = json['created_by'] ?? 0;
    isDisabled = json['is_disabled'] ?? 0;
    sellPrice = json['sell_price'] ?? '';
    costPrice = json['cost_price'] ?? '';
    sellOverStock = json['sell_over_stock'] ?? '';
    qtyOverSold = json['qty_over_sold'] ?? '';
    createdAt = json['createdAt'] ?? '';
    updatedAt = json['updatedAt'] ?? '';
    isSellingMultiPrice = json['is_selling_multi_price'] ?? 0;
    isFifo = json['is_fifo'] ?? 0;
    variations = List.from(json['variations']).map((e)=>VariationsResponse.fromJson(e)).toList();
    packages = List.castFrom<dynamic, dynamic>(json['packages']);
    stock = json['stock'] ?? 0;
    // pivot = PivotResponse.fromJson(json['pivot']);
    stocks = List.from(json['stocks']).map((e)=>StocksResponse.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['name'] = name;
    _data['business_id'] = businessId;
    _data['location_id'] = locationId;
    _data['type'] = type;
    _data['is_tailoring'] = isTailoring;
    _data['is_service'] = isService;
    _data['is_fabric'] = isFabric;
    _data['subproductname'] = subproductname;
    _data['unit_id'] = unitId;
    _data['brand_id'] = brandId;
    _data['category_id'] = categoryId;
    _data['sub_category_id'] = subCategoryId;
    _data['tax'] = tax;
    _data['never_tax'] = neverTax;
    _data['alert_quantity'] = alertQuantity;
    _data['sku'] = sku;
    _data['barcode_type'] = barcodeType;
    _data['image'] = image;
    _data['product_description'] = productDescription;
    _data['created_by'] = createdBy;
    _data['is_disabled'] = isDisabled;
    _data['sell_price'] = sellPrice;
    _data['cost_price'] = costPrice;
    _data['sell_over_stock'] = sellOverStock;
    _data['qty_over_sold'] = qtyOverSold;
    _data['created_at'] = createdAt;
    _data['updated_at'] = updatedAt;
    _data['is_selling_multi_price'] = isSellingMultiPrice;
    _data['is_fifo'] = isFifo;
    _data['variations'] = variations.map((e)=>e.toJson()).toList();
    _data['packages'] = packages;
    _data['stock'] = stock;
    // _data['pivot'] = pivot.toJson();
    _data['stocks'] = stocks.map((e)=>e.toJson()).toList();
    return _data;
  }
}