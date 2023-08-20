class PivotResponse {
  PivotResponse({
    required this.transactionId,
    required this.productId,
    required this.id,
    required this.variationId,
    this.discountAmount,
    required this.qty,
    required this.qtyReturned,
    required this.taxAmount,
    this.cost,
    this.price,
    this.tailoringTxt,
    this.tailoringCustom,
  });
  late final int transactionId;
  late final int productId;
  late final int id;
  late final int variationId;
  String? discountAmount;
  late final String qty;
  late final String qtyReturned;
  late final String taxAmount;
  String? cost;
  String? price;
  String? tailoringTxt;
  String? tailoringCustom;

  PivotResponse.fromJson(Map<String, dynamic> json){
    transactionId = json['transaction_id'] ?? 0;
    productId = json['product_id'] ?? 0;
    id = json['id'] ?? 0;
    variationId = json['variation_id'] ?? 0;
    discountAmount = json['discountAmount'] ?? '';
    qty = json['qty'] ?? '';
    qtyReturned = json['qtyReturned'] ?? '';
    taxAmount = json['tax_amount'] ?? '';
    cost = json['cost'] ?? '';
    price = json['price'] ?? '';
    tailoringTxt = json['tailoringTxt'] ?? '';
    tailoringCustom = json['tailoringCustom'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['transaction_id'] = transactionId;
    _data['product_id'] = productId;
    _data['id'] = id;
    _data['variation_id'] = variationId;
    _data['discount_amount'] = discountAmount;
    _data['qty'] = qty;
    _data['qty_returned'] = qtyReturned;
    _data['tax_amount'] = taxAmount;
    _data['cost'] = cost;
    _data['price'] = price;
    _data['tailoring_txt'] = tailoringTxt;
    _data['tailoring_custom'] = tailoringCustom;
    return _data;
  }
}