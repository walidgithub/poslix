class PaymentResponse {
  PaymentResponse({
    required this.id,
    required this.transactionId,
    required this.quotationId,
    required this.paymentType,
    required this.amount,
    required this.createdBy,
    this.createdAt,
    required this.notes,
  });
  late final int id;
  int? transactionId;
  int? quotationId;
  late final String paymentType;
  late final String amount;
  late final int createdBy;
  String? createdAt;
  late final String notes;

  PaymentResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    transactionId = json['transaction_id'] ?? 0;
    quotationId = json['quotationId'] ?? 0;
    paymentType = json['payment_type'] ?? '';
    amount = json['amount'] ?? '';
    createdBy = json['created_by'];
    createdAt = json['createdAt'] ?? '';
    notes = json['notes'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['transaction_id'] = transactionId;
    data['quotation_id'] = quotationId;
    data['payment_type'] = paymentType;
    data['amount'] = amount;
    data['created_by'] = createdBy;
    data['created_at'] = createdAt;
    data['notes'] = notes;
    return data;
  }
}
