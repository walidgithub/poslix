class SizesResponse {
  int? id;
  int? tailoringTypeId;
  String? name;
  int? isPrimary;

  SizesResponse({this.id, this.tailoringTypeId, this.name, this.isPrimary});

  SizesResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    tailoringTypeId = json['tailoring_type_id'];
    name = json['name'];
    isPrimary = json['is_primary'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['tailoring_type_id'] = this.tailoringTypeId;
    data['name'] = this.name;
    data['is_primary'] = this.isPrimary;
    return data;
  }
}