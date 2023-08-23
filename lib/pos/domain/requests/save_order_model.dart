import 'package:poslix_app/pos/domain/requests/cart_model.dart';

class SaveOrder {
  SaveOrder({
    required this.updateType,
    required this.cart,
  });
  late final String updateType;
  late final List<CartRequest> cart;

  SaveOrder.fromJson(Map<String, dynamic> json){
    updateType = json['update_type'];
    cart = List.from(json['cart']).map((e)=>CartRequest.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['update_type'] = updateType;
    data['cart'] = cart.map((e)=>e.toJson()).toList();
    return data;
  }
}