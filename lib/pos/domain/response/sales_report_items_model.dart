import 'package:poslix_app/pos/domain/response/product_in_order_report_model.dart';
import 'package:poslix_app/pos/domain/response/products_model.dart';

class SalesReportItemsResponse {
  SalesReportItemsResponse({
    required this.orderId,
    required this.userFirstName,
    this.userLastName,
    required this.contactFirstName,
    required this.contactLastName,
    required this.contactMobile,
    required this.date,
    required this.status,
    required this.type,
    required this.products,
  });
  late final int orderId;
  late final String userFirstName;
  String? userLastName;
  late final String contactFirstName;
  late final String contactLastName;
  late final String contactMobile;
  late final String qty;
  int? price;
  int? cost;
  late final String tax;
  late final String date;
  late final String status;
  late final String type;
  late final List<ProductsInOrdersResponse> products;

  SalesReportItemsResponse.fromJson(Map<String, dynamic> json){
    orderId = json['order_id'];
    userFirstName = json['user_first_name'];
    userLastName = json['userLastName'] ?? '';
    contactFirstName = json['contact_first_name'];
    contactLastName = json['contact_last_name'];
    contactMobile = json['contact_mobile'];
    date = json['date'];
    status = json['status'];
    type = json['type'];
    products = List.from(json['products']).map((e)=>ProductsInOrdersResponse.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['order_id'] = orderId;
    _data['user_first_name'] = userFirstName;
    _data['user_last_name'] = userLastName;
    _data['contact_first_name'] = contactFirstName;
    _data['contact_last_name'] = contactLastName;
    _data['contact_mobile'] = contactMobile;
    _data['date'] = date;
    _data['status'] = status;
    _data['type'] = type;
    _data['products'] = products.map((e)=>e.toJson()).toList();
    return _data;
  }
}