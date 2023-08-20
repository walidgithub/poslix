class OldTokenRequest {
  OldTokenRequest({
    required this.oldToken,
  });
  late final String oldToken;

  OldTokenRequest.fromJson(Map<String, dynamic> json){
    oldToken = json['oldToken'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['oldToken'] = oldToken;
    return _data;
  }
}