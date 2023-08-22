import 'package:poslix_app/pos/domain/response/stuff_model.dart';

class PermissionsResponse {
  PermissionsResponse({
    required this.id,
    required this.name,
    required this.stuff,
  });
  late final int id;
  late final String name;
  late final StuffResponse stuff;

  PermissionsResponse.fromJson(Map<String, dynamic> json){
    id = json['id'];
    name = json['name'];
    stuff = StuffResponse.fromJson(json['stuff']);
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['stuff'] = stuff.toJson();
    return data;
  }
}