class CustomerResponse {
  CustomerResponse({
    required this.id,
    required this.locationId,
    required this.type,
    required this.firstName,
    required this.lastName,
    this.name,
    this.email,
    this.contactId,
    required this.contactStatus,
    required this.city,
    required this.state,
    required this.country,
    required this.addressLine_1,
    required this.addressLine_2,
    required this.zipCode,
    required this.mobile,
    required this.createdBy,
    required this.shippingAddress,
    this.deletedAt,
    required this.createdAt,
    this.updatedAt,
  });
  int? id;
  late final int locationId;
  late final String type;
  late final String firstName;
  late final String lastName;
  String? name;
  String? email;
  String? contactId;
  late final String contactStatus;
  late final String city;
  late final String state;
  late final String country;
  late final String addressLine_1;
  late final String addressLine_2;
  late final String zipCode;
  late final String mobile;
  late final int createdBy;
  late final String shippingAddress;
  String? deletedAt;
  late final String createdAt;
  String? updatedAt;

  CustomerResponse.fromJson(Map<String, dynamic> json){
    id = json['id'];
    locationId = json['location_id'] ?? 0;
    type = json['type'] ?? '';
    firstName = json['first_name'] ?? '';
    lastName = json['last_name'] ?? '';
    name = json['name'] ?? '';
    email = json['email'] ?? '';
    contactId = json['contactId'] ?? '';
    contactStatus = json['contact_status'] ?? '';
    city = json['city'] ?? '';
    state = json['state'] ?? '';
    country = json['country'] ?? '';
    addressLine_1 = json['address_line_1'] ?? '';
    addressLine_2 = json['address_line_2'] ?? '';
    zipCode = json['zip_code'] ?? '';
    mobile = json['mobile'] ?? '';
    createdBy = json['created_by'] ?? 0;
    shippingAddress = json['shipping_address'] ?? '';
    deletedAt = json['deletedAt'] ?? '';
    createdAt = json['created_at'] ?? '';
    updatedAt = json['updatedAt'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['location_id'] = locationId;
    _data['type'] = type;
    _data['first_name'] = firstName;
    _data['last_name'] = lastName;
    _data['name'] = name;
    _data['email'] = email;
    _data['contact_id'] = contactId;
    _data['contact_status'] = contactStatus;
    _data['city'] = city;
    _data['state'] = state;
    _data['country'] = country;
    _data['address_line_1'] = addressLine_1;
    _data['address_line_2'] = addressLine_2;
    _data['zip_code'] = zipCode;
    _data['mobile'] = mobile;
    _data['created_by'] = createdBy;
    _data['shipping_address'] = shippingAddress;
    _data['deleted_at'] = deletedAt;
    _data['created_at'] = createdAt;
    _data['updated_at'] = updatedAt;
    return _data;
  }
}