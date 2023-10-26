class CustomerRequest {
  CustomerRequest({
    required this.first_name,
    required this.last_name,
    required this.mobile,
    required this.city,
    required this.state,
    required this.country,
    required this.address_line_1,
    required this.address_line_2,
    required this.zip_code,
    required this.shipping_address,
    required this.priceGroupsId,
  });
  late final String first_name;
  late final String last_name;
  late final int mobile;
  late final String city;
  late final String state;
  late final String country;
  late final String address_line_1;
  late final String address_line_2;
  late final String zip_code;
  late final String shipping_address;
  int? priceGroupsId;

  CustomerRequest.fromJson(Map<String, dynamic> json){
    first_name = json['first_name'];
    last_name = json['last_name'];
    mobile = json['mobile'];
    city = json['city'];
    state = json['state'];
    country = json['country'];
    address_line_1 = json['address_line_1'];
    address_line_2 = json['address_line_2'];
    zip_code = json['zip_code'];
    shipping_address = json['shipping_address'];
    priceGroupsId = json['price_groups_id'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['first_name'] = first_name;
    data['last_name'] = last_name;
    data['mobile'] = mobile;
    data['city'] = city;
    data['state'] = state;
    data['country'] = country;
    data['address_line_1'] = address_line_1;
    data['address_line_2'] = address_line_2;
    data['zip_code'] = zip_code;
    data['shipping_address'] = shipping_address;
    data['price_groups_id'] = priceGroupsId;
    return data;
  }
}