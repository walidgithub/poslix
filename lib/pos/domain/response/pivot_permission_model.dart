class PivotPermissionResponse {
  PivotPermissionResponse({
    required this.roleId,
    required this.permissionId,
  });
  late final int roleId;
  late final int permissionId;

  PivotPermissionResponse.fromJson(Map<String, dynamic> json){
    roleId = json['role_id'];
    permissionId = json['permission_id'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['role_id'] = roleId;
    _data['permission_id'] = permissionId;
    return _data;
  }
}