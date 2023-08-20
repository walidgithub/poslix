class CustomerModel {
  CustomerModel({
    required this.firstName,
    required this.lastName,
    required this.mobile,
    required this.city,
    required this.state,
    required this.country,
    required this.addressLine_1,
    required this.addressLine_2,
    required this.zipCode,
    required this.shippingAddress,
  });
  late final String firstName;
  late final String lastName;
  late final int mobile;
  late final String city;
  late final String state;
  late final String country;
  late final String addressLine_1;
  late final String addressLine_2;
  late final String zipCode;
  late final String shippingAddress;

  CustomerModel.fromJson(Map<String, dynamic> json){
    firstName = json['first_name'];
    lastName = json['last_name'];
    mobile = json['mobile'];
    city = json['city'];
    state = json['state'];
    country = json['country'];
    addressLine_1 = json['address_line_1'];
    addressLine_2 = json['address_line_2'];
    zipCode = json['zip_code'];
    shippingAddress = json['shipping_address'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['first_name'] = firstName;
    _data['last_name'] = lastName;
    _data['mobile'] = mobile;
    _data['city'] = city;
    _data['state'] = state;
    _data['country'] = country;
    _data['address_line_1'] = addressLine_1;
    _data['address_line_2'] = addressLine_2;
    _data['zip_code'] = zipCode;
    _data['shipping_address'] = shippingAddress;
    return _data;
  }
}