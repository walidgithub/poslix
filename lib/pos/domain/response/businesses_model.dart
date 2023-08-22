import 'locations_model.dart';

class BusinessesResponse {
  BusinessesResponse({
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
  late final String? email;
  late final List<LocationsResponse> locations;

  BusinessesResponse.fromJson(Map<String, dynamic> json){
    id = json['id'];
    type = json['type'];
    typeId = json['type_id'];
    name = json['name'];
    email = null;
    locations = List.from(json['locations']).map((e)=>LocationsResponse.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['type'] = type;
    data['type_id'] = typeId;
    data['name'] = name;
    data['email'] = email;
    data['locations'] = locations.map((e)=>e.toJson()).toList();
    return data;
  }
}