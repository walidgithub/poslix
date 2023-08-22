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
  late final List<PaymentResponse> payment;

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
    payment = List.from(json['payment']).map((e)=>PaymentResponse.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['location_id'] = locationId;
    data['type'] = type;
    data['sub_type'] = subType;
    data['status'] = status;
    data['sub_status'] = subStatus;
    data['is_quotation'] = isQuotation;
    data['payment_status'] = paymentStatus;
    data['contact_id'] = contactId;
    data['invoice_no'] = invoiceNo;
    data['ref_no'] = refNo;
    data['tax_amount'] = taxAmount;
    data['discount_type'] = discountType;
    data['discount_amount'] = discountAmount;
    data['notes'] = notes;
    data['total_price'] = totalPrice;
    data['document'] = document;
    data['exchange_rate'] = exchangeRate;
    data['created_by'] = createdBy;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['total_taxes'] = totalTaxes;
    data['taxes'] = taxes;
    data['currency_id'] = currencyId;
    data['products'] = products.map((e)=>e.toJson()).toList();
    data['payment'] = payment.map((e)=>e.toJson()).toList();
    return data;
  }
}