import 'package:poslix_app/pos/domain/response/tax_group_model.dart';

class TaxesResponse {
  TaxesResponse({
    required this.id,
    required this.locationId,
    required this.name,
    required this.amount,
    required this.isTaxGroup,
    required this.forTaxGroup,
    required this.createdBy,
    this.woocommerceTaxRateId,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
    required this.forTaxInclusive,
    required this.forTaxExclusive,
    required this.isIncOrExc,
    required this.type,
    required this.isPrimary,
    required this.taxType,
    required this.taxGroup,
  });
  late final int id;
  late final int locationId;
  late final String name;
  late final int amount;
  late final int isTaxGroup;
  late final int forTaxGroup;
  late final int createdBy;
  String? woocommerceTaxRateId;
  String? deletedAt;
  String? createdAt;
  String? updatedAt;
  late final int forTaxInclusive;
  late final int forTaxExclusive;
  late final String isIncOrExc;
  late final String type;
  late final int isPrimary;
  late final String taxType;
  late final List<TaxGroupResponse> taxGroup;

  TaxesResponse.fromJson(Map<String, dynamic> json){
    id = json['id'];
    locationId = json['location_id'];
    name = json['name'];
    amount = json['amount'];
    isTaxGroup = json['is_tax_group'];
    forTaxGroup = json['for_tax_group'];
    createdBy = json['created_by'];
    woocommerceTaxRateId = json['woocommerceTaxRateId'] ?? '';
    deletedAt =  json['deletedAt'] ?? '';
    createdAt =  json['createdAt'] ?? '';
    updatedAt =  json['updatedAt'] ?? '';
    forTaxInclusive = json['for_tax_inclusive'];
    forTaxExclusive = json['for_tax_exclusive'];
    isIncOrExc = json['is_inc_or_exc'];
    type = json['type'];
    isPrimary = json['is_primary'];
    taxType = json['tax_type'];
    taxGroup = List.from(json['tax_group']).map((e)=>TaxGroupResponse.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['location_id'] = locationId;
    data['name'] = name;
    data['amount'] = amount;
    data['is_tax_group'] = isTaxGroup;
    data['for_tax_group'] = forTaxGroup;
    data['created_by'] = createdBy;
    data['woocommerce_tax_rate_id'] = woocommerceTaxRateId;
    data['deleted_at'] = deletedAt;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['for_tax_inclusive'] = forTaxInclusive;
    data['for_tax_exclusive'] = forTaxExclusive;
    data['is_inc_or_exc'] = isIncOrExc;
    data['type'] = type;
    data['is_primary'] = isPrimary;
    data['tax_type'] = taxType;
    data['tax_group'] = taxGroup.map((e)=>e.toJson()).toList();
    return data;
  }
}