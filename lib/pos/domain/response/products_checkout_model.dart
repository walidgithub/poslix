import 'package:poslix_app/pos/domain/response/pivot_model.dart';
import 'package:poslix_app/pos/domain/response/stocks_model.dart';
import 'package:poslix_app/pos/domain/response/variations_model.dart';

class ProductsCheckOutResponse {
  ProductsCheckOutResponse({
    required this.productId,
    required this.productName,
    required this.productSku,
    required this.productPrice,
    required this.productQty,
    required this.variantId,
  });
  late final int productId;
  late final String productName;
  String? productSku;
  late final String productPrice;
  late final String productQty;
  late final int variantId;


  ProductsCheckOutResponse.fromJson(Map<String, dynamic> json){
    productId = json['product_id'];
    productName = json['product_name'];
    productSku = json['product_sku'] ?? '';
    productPrice = json['product_price'];
    productQty = json['product_qty'];
    variantId = json['variant_id'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['product_id'] = productId;
    data['product_name'] = productName;
    data['product_sku'] = productSku;
    data['product_price'] = productPrice;
    data['product_qty'] = productQty;
    data['variant_id'] = variantId;
    return data;
  }
}