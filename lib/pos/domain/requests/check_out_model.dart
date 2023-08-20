import 'package:poslix_app/pos/domain/requests/payment_types_model.dart';

import 'cart_model.dart';

class CheckOutRequest {
  CheckOutRequest({
    required this.locationId,
    required this.customerId,
    required this.discountType,
    required this.discountAmount,
    required this.notes,
    required this.cart,
    required this.taxType,
    required this.taxAmount,
    required this.payment,
  });
  late final int locationId;
  late final int customerId;
  late final String discountType;
  late final String discountAmount;
  late final String notes;
  late final List<CartRequest> cart;
  late final String taxType;
  late final double taxAmount;
  late final List<PaymentTypesRequest> payment;

  CheckOutRequest.fromJson(Map<String, dynamic> json){
    locationId = json['location_id'];
    customerId = json['customer_id'];
    discountType = json['discount_type'];
    discountAmount = json['discount_amount'];
    notes = json['notes'];
    cart = List.from(json['cart']).map((e)=>CartRequest.fromJson(e)).toList();
    taxType = json['tax_type'];
    taxAmount = json['tax_amount'];
    payment = List.from(json['payment']).map((e)=>PaymentTypesRequest.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['location_id'] = locationId;
    data['customer_id'] = customerId;
    data['discount_type'] = discountType;
    data['discount_amount'] = discountAmount;
    data['notes'] = notes;
    data['cart'] = cart.map((e)=>e.toJson()).toList();
    data['tax_type'] = taxType;
    data['tax_amount'] = taxAmount;
    data['payment'] = payment.map((v) => v.toJson()).toList();
    return data;
  }
}