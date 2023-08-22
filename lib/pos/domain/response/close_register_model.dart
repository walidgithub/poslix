class CloseRegisterResponse {
  CloseRegisterResponse({
    required this.message,
  });
  late final String message;

  CloseRegisterResponse.fromJson(Map<String, dynamic> json){
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['message'] = message;
    return data;
  }
}