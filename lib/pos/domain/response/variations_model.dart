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
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['location_id'] = locationId;
    _data['parent_id'] = parentId;
    _data['name'] = name;
    _data['name2'] = name2;
    _data['sku'] = sku;
    _data['cost'] = cost;
    _data['price'] = price;
    _data['sell_over_stock'] = sellOverStock;
    _data['is_selling_multi_price'] = isSellingMultiPrice;
    _data['is_service'] = isService;
    _data['is_active'] = isActive;
    _data['created_by'] = createdBy;
    _data['created_at'] = createdAt;
    _data['stock'] = stock;
    _data['stocks'] = stocks.map((e)=>e.toJson()).toList();
    return _data;
  }
}