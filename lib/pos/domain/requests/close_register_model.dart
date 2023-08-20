class CloseRegisterRequest {
  CloseRegisterRequest({
    required this.handCash,
    required this.note,
  });
  late final int handCash;
  late final String note;

  CloseRegisterRequest.fromJson(Map<String, dynamic> json){
    handCash = json['hand_cash'];
    note = json['note'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['hand_cash'] = handCash;
    _data['note'] = note;
    return _data;
  }
}