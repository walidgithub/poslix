class RolesResponse {
  RolesResponse({
    required this.id,
    required this.name,
  });
  late final int id;
  late final String name;

  RolesResponse.fromJson(Map<String, dynamic> json){
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['name'] = name;
    return _data;
  }
}