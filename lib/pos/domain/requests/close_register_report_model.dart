class CloseRegisterReportRequest {
  CloseRegisterReportRequest({
    required this.today,
  });
  late final bool today;

  CloseRegisterReportRequest.fromJson(Map<String, dynamic> json){
    today = json['today'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['today'] = today;
    return _data;
  }
}