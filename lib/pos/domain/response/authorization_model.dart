class AuthorizationResponse {
  AuthorizationResponse({
    required this.token,
    required this.type,
  });
  late final String token;
  late final String type;

  AuthorizationResponse.fromJson(Map<String, dynamic> json){
    token = json['token'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['token'] = token;
    data['type'] = type;
    return data;
  }
}