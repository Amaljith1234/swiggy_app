import 'package:flutter/material.dart';

class CartItem {
  final String? id;
  final String? customerId;
  final String? restaurantId;
  final double? totalPrice;
  final double? deliveryFee;
  final double? tax;
  final DateTime? createdAt;
  final RestaurantDetails? restaurantDetails;
  final List<FoodItem>? foodItems;

  CartItem({
    required this.id,
    required this.customerId,
    required this.restaurantId,
    required this.totalPrice,
    required this.deliveryFee,
    required this.tax,
    required this.createdAt,
    required this.restaurantDetails,
    required this.foodItems,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    debugPrint(json.toString());
    return CartItem(
      id: json['_id'] ?? "",
      customerId: json['customerId'] ?? "",
      restaurantId: json['restaurantId'] ?? "",
      totalPrice: (json['totalPrice'] ?? 0).toDouble(),
      deliveryFee: (json['deliveryFee'] ?? 0).toDouble(),
      tax: (json['tax'] ?? 0).toDouble(),
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      restaurantDetails: json['restaurantDetails'] != null
          ? RestaurantDetails.fromJson(json['restaurantDetails'])
          : null,
      foodItems: json['foodItems'] != null
          ? List<FoodItem>.from(
          json['foodItems'].map((item) => FoodItem.fromJson(item)))
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'userId': customerId,
      'restaurantId': restaurantId,
      'totalPrice': totalPrice,
      'deliveryFee': deliveryFee,
      'tax': tax,
      'createdAt': createdAt?.toIso8601String(),
      'restaurantDetails': restaurantDetails?.toJson(),
      'foodItems': foodItems?.map((item) => item.toJson()).toList(),
    };
  }
}

class RestaurantDetails {
  final String? name;

  RestaurantDetails({required this.name});

  factory RestaurantDetails.fromJson(Map<String, dynamic> json) {
    return RestaurantDetails(
      name: json['name'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
    };
  }
}

class FoodItem {
  final String? id;
  final String? foodId;
  late final int? qty;
  final double? price;
  final FoodDetails? foodDetails;

  FoodItem({
    required this.id,
    required this.foodId,
    required this.qty,
    required this.price,
    required this.foodDetails,
  });

  factory FoodItem.fromJson(Map<String, dynamic> json) {
    return FoodItem(
      id: json['_id'] ?? "",
      foodId: json['foodId'] ?? "",
      qty: json['qty'] ?? 0,
      price: (json['price'] ?? 0).toDouble(),
      foodDetails: json['foodDetails'] != null
          ? FoodDetails.fromJson(json['foodDetails'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'foodId': foodId,
      'qty': qty,
      'price': price,
      'foodDetails': foodDetails?.toJson(),
    };
  }
}

class FoodDetails {
  final String? image;
  final String? name;
  final String? description;
  final String? category;

  FoodDetails({
    required this.image,
    required this.name,
    required this.description,
    required this.category,
  });

  factory FoodDetails.fromJson(Map<String, dynamic> json) {
    return FoodDetails(
      image: json['image'] ?? "",
      name: json['name'] ?? "",
      description: json['description'] ?? "",
      category: json['category'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'image': image,
      'name': name,
      'description': description,
      'category': category,
    };
  }
}

class CartData {
  final List<CartItem> cartItems;

  CartData({required this.cartItems});

  factory CartData.fromJson(Map<String, dynamic> json) {
    return CartData(
      cartItems: List<CartItem>.from(
        json['cartItems'].map((item) => CartItem.fromJson(item)),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cartItems': cartItems.map((item) => item.toJson()).toList(),
    };
  }
}
