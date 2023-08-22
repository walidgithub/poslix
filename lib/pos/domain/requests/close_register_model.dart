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
    final data = <String, dynamic>{};
    data['hand_cash'] = handCash;
    data['note'] = note;
    return data;
  }
}