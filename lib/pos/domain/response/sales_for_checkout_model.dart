class SalesForCheckoutModel {
  SalesForCheckoutModel({
    required this.id,
    required this.userName,
    required this.contactName,
    required this.contactMobile,
    required this.subTotal,
    required this.payed,
    required this.due,
    this.discount,
    required this.tax,
    required this.date,
    required this.transactionStatus,
    required this.paymentStatus,
    required this.paymentMethod,
    required this.type,
  });
  late final int id;
  late final String userName;
  late final String contactName;
  late final String contactMobile;
  late final String subTotal;
  late final String payed;
  late final String due;
  int? discount;
  late final String tax;
  late final String date;
  late final String transactionStatus;
  late final String paymentStatus;
  late final String paymentMethod;
  late final String type;

  SalesForCheckoutModel.fromJson(Map<String, dynamic> json){
    id = json['id'];
    userName = json['user_name'] ?? '';
    contactName = json['contact_name'] ?? '';
    contactMobile = json['contact_mobile'] ?? '';
    subTotal = json['sub_total'].toString() ?? '';
    payed = json['payed'].toString() ?? '';
    due = json['due'].toString();
    discount = json['discount'];
    tax = json['tax'] ?? '';
    date = json['date'] ?? '';
    transactionStatus = json['transaction_status'] ?? '';
    paymentStatus = json['payment_status'] ?? '';
    paymentMethod = json['payment_method'] ?? '';
    type = json['type'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['user_name'] = userName;
    data['contact_name'] = contactName;
    data['contact_mobile'] = contactMobile;
    data['sub_total'] = subTotal;
    data['payed'] = payed;
    data['due'] = due;
    data['discount'] = discount;
    data['tax'] = tax;
    data['date'] = date;
    data['transaction_status'] = transactionStatus;
    data['payment_status'] = paymentStatus;
    data['payment_method'] = paymentMethod;
    data['type'] = type;
    return data;
  }
}