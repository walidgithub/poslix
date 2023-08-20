class CartRequest {
  CartRequest({
    required this.productId,
    required this.variationId,
    required this.qty,
    required this.note,
  });
  late final int productId;
  late final int variationId;
  late final int qty;
  late final String note;

  CartRequest.fromJson(Map<String, dynamic> json){
    productId = json['product_id'];
    variationId = json['variation_id'];
    qty = json['qty'];
    note = json['note'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['product_id'] = productId;
    _data['variation_id'] = variationId;
    _data['qty'] = qty;
    _data['note'] = note;
    return _data;
  }
}