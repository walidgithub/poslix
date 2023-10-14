import 'package:poslix_app/pos/domain/response/printing_settings_model.dart';

class LocationSettingsResponse {
  LocationSettingsResponse({
    required this.locationId,
    required this.locationName,
    required this.locationDecimalPlaces,
    required this.currencyId,
    required this.status,
    required this.isMultiLanguage,
    required this.currencyName,
    required this.currencyCode,
    required this.currencySymbol,
    required this.printSetting,
  });
  late final int locationId;
  late final String locationName;
  late final int locationDecimalPlaces;
  late final int currencyId;
  late final String status;
  late final int isMultiLanguage;
  late final String currencyName;
  late final String currencyCode;
  late final String currencySymbol;
  late final List<PrintSettingResponse> printSetting;

  LocationSettingsResponse.fromJson(Map<String, dynamic> json){
    locationId = json['location_id'];
    locationName = json['location_name'];
    locationDecimalPlaces = json['location_decimal_places'];
    currencyId = json['currency_id'];
    status = json['status'];
    isMultiLanguage = json['is_multi_language'];
    currencyName = json['currency_name'];
    currencyCode = json['currency_code'];
    currencySymbol = json['currency_symbol'];
    printSetting = List.from(json['print_setting']).map((e)=>PrintSettingResponse.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['location_id'] = locationId;
    _data['location_name'] = locationName;
    _data['location_decimal_places'] = locationDecimalPlaces;
    _data['currency_id'] = currencyId;
    _data['status'] = status;
    _data['is_multi_language'] = isMultiLanguage;
    _data['currency_name'] = currencyName;
    _data['currency_code'] = currencyCode;
    _data['currency_symbol'] = currencySymbol;
    _data['print_setting'] = printSetting.map((e)=>e.toJson()).toList();
    return _data;
  }
}