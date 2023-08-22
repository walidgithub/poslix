class LogoutResponse {
  LogoutResponse({
    required this.message,
  });
  late final String message;

  LogoutResponse.fromJson(Map<String, dynamic> json){
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['message'] = message;
    return data;
  }
}