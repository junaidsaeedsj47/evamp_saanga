
import 'dart:convert';

ItemData itemDataFromJson(String str) => ItemData.fromJson(json.decode(str));

String itemDataToJson(ItemData data) => json.encode(data.toJson());

class ItemData {
  ItemData({
    this.status,
    this.items,
  });

  String? status;
  List<Item>? items;

  factory ItemData.fromJson(Map<String, dynamic> json) => ItemData(
        status: json["status"],
        items: List<Item>.from(json["items"].map((x) => Item.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "items": List<dynamic>.from(items!.map((x) => x.toJson())),
      };
}

class Item {
  Item({
    this.id,
    this.itemImage,
    this.name,
    this.description,
    this.price,
  });

  String? id;
  String? itemImage;
  String? name;
  String? description;
  double? price;

  factory Item.fromJson(Map<String, dynamic> json) => Item(
        id: json["id"],
        itemImage: json["itemImage"],
        name: json["name"],
        description: json["description"],
        price: json["price"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "itemImage": itemImage,
        "name": name,
        "description": description,
        "price": price,
      };
}
