class AppearanceResponse {
  AppearanceResponse({
    required this.logo,
    required this.name,
    required this.tell,
    required this.txtCustomer,
    required this.orderNo,
    required this.txtDate,
    required this.txtQty,
    required this.txtItem,
    required this.txtAmount,
    required this.txtTax,
    required this.txtTotal,
    required this.footer,
    required this.email,
    required this.address,
    required this.vatNumber,
    required this.customerNumber,
    required this.description,
    required this.unitPrice,
    required this.subTotal
  });
  late final String logo;
  late final String name;
  late final String tell;
  late final String txtCustomer;
  late final String orderNo;
  late final String txtDate;
  late final String txtQty;
  late final String txtItem;
  late final String txtAmount;
  late final String txtTax;
  late final String txtTotal;
  late final String footer;
  late final String email;
  late final String address;
  late final String vatNumber;
  late final String customerNumber;
  late final String description;
  late final String unitPrice;
  late final String subTotal;

  AppearanceResponse.fromJson(Map<String, dynamic> json){
    logo = json['logo'];
    name = json['name'];
    tell = json['tell'];
    txtCustomer = json['txtCustomer'];
    orderNo = json['orderNo'];
    txtDate = json['txtDate'];
    txtQty = json['txtQty'];
    txtItem = json['txtItem'];
    txtAmount = json['txtAmount'];
    txtTax = json['txtTax'];
    txtTotal = json['txtTotal'];
    footer = json['footer'];
    email = json['email'];
    address = json['address'];
    vatNumber = json['vatNumber'];
    customerNumber = json['customerNumber'];
    description = json['description'];
    unitPrice = json['unitPrice'];
    subTotal = json['subTotal'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['logo'] = logo;
    data['name'] = name;
    data['tell'] = tell;
    data['txtCustomer'] = txtCustomer;
    data['orderNo'] = orderNo;
    data['txtDate'] = txtDate;
    data['txtQty'] = txtQty;
    data['txtItem'] = txtItem;
    data['txtAmount'] = txtAmount;
    data['txtTax'] = txtTax;
    data['txtTotal'] = txtTotal;
    data['footer'] = footer;
    data['email'] = email;
    data['address'] = address;
    data['vatNumber'] = vatNumber;
    data['customerNumber'] = customerNumber;
    data['description'] = description;
    data['unitPrice'] = unitPrice;
    data['subTotal'] = subTotal;
    return data;
  }
}
