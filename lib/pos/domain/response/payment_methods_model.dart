
import 'package:poslix_app/pos/domain/response/payment_method_model.dart';

class PaymentMethodsModel {
  PaymentMethodsModel({
    required this.payments,
  });
  late final List<PaymentMethodModel> payments;

  PaymentMethodsModel.fromJson(Map<String, dynamic> json){
    payments = List.from(json['payments']).map((e)=>PaymentMethodModel.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['payments'] = payments.map((e)=>e.toJson()).toList();
    return _data;
  }
}
