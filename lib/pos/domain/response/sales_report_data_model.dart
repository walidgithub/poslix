class SalesReportDataModel {
  SalesReportDataModel({
    required this.id,
    required this.contactId,
    required this.userName,
    required this.contactName,
    required this.contactMobile,
    // required this.total,
    required this.subTotal,
    // required this.payed,
    // required this.due,
    // required this.discount,
    // required this.tax,
    // required this.date,
    required this.transactionStatus,
    required this.paymentStatus,
    required this.paymentMethod,
    required this.type,
  });
  late final int id;
  late final int contactId;
  late final String userName;
  late final String contactName;
  late final String contactMobile;
  // late final double total;
  late final double subTotal;
  // late final double payed;
  // late final int due;
  // late final String discount;
  // int? tax;
  late final String date;
  late final String transactionStatus;
  late final String paymentStatus;
  late final List<String> paymentMethod;
  late final String type;

  SalesReportDataModel.fromJson(Map<String, dynamic> json){
    id = json['id'];
    contactId = json['contact_id'];
    userName = json['user_name'];
    contactName = json['contact_name'];
    contactMobile = json['contact_mobile'];
    // total = json['total'];
    subTotal = json['sub_total'];
    // payed = json['payed'];
    // due = json['due'];
    // discount = json['discount'];
    // tax = json['tax'];
    date = json['date'];
    transactionStatus = json['transaction_status'];
    paymentStatus = json['payment_status'];
    paymentMethod = List.castFrom<dynamic, String>(json['payment_method']);
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['contact_id'] = contactId;
    _data['user_name'] = userName;
    _data['contact_name'] = contactName;
    _data['contact_mobile'] = contactMobile;
    // _data['total'] = total;
    _data['sub_total'] = subTotal;
    // _data['payed'] = payed;
    // _data['due'] = due;
    // _data['discount'] = discount;
    // _data['tax'] = tax;
    _data['date'] = date;
    _data['transaction_status'] = transactionStatus;
    _data['payment_status'] = paymentStatus;
    _data['payment_method'] = paymentMethod;
    _data['type'] = type;
    return _data;
  }
}