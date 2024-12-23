import 'locations_roles_model.dart';

class UserResponse {
  UserResponse({
    required this.id,
    required this.userType,
    required this.firstName,
    this.lastName,
    required this.username,
    required this.contactNumber,
    required this.email,
    required this.password,
    required this.ownerId,
    required this.status,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
    required this.locations,
  });
  late final int id;
  late final String userType;
  late final String firstName;
  String? lastName;
  late final String username;
  late final String contactNumber;
  late final String email;
  late final String password;
  late final int ownerId;
  late final String status;
  String? deletedAt;
  String? createdAt;
  String? updatedAt;
  late final List<LocationsRolesResponse> locations;

  UserResponse.fromJson(Map<String, dynamic> json){
    id = json['id'];
    userType = json['user_type'];
    firstName = json['first_name'];
    lastName = json['lastName'] ?? '';
    username = json['username'] ?? '';
    contactNumber = json['contact_number'];
    email = json['email'];
    password = json['password'];
    ownerId = json['owner_id'] ?? 0;
    status = json['status'];
    deletedAt = json['deletedAt'] ?? '';
    createdAt = json['createdAt'] ?? '';
    updatedAt = json['updatedAt'] ?? '';
    locations = List.from(json['locations']).map((e)=>LocationsRolesResponse.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['user_type'] = userType;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['username'] = username;
    data['contact_number'] = contactNumber;
    data['email'] = email;
    data['password'] = password;
    data['owner_id'] = ownerId;
    data['status'] = status;
    data['deleted_at'] = deletedAt;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['locations'] = locations.map((e)=>e.toJson()).toList();
    return data;
  }
}