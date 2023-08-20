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
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['name'] = name;
    _data['stuff'] = stuff.toJson();
    return _data;
  }
}