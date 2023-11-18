import 'package:poslix_app/pos/domain/response/product_in_order_report_model.dart';
import 'package:poslix_app/pos/domain/response/products_model.dart';

class SalesReportItemsDataResponse {
  SalesReportItemsDataResponse({
    required this.orderId,
    required this.userFirstName,
    this.userLastName,
    required this.contactFirstName,
    required this.contactLastName,
    required this.contactMobile,
    this.supplierName,
    this.supplierMobile,
    this.supplierEmail,
    required this.qty,
    required this.price,
    required this.cost,
    required this.tax,
    required this.date,
    required this.status,
    required this.products,
  });
  late final int orderId;
  late final String userFirstName;
  String? userLastName;
  late final String contactFirstName;
  late final String contactLastName;
  late final String contactMobile;
  String? supplierName;
  String? supplierMobile;
  String? supplierEmail;
  late final int qty;
  late final int price;
  late final int cost;
  late final String tax;
  late final String date;
  late final String status;
  late final String type;
  late final List<ProductsInOrdersResponse> products;

  SalesReportItemsDataResponse.fromJson(Map<String, dynamic> json){
    orderId = json['order_id'];
    type = json['type'];
    userFirstName = json['user_first_name'];
    userLastName = json['user_last_name'] ?? '';
    contactFirstName = json['contact_first_name'];
    contactLastName = json['contact_last_name'];
    contactMobile = json['contact_mobile'];
    supplierName = json['supplier_name'] ?? '';
    supplierMobile = json['supplier_mobile'] ?? '';
    supplierEmail = json['supplier_email'] ?? '';
    qty = json['qty'];
    price = json['price'];
    cost = json['cost'];
    tax = json['tax'];
    date = json['date'];
    status = json['status'];
    products = List.from(json['products']).map((e)=>ProductsInOrdersResponse.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['order_id'] = orderId;
    _data['type'] = type;
    _data['user_first_name'] = userFirstName;
    _data['user_last_name'] = userLastName;
    _data['contact_first_name'] = contactFirstName;
    _data['contact_last_name'] = contactLastName;
    _data['contact_mobile'] = contactMobile;
    _data['supplier_name'] = supplierName;
    _data['supplier_mobile'] = supplierMobile;
    _data['supplier_email'] = supplierEmail;
    _data['qty'] = qty;
    _data['price'] = price;
    _data['cost'] = cost;
    _data['tax'] = tax;
    _data['date'] = date;
    _data['status'] = status;
    _data['products'] = products.map((e)=>e.toJson()).toList();
    return _data;
  }
}