import 'package:poslix_app/pos/domain/response/sizes_model.dart';

class TailoringTypesModel {
  int? id;
  int? locationId;
  String? name;
  String? multipleValue;
  int? createdBy;
  String? createdAt;
  String? extras;
  List<SizesResponse>? sizes;

  TailoringTypesModel(
      {this.id,
        this.locationId,
        this.name,
        this.multipleValue,
        this.createdBy,
        this.createdAt,
        this.extras,
        this.sizes});

  TailoringTypesModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    locationId = json['location_id'];
    name = json['name'];
    multipleValue = json['multiple_value'];
    createdBy = json['created_by'];
    createdAt = json['created_at'] ?? '';
    extras = json['extras'];
    if (json['sizes'] != null) {
      sizes = <SizesResponse>[];
      json['sizes'].forEach((v) {
        sizes!.add(SizesResponse.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['location_id'] = locationId;
    data['name'] = name;
    data['multiple_value'] = multipleValue;
    data['created_by'] = createdBy;
    data['created_at'] = createdAt;
    data['extras'] = extras;
    if (sizes != null) {
      data['sizes'] = sizes!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}