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
    final data = <String, dynamic>{};
    data['parent_id'] = parentId;
    data['tax_id'] = taxId;
    return data;
  }
}