import 'package:poslix_app/pos/domain/response/pivot_permission_model.dart';

class PermissionsResponse {
  PermissionsResponse({
    required this.id,
    required this.name,
    required this.url,
    required this.method,
    required this.pivot,
  });
  late final int id;
  late final String name;
  late final String url;
  late final String method;
  late final PivotPermissionResponse pivot;

  PermissionsResponse.fromJson(Map<String, dynamic> json){
    id = json['id'];
    name = json['name'];
    url = json['url'];
    method = json['method'];
    pivot = PivotPermissionResponse.fromJson(json['pivot']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['name'] = name;
    _data['url'] = url;
    _data['method'] = method;
    _data['pivot'] = pivot.toJson();
    return _data;
  }
}