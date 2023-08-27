class FabricsModel {
  String? id;
  String? itemImage;
  String? itemName;

  FabricsModel(
      {this.id,
        this.itemImage,this.itemName,});

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["id"] = id;
    data["itemImage"] = itemImage;
    data["itemName"] = itemName;
    return data;
  }

  FabricsModel.fromMap(Map<String, dynamic> map) {
    id = map["id"];
    itemImage = map["itemImage"];
    itemName = map["itemName"];
  }
}