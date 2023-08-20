class PaymentResponse {
  PaymentResponse({
    required this.id,
    required this.transactionId,
    required this.paymentType,
    required this.amount,
    required this.createdBy,
    this.createdAt,
    required this.notes,
  });
  late final int id;
  late final int transactionId;
  late final String paymentType;
  late final String amount;
  late final int createdBy;
  String? createdAt;
  late final String notes;

  PaymentResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    transactionId = json['transaction_id'] ?? 0;
    paymentType = json['payment_type'] ?? '';
    amount = json['amount'] ?? '';
    createdBy = json['created_by'] ?? 0;
    createdAt = json['createdAt'] ?? '';
    notes = json['notes'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['transaction_id'] = transactionId;
    _data['payment_type'] = paymentType;
    _data['amount'] = amount;
    _data['created_by'] = createdBy;
    _data['created_at'] = createdAt;
    _data['notes'] = notes;
    return _data;
  }
}
