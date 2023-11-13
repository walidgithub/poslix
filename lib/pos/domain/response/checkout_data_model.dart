import 'package:poslix_app/pos/domain/response/payment_model.dart';
import 'package:poslix_app/pos/domain/response/products_checkout_model.dart';

class CheckOutDataResponse {
  CheckOutDataResponse({
    required this.id,
    required this.relatedTransactionId,
    required this.locationId,
    this.transferredLocationId,
    required this.type,
    this.subType,
    required this.status,
    this.subStatus,
    required this.isQuotation,
    required this.paymentStatus,
    required this.contactId,
    required this.supplierId,
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
    required this.payment,
  });
  late final int id;
  int? relatedTransactionId;
  late final int locationId;
  int? transferredLocationId;
  late final String type;
  String? subType;
  late final String status;
  String? subStatus;
  late final int isQuotation;
  late final String paymentStatus;
  late final int contactId;
  late final int supplierId;
  String? invoiceNo;
  String? refNo;
  late final String taxAmount;
  String? discountType;
  String? discountAmount;
  String? notes;
  late final String totalPrice;
  String? document;
  late final String exchangeRate;
  late final int createdBy;
  late final String createdAt;
  late final String updatedAt;
  String? totalTaxes;
  String? taxes;
  String? currencyId;
  late final List<PaymentResponse> payment;

  CheckOutDataResponse.fromJson(Map<String, dynamic> json){
    id = json['id'];
    relatedTransactionId = json['related_transaction_id'] ?? 0;
    locationId = json['location_id'];
    transferredLocationId = json['transferredLocationId'] ?? 0;
    type = json['type'];
    subType = json['subType'] ?? '';
    status = json['status'];
    subStatus = json['subStatus'] ?? '';
    isQuotation = json['is_quotation'];
    paymentStatus = json['payment_status'];
    contactId = json['contact_id'];
    supplierId = json['supplier_id'];
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
    payment = List.from(json['payment']).map((e)=>PaymentResponse.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['related_transaction_id'] = relatedTransactionId;
    _data['location_id'] = locationId;
    _data['transferred_location_id'] = transferredLocationId;
    _data['type'] = type;
    _data['sub_type'] = subType;
    _data['status'] = status;
    _data['sub_status'] = subStatus;
    _data['is_quotation'] = isQuotation;
    _data['payment_status'] = paymentStatus;
    _data['contact_id'] = contactId;
    _data['supplier_id'] = supplierId;
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
    _data['payment'] = payment.map((e)=>e.toJson()).toList();
    return _data;
  }
}