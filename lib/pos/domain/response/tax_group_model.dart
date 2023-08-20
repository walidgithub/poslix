import 'package:poslix_app/pos/domain/response/pivot_tax_model.dart';

class TaxGroupResponse {
  TaxGroupResponse({
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
    required this.pivot,
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
  late final PivotTaxResponse pivot;

  TaxGroupResponse.fromJson(Map<String, dynamic> json){
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
    pivot = PivotTaxResponse.fromJson(json['pivot']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['location_id'] = locationId;
    _data['name'] = name;
    _data['amount'] = amount;
    _data['is_tax_group'] = isTaxGroup;
    _data['for_tax_group'] = forTaxGroup;
    _data['created_by'] = createdBy;
    _data['woocommerce_tax_rate_id'] = woocommerceTaxRateId;
    _data['deleted_at'] = deletedAt;
    _data['created_at'] = createdAt;
    _data['updated_at'] = updatedAt;
    _data['for_tax_inclusive'] = forTaxInclusive;
    _data['for_tax_exclusive'] = forTaxExclusive;
    _data['is_inc_or_exc'] = isIncOrExc;
    _data['type'] = type;
    _data['is_primary'] = isPrimary;
    _data['tax_type'] = taxType;
    _data['pivot'] = pivot.toJson();
    return _data;
  }
}