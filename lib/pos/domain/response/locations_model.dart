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
    final data = <String, dynamic>{};
    data['location_id'] = locationId;
    data['location_name'] = locationName;
    data['location_decimal_places'] = locationDecimalPlaces;
    data['currency_id'] = currencyId;
    data['currency_name'] = currencyName;
    data['currency_code'] = currencyCode;
    data['currency_symbol'] = currencySymbol;
    return data;
  }
}