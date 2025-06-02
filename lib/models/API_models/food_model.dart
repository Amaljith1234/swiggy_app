class FoodDetailsModel {
  final String? id;
  final String? image;
  final String? name;
  final String? description;
  final String? category;
  final double? price;
  final CartEntry? cartEntry;

  FoodDetailsModel({
    this.id,
    this.image,
    this.name,
    this.description,
    this.category,
    this.price,
    this.cartEntry,
  });

  factory FoodDetailsModel.fromJson(Map<String, dynamic> json) {
    return FoodDetailsModel(
      id: json["_id"],
      image: json["image"],
      name: json["name"],
      description: json["description"],
      category: json["category"],
      price: (json["price"] as num?)?.toDouble(),
      cartEntry:
      json["cartEntry"] != null ? CartEntry.fromJson(json["cartEntry"]) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "image": image,
      "name": name,
      "description": description,
      "category": category,
      "price": price,
      "cartEntry": cartEntry?.toJson(),
    };
  }
}

class CartEntry {
  final String? id;
  final String? foodId;
  final int? qty;
  final double? price;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  CartEntry({
    this.id,
    this.foodId,
    this.qty,
    this.price,
    this.createdAt,
    this.updatedAt,
  });

  factory CartEntry.fromJson(Map<String, dynamic> json) {
    return CartEntry(
      id: json["_id"],
      foodId: json["foodId"],
      qty: json["qty"],
      price: (json["price"] as num?)?.toDouble(),
      createdAt: json["createdAt"] != null ? DateTime.parse(json["createdAt"]) : null,
      updatedAt: json["updatedAt"] != null ? DateTime.parse(json["updatedAt"]) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "foodId": foodId,
      "qty": qty,
      "price": price,
      "createdAt": createdAt?.toIso8601String(),
      "updatedAt": updatedAt?.toIso8601String(),
    };
  }
}
