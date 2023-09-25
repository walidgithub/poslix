class PermissionsResponse {
  PermissionsResponse({
    required this.id,
    required this.name,
    required this.url,
    required this.method,
  });
  late final int id;
  late final String name;
  late final String url;
  late final String method;

  PermissionsResponse.fromJson(Map<String, dynamic> json){
    id = json['id'];
    name = json['name'];
    url = json['url'];
    method = json['method'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['name'] = name;
    _data['url'] = url;
    _data['method'] = method;
    return _data;
  }
}