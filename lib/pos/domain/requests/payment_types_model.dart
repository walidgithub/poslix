class PaymentTypesRequest {
  PaymentTypesRequest({
    required this.paymentId,
    required this.amount,
    required this.note,
  });
  late final int paymentId;
  late final double amount;
  late final String note;

  PaymentTypesRequest.fromJson(Map<String, dynamic> json){
    paymentId = json['payment_id'];
    amount = json['amount'];
    note = json['note'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['payment_id'] = paymentId;
    data['amount'] = amount;
    data['note'] = note;
    return data;
  }
}