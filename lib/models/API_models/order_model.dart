class Order {
  final String id;
  final User user;
  final String cartId;
  final String customerId;
  final String restaurantId;
  final Address address;
  final String phone;
  final double totalAmount;
  final String orderDate;
  final String paidThrough;
  final String status;
  final List<Item> items;

  Order({
    required this.id,
    required this.user,
    required this.cartId,
    required this.customerId,
    required this.restaurantId,
    required this.address,
    required this.phone,
    required this.totalAmount,
    required this.orderDate,
    required this.paidThrough,
    required this.status,
    required this.items,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['_id'] ?? '',
      user: User.fromJson(json['user'] ?? {}),
      cartId: json['cartId'] ?? '',
      customerId: json['customerId'] ?? '',
      restaurantId: json['restaurantId'] ?? '',
      address: Address.fromJson(json['address'] ?? {}),
      phone: json['phone'] ?? '',
      totalAmount: (json['totalAmount'] as num?)?.toDouble() ?? 0.0,
      orderDate: json['orderDate'] ?? '',
      paidThrough: json['paidThrough'] ?? '',
      status: json['status'] ?? '',
      items: (json['items'] != null)
          ? List<Item>.from((json['items'] as List).map((x) => Item.fromJson(x)))
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "user": user.toJson(),
      "cartId": cartId,
      "customerId": customerId,
      "restaurantId": restaurantId,
      "address": address.toJson(),
      "phone": phone,
      "totalAmount": totalAmount,
      "orderDate": orderDate,
      "paidThrough": paidThrough,
      "status": status,
      "items": items.map((x) => x.toJson()).toList(),
    };
  }
}

class User {
  final String name;
  final String email;
  final int phone;
  final String userId;

  User({
    required this.name,
    required this.email,
    required this.phone,
    required this.userId,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: (json['phone'] as num?)?.toInt() ?? 0,
      userId: json['userId'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "email": email,
      "phone": phone,
      "userId": userId,
    };
  }
}

class Address {
  final List<double> coordinates;
  final String id;
  final String label;
  final String type;
  final String street;
  final String city;
  final String state;
  final String country;
  final String zipCode;
  final double lat;
  final double lng;
  final String createdAt;
  final String updatedAt;

  Address({
    required this.coordinates,
    required this.id,
    required this.label,
    required this.type,
    required this.street,
    required this.city,
    required this.state,
    required this.country,
    required this.zipCode,
    required this.lat,
    required this.lng,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      coordinates: (json['coordinates'] != null)
          ? List<double>.from((json['coordinates'] as List).map((x) => (x as num).toDouble()))
          : [],
      id: json['_id'] ?? '',
      label: json['label'] ?? '',
      type: json['type'] ?? '',
      street: json['street'] ?? '',
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      country: json['country'] ?? '',
      zipCode: json['zipCode'] ?? '',
      lat: (json['lat'] as num?)?.toDouble() ?? 0.0,
      lng: (json['lng'] as num?)?.toDouble() ?? 0.0,
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "coordinates": coordinates,
      "_id": id,
      "label": label,
      "type": type,
      "street": street,
      "city": city,
      "state": state,
      "country": country,
      "zipCode": zipCode,
      "lat": lat,
      "lng": lng,
      "createdAt": createdAt,
      "updatedAt": updatedAt,
    };
  }
}

class Item {
  final String id;
  final String foodId;
  final int qty;
  final double price;
  final List<FoodDetails> foodDetails;

  Item({
    required this.id,
    required this.foodId,
    required this.qty,
    required this.price,
    required this.foodDetails,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['_id'] ?? '',
      foodId: json['foodId'] ?? '',
      qty: (json['qty'] as num?)?.toInt() ?? 0,
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      foodDetails: (json['foodDetails'] != null)
          ? List<FoodDetails>.from((json['foodDetails'] as List).map((x) => FoodDetails.fromJson(x)))
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "foodId": foodId,
      "qty": qty,
      "price": price,
      "foodDetails": foodDetails.map((x) => x.toJson()).toList(),
    };
  }
}

class FoodDetails {
  final String image;
  final String foodId;
  final String name;
  final String description;
  final String category;

  FoodDetails({
    required this.image,
    required this.foodId,
    required this.name,
    required this.description,
    required this.category,
  });

  factory FoodDetails.fromJson(Map<String, dynamic> json) {
    return FoodDetails(
      image: json['image'] ?? '',
      foodId: json['foodId'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      category: json['category'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "image": image,
      "foodId": foodId,
      "name": name,
      "description": description,
      "category": category,
    };
  }
}
