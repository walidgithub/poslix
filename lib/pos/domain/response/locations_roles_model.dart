import 'package:poslix_app/pos/domain/response/permissions_model.dart';
import 'package:poslix_app/pos/domain/response/roles_model.dart';

class LocationsRolesResponse {
  LocationsRolesResponse({
    required this.id,
    required this.name,
    required this.roles,
    required this.permissions,
  });
  late final int id;
  late final String name;
  late final List<RolesResponse> roles;
  late final List<PermissionsResponse> permissions;

  LocationsRolesResponse.fromJson(Map<String, dynamic> json){
    id = json['id'];
    name = json['name'];
    roles = List.from(json['roles']).map((e)=>RolesResponse.fromJson(e)).toList();
    permissions = List.from(json['permissions']).map((e)=>PermissionsResponse.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['name'] = name;
    _data['roles'] = roles.map((e)=>e.toJson()).toList();
    _data['permissions'] = permissions.map((e)=>e.toJson()).toList();
    return _data;
  }
}