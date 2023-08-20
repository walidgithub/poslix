
class StocksResponse {
  StocksResponse({
    required this.id,
    required this.transactionId,
    required this.transactionLinesId,
    required this.productId,
    required this.variationId,
    required this.qtyReceived,
    required this.qtySold,
    required this.soldAt,
    required this.createdBy,
    required this.createdAt,
    this.updatedAt,
  });
  late final int id;
  late final int transactionId;
  late final int transactionLinesId;
  late final int productId;
  late final int variationId;
  late final String qtyReceived;
  late final String qtySold;
  late final String soldAt;
  late final int createdBy;
  late final String createdAt;
  String? updatedAt;

  StocksResponse.fromJson(Map<String, dynamic> json){
    id = json['id'];
    transactionId = json['transaction_id'] ?? 0;
    transactionLinesId = json['transaction_lines_id'] ?? 0;
    productId = json['product_id'] ?? 0;
    variationId = json['variation_id'] ?? 0;
    qtyReceived = json['qty_received'] ?? '';
    qtySold = json['qty_sold'] ?? '';
    soldAt = json['sold_at'] ?? '';
    createdBy = json['created_by'] ?? 0;
    createdAt = json['created_at'] ?? '';
    updatedAt = json['updatedAt'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['transaction_id'] = transactionId;
    _data['transaction_lines_id'] = transactionLinesId;
    _data['product_id'] = productId;
    _data['variation_id'] = variationId;
    _data['qty_received'] = qtyReceived;
    _data['qty_sold'] = qtySold;
    _data['sold_at'] = soldAt;
    _data['created_by'] = createdBy;
    _data['created_at'] = createdAt;
    _data['updated_at'] = updatedAt;
    return _data;
  }
}