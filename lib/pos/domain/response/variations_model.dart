import 'package:poslix_app/pos/domain/response/stocks_model.dart';

class VariationsResponse {
  VariationsResponse({
    required this.id,
    required this.locationId,
    required this.parentId,
    required this.name,
    required this.name2,
    required this.sku,
    required this.cost,
    required this.price,
    required this.sellOverStock,
    required this.isSellingMultiPrice,
    required this.isService,
    required this.isActive,
    required this.createdBy,
    required this.stock,
    required this.stocks,
    this.createdAt,
  });
  late final int id;
  late final int locationId;
  late final int parentId;
  late final String name;
  late final String name2;
  late final String sku;
  late final String cost;
  late final String price;
  late final int sellOverStock;
  late final int isSellingMultiPrice;
  late final int isService;
  late final int isActive;
  late final int createdBy;
  late final int stock;
  late final List<StocksResponse> stocks;
  String? createdAt;

  VariationsResponse.fromJson(Map<String, dynamic> json){
    id = json['id'];
    locationId = json['location_id'] ?? 0;
    parentId = json['parent_id'] ?? 0;
    name = json['name'] ?? '';
    name2 = json['name2'] ?? '';
    sku = json['sku'] ?? '';
    cost = json['cost'] ?? '';
    price = json['price'] ?? '';
    sellOverStock = json['sell_over_stock'] ?? 0;
    isSellingMultiPrice = json['is_selling_multi_price'] ?? 0;
    isService = json['is_service'] ?? 0;
    isActive = json['is_active'] ?? 0;
    createdBy = json['created_by'] ?? 0;
    createdAt = json['createdAt'] ?? '';
    stock = json['stock'] ?? 0;
    stocks = List.from(json['stocks']).map((e)=>StocksResponse.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['location_id'] = locationId;
    data['parent_id'] = parentId;
    data['name'] = name;
    data['name2'] = name2;
    data['sku'] = sku;
    data['cost'] = cost;
    data['price'] = price;
    data['sell_over_stock'] = sellOverStock;
    data['is_selling_multi_price'] = isSellingMultiPrice;
    data['is_service'] = isService;
    data['is_active'] = isActive;
    data['created_by'] = createdBy;
    data['created_at'] = createdAt;
    data['stock'] = stock;
    data['stocks'] = stocks.map((e)=>e.toJson()).toList();
    return data;
  }
}