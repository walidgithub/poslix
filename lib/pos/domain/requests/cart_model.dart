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
    final data = <String, dynamic>{};
    data['product_id'] = productId;
    data['variation_id'] = variationId;
    data['qty'] = qty;
    data['note'] = note;
    return data;
  }
}