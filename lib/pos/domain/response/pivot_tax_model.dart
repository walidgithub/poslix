class PivotTaxResponse {
  PivotTaxResponse({
    required this.parentId,
    required this.taxId,
  });
  late final int parentId;
  late final int taxId;

  PivotTaxResponse.fromJson(Map<String, dynamic> json){
    parentId = json['parent_id'];
    taxId = json['tax_id'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['parent_id'] = parentId;
    _data['tax_id'] = taxId;
    return _data;
  }
}