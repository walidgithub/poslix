import 'package:poslix_app/pos/domain/response/products_checkout_model.dart';
import 'package:poslix_app/pos/domain/response/payment_model.dart';

class CheckOutResponse {
  CheckOutResponse({
    required this.id,
    required this.locationId,
    required this.type,
    this.subType,
    required this.status,
    this.subStatus,
    required this.isQuotation,
    required this.paymentStatus,
    required this.contactId,
    this.invoiceNo,
    this.refNo,
    required this.taxAmount,
    required this.discountType,
    this.discountAmount,
    required this.notes,
    required this.totalPrice,
    this.document,
      required this.exchangeRate,
      required this.createdBy,
      required this.createdAt,
      required this.updatedAt,
      this.totalTaxes,
    this.taxes,
    this.currencyId,
    required this.products,
    required this.payment,
  });
  late final int id;
  late final int locationId;
  late final String type;
  String? subType;
  late final String status;
  String? subStatus;
  late final int isQuotation;
  late final String paymentStatus;
  late final int contactId;
  String? invoiceNo;
  String? refNo;
  late final String taxAmount;
  late final String discountType;
  String? discountAmount;
  late final String notes;
  late final String totalPrice;
  String? document;
  late final String exchangeRate;
  late final int createdBy;
  late final String createdAt;
  late final String updatedAt;
  String? totalTaxes;
  String? taxes;
  String? currencyId;
  late final List<ProductsCheckOutResponse> products;
  late final PaymentResponse payment;

  CheckOutResponse.fromJson(Map<String, dynamic> json){
    id = json['id'];
    locationId = json['location_id'] ?? 0;
    type = json['type'];
    subType = json['subType'] ?? '';
    status = json['status'];
    subStatus = json['subStatus'] ?? '';
    isQuotation = json['is_quotation'];
    paymentStatus = json['payment_status'];
    contactId = json['contact_id'];
    invoiceNo = json['invoiceNo'] ?? '';
    refNo = json['refNo'] ?? '';
    taxAmount = json['tax_amount'];
    discountType = json['discount_type'] ?? '';
    discountAmount = json['discountAmount'] ?? '';
    notes = json['notes'] ?? '';
    totalPrice = json['total_price'];
    document = json['document'] ?? '';
    exchangeRate = json['exchange_rate'];
    createdBy = json['created_by'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    totalTaxes = json['totalTaxes'] ?? '';
    taxes = json['taxes'] ?? '';
    currencyId = json['currencyId'] ?? '';
    products = List.from(json['products']).map((e)=>ProductsCheckOutResponse.fromJson(e)).toList();
    payment = PaymentResponse.fromJson(json['payment']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['location_id'] = locationId;
    _data['type'] = type;
    _data['sub_type'] = subType;
    _data['status'] = status;
    _data['sub_status'] = subStatus;
    _data['is_quotation'] = isQuotation;
    _data['payment_status'] = paymentStatus;
    _data['contact_id'] = contactId;
    _data['invoice_no'] = invoiceNo;
    _data['ref_no'] = refNo;
    _data['tax_amount'] = taxAmount;
    _data['discount_type'] = discountType;
    _data['discount_amount'] = discountAmount;
    _data['notes'] = notes;
    _data['total_price'] = totalPrice;
    _data['document'] = document;
    _data['exchange_rate'] = exchangeRate;
    _data['created_by'] = createdBy;
    _data['created_at'] = createdAt;
    _data['updated_at'] = updatedAt;
    _data['total_taxes'] = totalTaxes;
    _data['taxes'] = taxes;
    _data['currency_id'] = currencyId;
    _data['products'] = products.map((e)=>e.toJson()).toList();
    _data['payment'] = payment.toJson();
    return _data;
  }
}