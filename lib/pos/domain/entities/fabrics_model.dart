class FabricsModel {
  int? id;
  String? itemImage;
  String? itemName;
  String? itemPrice;
  bool? selected;

  FabricsModel(
      {this.id,
        this.itemImage,this.itemName,this.itemPrice,this.selected,});

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["id"] = id;
    data["itemImage"] = itemImage;
    data["itemName"] = itemName;
    data["itemPrice"] = itemPrice;
    data["selected"] = selected;
    return data;
  }

  FabricsModel.fromMap(Map<String, dynamic> map) {
    id = map["id"];
    itemImage = map["itemImage"];
    itemName = map["itemName"];
    itemPrice = map["itemPrice"];
    selected = map["selected"];
  }
}