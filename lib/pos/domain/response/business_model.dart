import 'locations_model.dart';

class BusinessResponse {
  BusinessResponse({
    required this.id,
    required this.type,
    required this.typeId,
    required this.name,
    this.email,
    required this.locations,
  });
  late final int id;
  late final String type;
  late final int typeId;
  late final String name;
  String? email;
  late final List<LocationsResponse> locations;

  BusinessResponse.fromJson(Map<String, dynamic> json){
    id = json['id'];
    type = json['type'];
    typeId = json['type_id'];
    name = json['name'];
    email = json['name'] ?? '';
    locations = List.from(json['locations']).map((e)=>LocationsResponse.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['type'] = type;
    _data['type_id'] = typeId;
    _data['name'] = name;
    _data['email'] = email;
    _data['locations'] = locations.map((e)=>e.toJson()).toList();
    return _data;
  }
}