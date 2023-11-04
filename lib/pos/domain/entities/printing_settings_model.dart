class PrintSettingModel {
  int? id;
  String? printerName;
  String? connectionMethod;
  String? printerIP;
  String? printType;
  int? printerStatus;

  PrintSettingModel(
      {this.id,
        this.printerName,
        this.connectionMethod,
        this.printerIP,this.printType,this.printerStatus});

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["id"] = id;
    data["printer_name"] = printerName;
    data["connection_method"] = connectionMethod;
    data["printer_ip"] = printerIP;
    data["print_type"] = printType;
    data["printer_status"] = printerStatus;
    return data;
  }

  PrintSettingModel.fromMap(Map<String, dynamic> map) {
    id = map["id"];
    printerName = map['printer_name'];
    connectionMethod = map['connection_method'];
    printerIP = map['printer_ip'];
    printType = map['print_type'];
    printerStatus = map['printer_status'];
  }
}