import 'package:poslix_app/pos/domain/response/packages_model.dart';
import 'package:poslix_app/pos/domain/response/stocks_model.dart';
import 'package:poslix_app/pos/domain/response/variations_model.dart';

class ProductsInOrdersResponse {
  ProductsInOrdersResponse({
    required this.productId,
    required this.productName,
    required this.productSku,
    required this.productPrice,
    required this.productQty,
    required this.variantId,
    required this.categoryId,
    required this.categoryName,
    required this.brandId,
    required this.brandName,
  });
  late final int productId;
  late final String productName;
  late final String productSku;
  late final String productPrice;
  late final String productQty;
  late final int variantId;
  late final String categoryId;
  late final String categoryName;
  late final String brandId;
  late final String brandName;

  ProductsInOrdersResponse.fromJson(Map<String, dynamic> json){
    productId = json['product_id'];
    productName = json['product_name'];
    productSku = json['product_sku'];
    productPrice = json['product_price'];
    productQty = json['product_qty'];
    variantId = json['variant_id'];
    categoryId = json['category_id'];
    categoryName = json['category_name'];
    brandId = json['brand_id'];
    brandName = json['brand_name'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['product_id'] = productId;
    _data['product_name'] = productName;
    _data['product_sku'] = productSku;
    _data['product_price'] = productPrice;
    _data['product_qty'] = productQty;
    _data['variant_id'] = variantId;
    _data['category_id'] = categoryId;
    _data['category_name'] = categoryName;
    _data['brand_id'] = brandId;
    _data['brand_name'] = brandName;
    return _data;
  }
}