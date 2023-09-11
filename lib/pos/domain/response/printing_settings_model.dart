class PrintSettingResponse {
  PrintSettingResponse({
    required this.name,
    required this.connection,
    required this.ip,
    required this.printType,
    required this.status,
    required this.locationId,
  });
  late final String name;
  late final String connection;
  late final String ip;
  late final String printType;
  late final int status;
  late final int locationId;

  PrintSettingResponse.fromJson(Map<String, dynamic> json){
    name = json['name'];
    connection = json['connection'];
    ip = json['ip'];
    printType = json['print_type'];
    status = json['status'];
    locationId = json['location_id'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['name'] = name;
    _data['connection'] = connection;
    _data['ip'] = ip;
    _data['print_type'] = printType;
    _data['status'] = status;
    _data['location_id'] = locationId;
    return _data;
  }
}