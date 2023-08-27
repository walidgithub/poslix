import 'package:poslix_app/pos/domain/response/prices_model.dart';

class PackagesResponse {
  int? id;
  int? locationId;
  int? parentId;
  int? tailoringTypeId;
  List<PricesResponse>? pricesJson;
  String? fabricIds;
  int? createdBy;
  String? createdAt;

  PackagesResponse(
      {this.id,
        this.locationId,
        this.parentId,
        this.tailoringTypeId,
        this.pricesJson,
        this.fabricIds,
        this.createdBy,
        this.createdAt});

  PackagesResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    locationId = json['location_id'];
    parentId = json['parent_id'];
    tailoringTypeId = json['tailoring_type_id'];
    if (json['prices_json'] != null) {
      pricesJson = <PricesResponse>[];
      json['prices_json'].forEach((v) {
        pricesJson!.add(PricesResponse.fromJson(v));
      });
    }
    fabricIds = json['fabric_ids'];
    createdBy = json['created_by'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['location_id'] = locationId;
    data['parent_id'] = parentId;
    data['tailoring_type_id'] = tailoringTypeId;
    if (pricesJson != null) {
      data['prices_json'] = pricesJson!.map((v) => v.toJson()).toList();
    }
    data['fabric_ids'] = fabricIds;
    data['created_by'] = createdBy;
    data['created_at'] = createdAt;
    return data;
  }
}