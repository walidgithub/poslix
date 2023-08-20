class CurrencyResponse {
  CurrencyResponse({
    required this.currencyName,
    required this.currencyCode,
    required this.currencySymbol,
  });
  late final String currencyName;
  late final String currencyCode;
  late final String currencySymbol;

  CurrencyResponse.fromJson(Map<String, dynamic> json){
    currencyName = json['currency_name'];
    currencyCode = json['currency_code'];
    currencySymbol = json['currency_symbol'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['currency_name'] = currencyName;
    _data['currency_code'] = currencyCode;
    _data['currency_symbol'] = currencySymbol;
    return _data;
  }
}