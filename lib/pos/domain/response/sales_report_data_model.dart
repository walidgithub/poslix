class SalesReportDataModel {
  SalesReportDataModel({
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
  String? discount;
  late final String tax;
  late final String date;
  late final String transactionStatus;
  late final String paymentStatus;
  late final String paymentMethod;
  late final String type;

  SalesReportDataModel.fromJson(Map<String, dynamic> json){
    id = json['id'];
    userName = json['user_name'] ?? '';
    contactName = json['contact_name'] ?? '';
    contactMobile = json['contact_mobile'] ?? '';
    subTotal = json['sub_total'].toString() ?? '';
    payed = json['payed'].toString() ?? '';
    due = json['due'].toString() ?? '';
    discount = json['discount'] ?? '';
    tax = json['tax'] ?? '';
    date = json['date'] ?? '';
    transactionStatus = json['transaction_status'] ?? '';
    paymentStatus = json['payment_status'] ?? '';
    paymentMethod = json['payment_method'] ?? '';
    type = json['type'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['user_name'] = userName;
    _data['contact_name'] = contactName;
    _data['contact_mobile'] = contactMobile;
    _data['sub_total'] = subTotal;
    _data['payed'] = payed;
    _data['due'] = due;
    _data['discount'] = discount;
    _data['tax'] = tax;
    _data['date'] = date;
    _data['transaction_status'] = transactionStatus;
    _data['payment_status'] = paymentStatus;
    _data['payment_method'] = paymentMethod;
    _data['type'] = type;
    return _data;
  }
}