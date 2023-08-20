class RegisterDataResponse {
  double? cash;
  double? card;
  double? cheque;
  double? bank;

  RegisterDataResponse({this.cash, this.card, this.cheque, this.bank});

  RegisterDataResponse.fromJson(Map<String, dynamic> json) {
    cash = (json['cash'] as num).toDouble();
    card = (json['card'] as num).toDouble();
    cheque = (json['cheque'] as num).toDouble();
    bank = (json['bank'] as num).toDouble();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['cash'] = cash;
    data['card'] = card;
    data['cheque'] = cheque;
    data['bank'] = bank;
    return data;
  }
}