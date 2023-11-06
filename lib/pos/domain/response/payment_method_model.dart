class PaymentMethodModel {
  PaymentMethodModel({
    required this.id,
    required this.name,
    required this.locationId,
    required this.enableFlag,
    this.createdAt,
    this.updatedAt,
  });
  late final int id;
  late final String name;
  late final int locationId;
  late final int enableFlag;
  String? createdAt;
  String? updatedAt;

  PaymentMethodModel.fromJson(Map<String, dynamic> json){
    id = json['id'];
    name = json['name'];
    locationId = json['location_id'];
    enableFlag = json['enable_flag'];
    createdAt = json['created_at'] ?? '';
    updatedAt = json['updated_at'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['name'] = name;
    _data['location_id'] = locationId;
    _data['enable_flag'] = enableFlag;
    _data['created_at'] = createdAt;
    _data['updated_at'] = updatedAt;
    return _data;
  }
}