class LocationsResponse {
  LocationsResponse({
    required this.locationId,
    required this.locationName,
    required this.locationDecimalPlaces,
    required this.currencyId,
    required this.currencyName,
    required this.currencyCode,
    required this.currencySymbol,
  });
  late final int locationId;
  late final String locationName;
  late final int locationDecimalPlaces;
  late final int currencyId;
  late final String currencyName;
  late final String currencyCode;
  late final String currencySymbol;

  LocationsResponse.fromJson(Map<String, dynamic> json){
    locationId = json['location_id'];
    locationName = json['location_name'];
    locationDecimalPlaces = json['location_decimal_places'];
    currencyId = json['currency_id'];
    currencyName = json['currency_name'];
    currencyCode = json['currency_code'];
    currencySymbol = json['currency_symbol'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['location_id'] = locationId;
    _data['location_name'] = locationName;
    _data['location_decimal_places'] = locationDecimalPlaces;
    _data['currency_id'] = currencyId;
    _data['currency_name'] = currencyName;
    _data['currency_code'] = currencyCode;
    _data['currency_symbol'] = currencySymbol;
    return _data;
  }
}