class OpenRegisterRequest {
  OpenRegisterRequest({
    required this.handCash,
  });
  late final double handCash;

  OpenRegisterRequest.fromJson(Map<String, dynamic> json){
    handCash = json['hand_cash'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['hand_cash'] = handCash;
    return data;
  }
}