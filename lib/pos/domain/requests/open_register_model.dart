class OpenRegisterRequest {
  OpenRegisterRequest({
    required this.handCash,
  });
  late final double handCash;

  OpenRegisterRequest.fromJson(Map<String, dynamic> json){
    handCash = json['hand_cash'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['hand_cash'] = handCash;
    return _data;
  }
}