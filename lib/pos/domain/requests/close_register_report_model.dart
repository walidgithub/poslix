class CloseRegisterReportRequest {
  CloseRegisterReportRequest({
    required this.today,
  });
  late final bool today;

  CloseRegisterReportRequest.fromJson(Map<String, dynamic> json){
    today = json['today'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['today'] = today;
    return data;
  }
}