import 'package:poslix_app/pos/domain/response/user_model.dart';

import 'authorization_model.dart';

class LoginResponse {
  LoginResponse({
    required this.user,
    required this.business,
    required this.authorization,
  });
  late final UserResponse user;
  late final int business;
  late final AuthorizationResponse authorization;

  LoginResponse.fromJson(Map<String, dynamic> json){
    user = UserResponse.fromJson(json['user']);
    business = json['business'];
    authorization = AuthorizationResponse.fromJson(json['authorization']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['user'] = user.toJson();
    _data['business'] = business;
    _data['authorization'] = authorization.toJson();
    return _data;
  }
}