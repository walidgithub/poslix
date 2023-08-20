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
  });
  late final String first_name;
  late final String last_name;
  late final String mobile;
  late final String city;
  late final String state;
  late final String country;
  late final String address_line_1;
  late final String address_line_2;
  late final String zip_code;
  late final String shipping_address;

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
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['first_name'] = first_name;
    _data['last_name'] = last_name;
    _data['mobile'] = mobile;
    _data['city'] = city;
    _data['state'] = state;
    _data['country'] = country;
    _data['address_line_1'] = address_line_1;
    _data['address_line_2'] = address_line_2;
    _data['zip_code'] = zip_code;
    _data['shipping_address'] = shipping_address;
    return _data;
  }
}