import 'package:poslix_app/pos/domain/response/stocks_model.dart';
import 'package:poslix_app/pos/domain/response/variations_model.dart';

class ProductsInOrdersResponse {
  ProductsInOrdersResponse({
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
    required this.status,
    required this.productQty,
    required this.stock,
    required this.packages,
    required this.variations,
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
  late final String status;
  late final String productQty;
  late final int stock;
  late final List<dynamic> packages;
  late final List<VariationsResponse> variations;
  late final List<StocksResponse> stocks;

  ProductsInOrdersResponse.fromJson(Map<String, dynamic> json){
    id = json['id'];
    name = json['name'];
    businessId = json['businessId'] ?? 0;
    locationId = json['location_id'];
    type = json['type'];
    isTailoring = json['is_tailoring'];
    isService = json['is_service'];
    isFabric = json['is_fabric'];
    subproductname = json['subproductname'];
    unitId = json['unit_id'];
    brandId = json['brand_id'];
    categoryId = json['category_id'];
    subCategoryId = json['subCategoryId'] ?? 0;
    tax = json['tax'] ?? 0.0;
    neverTax = json['never_tax'];
    alertQuantity = json['alert_quantity'];
    sku = json['sku'];
    barcodeType = json['barcode_type'];
    image = json['image'];
    productDescription = json['productDescription'] ?? '';
    createdBy = json['created_by'];
    isDisabled = json['is_disabled'];
    sellPrice = json['sell_price'];
    costPrice = json['cost_price'];
    sellOverStock = json['sell_over_stock'];
    qtyOverSold = json['qty_over_sold'];
    createdAt = json['createdAt'] ?? '';
    updatedAt = json['updatedAt'] ?? '';
    isSellingMultiPrice = json['is_selling_multi_price'];
    isFifo = json['is_fifo'];
    status = json['status'];
    productQty = json['product_qty'];
    stock = json['stock'];
    packages = List.castFrom<dynamic, dynamic>(json['packages']);
    variations = List.from(json['variations']).map((e)=>VariationsResponse.fromJson(e)).toList();
    stocks = List.from(json['stocks']).map((e)=>StocksResponse.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['business_id'] = businessId;
    data['location_id'] = locationId;
    data['type'] = type;
    data['is_tailoring'] = isTailoring;
    data['is_service'] = isService;
    data['is_fabric'] = isFabric;
    data['subproductname'] = subproductname;
    data['unit_id'] = unitId;
    data['brand_id'] = brandId;
    data['category_id'] = categoryId;
    data['sub_category_id'] = subCategoryId;
    data['tax'] = tax;
    data['never_tax'] = neverTax;
    data['alert_quantity'] = alertQuantity;
    data['sku'] = sku;
    data['barcode_type'] = barcodeType;
    data['image'] = image;
    data['product_description'] = productDescription;
    data['created_by'] = createdBy;
    data['is_disabled'] = isDisabled;
    data['sell_price'] = sellPrice;
    data['cost_price'] = costPrice;
    data['sell_over_stock'] = sellOverStock;
    data['qty_over_sold'] = qtyOverSold;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['is_selling_multi_price'] = isSellingMultiPrice;
    data['is_fifo'] = isFifo;
    data['status'] = status;
    data['product_qty'] = productQty;
    data['stock'] = stock;
    data['packages'] = packages;
    data['variations'] = variations.map((e)=>e.toJson()).toList();
    data['stocks'] = stocks.map((e)=>e.toJson()).toList();
    return data;
  }
}