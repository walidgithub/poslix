class PaymentTypesRequest {
  PaymentTypesRequest({
    required this.paymentType,
    required this.amount,
    required this.note,
  });
  late final String paymentType;
  late final double amount;
  late final String note;

  PaymentTypesRequest.fromJson(Map<String, dynamic> json){
    paymentType = json['payment_type'];
    amount = json['amount'];
    note = json['note'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['payment_type'] = paymentType;
    data['amount'] = amount;
    data['note'] = note;
    return data;
  }
}