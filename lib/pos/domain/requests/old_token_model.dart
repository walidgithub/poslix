class OldTokenRequest {
  OldTokenRequest({
    required this.oldToken,
  });
  late final String oldToken;

  OldTokenRequest.fromJson(Map<String, dynamic> json){
    oldToken = json['oldToken'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['oldToken'] = oldToken;
    return data;
  }
}