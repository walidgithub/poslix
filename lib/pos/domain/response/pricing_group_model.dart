class PricingGroupResponse {
  PricingGroupResponse({
    required this.id,
    required this.name,
    required this.businessId,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    required this.locationId,
  });
  late final int id;
  late final String name;
  late final int businessId;
  late final int isActive;
  late final String createdAt;
  late final String updatedAt;
  late final int locationId;

  PricingGroupResponse.fromJson(Map<String, dynamic> json){
    id = json['id'];
    name = json['name'];
    businessId = json['business_id'];
    isActive = json['is_active'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    locationId = json['location_id'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['name'] = name;
    _data['business_id'] = businessId;
    _data['is_active'] = isActive;
    _data['created_at'] = createdAt;
    _data['updated_at'] = updatedAt;
    _data['location_id'] = locationId;
    return _data;
  }
}