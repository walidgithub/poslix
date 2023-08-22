class CurrencyCodeResponse {
  CurrencyCodeResponse({
    required this.id,
    required this.country,
    required this.currency,
    required this.code,
    required this.symbol,
    required this.thousandSeparator,
    required this.decimalSeparator,
    required this.exchangeRate,
    this.createdAt,
    this.updatedAt,
  });
  late final int id;
  late final String country;
  late final String currency;
  late final String code;
  late final String symbol;
  late final String thousandSeparator;
  late final String decimalSeparator;
  late final String exchangeRate;
  String? createdAt;
  String? updatedAt;

  CurrencyCodeResponse.fromJson(Map<String, dynamic> json){
    id = json['id'];
    country = json['country'];
    currency = json['currency'];
    code = json['code'];
    symbol = json['symbol'];
    thousandSeparator = json['thousand_separator'];
    decimalSeparator = json['decimal_separator'];
    exchangeRate = json['exchange_rate'];
    createdAt = json['createdAt'] ?? '';
    updatedAt = json['updatedAt'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['country'] = country;
    data['currency'] = currency;
    data['code'] = code;
    data['symbol'] = symbol;
    data['thousand_separator'] = thousandSeparator;
    data['decimal_separator'] = decimalSeparator;
    data['exchange_rate'] = exchangeRate;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
