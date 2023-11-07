class PricingGroupCustomersResponse {
  PricingGroupCustomersResponse({
    required this.id,
    required this.type,
    required this.firstName,
    required this.priceGroupsId,
  });
  late final int id;
  late final String type;
  late final String firstName;
  late final int priceGroupsId;

  PricingGroupCustomersResponse.fromJson(Map<String, dynamic> json){
    id = json['id'];
    type = json['type'];
    firstName = json['first_name'];
    priceGroupsId = json['price_groups_id'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['type'] = type;
    _data['first_name'] = firstName;
    _data['price_groups_id'] = priceGroupsId;
    return _data;
  }
}