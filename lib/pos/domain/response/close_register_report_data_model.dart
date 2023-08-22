class CloseRegisterReportDataResponse {
  CloseRegisterReportDataResponse({
    required this.id,
    required this.firstName,
    this.lastName,
    required this.handCash,
    required this.cart,
    required this.cash,
    required this.cheque,
    required this.bank,
    required this.date,
    this.note,
    required this.status,
  });
  late final int id;
  late final String firstName;
  String? lastName;
  late final String handCash;
  late final String cart;
  late final String cash;
  late final String cheque;
  late final int? bank;
  late final String date;
  late final String? note;
  late final String status;

  CloseRegisterReportDataResponse.fromJson(Map<String, dynamic> json){
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['lastName'] ?? '';
    handCash = json['hand_cash'];
    cart = json['cart'];
    cash = json['cash'];
    cheque = json['cheque'];
    bank = json['bank'];
    date = json['date'];
    note = json['note'] ?? '';
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['hand_cash'] = handCash;
    data['cart'] = cart;
    data['cash'] = cash;
    data['cheque'] = cheque;
    data['bank'] = bank;
    data['date'] = date;
    data['note'] = note;
    data['status'] = status;
    return data;
  }
}