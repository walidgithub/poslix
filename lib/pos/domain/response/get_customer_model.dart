import 'package:poslix_app/pos/domain/response/customer_model.dart';

class GetCustomerResponse {
  CustomerResponse? profile;

  GetCustomerResponse({this.profile});

  GetCustomerResponse.fromJson(Map<String, dynamic> json) {
    profile =
    json['profile'] != null ? CustomerResponse.fromJson(json['profile']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (profile != null) {
      data['profile'] = profile!.toJson();
    }
    return data;
  }
}