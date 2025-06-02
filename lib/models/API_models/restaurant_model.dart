import 'package:flutter/cupertino.dart';

class HighlightedRestaurantModel extends ChangeNotifier {
  String id;
  String image;
  String name;
  String description;

  HighlightedRestaurantModel({
    required this.id,
    required this.image,
    required this.name,
    required this.description,
  });

  factory HighlightedRestaurantModel.fromJson(Map<String, dynamic> json) {
    return HighlightedRestaurantModel(
      id: json['_id'] ?? '',
      image: json['image'] ?? '',
      name: json['name'] ?? 'Unknown',
      description: json['description'] ?? 'No description available',
    );
  }
}

class RestaurantModel extends ChangeNotifier {
  String id;
  String image;
  String name;
  String description;
  double ratings;
  int orderCount;

  RestaurantModel({
    required this.id,
    required this.image,
    required this.name,
    required this.description,
    required this.ratings,
    required this.orderCount,
  });

  factory RestaurantModel.fromJson(Map<String, dynamic> json) {
    return RestaurantModel(
      id: json['_id'] ?? '',
      image: json['image'] ?? '',
      name: json['name'] ?? 'Unknown',
      description: json['description'] ?? 'No description available',
      ratings: (json['ratings'] as num?)?.toDouble() ?? 0.0,
      orderCount: json['orderCount'] ?? 0,
    );
  }
}

class RestaurantList {
  List<RestaurantModel> restaurants;
  List<HighlightedRestaurantModel> highlightedRestaurants;

  RestaurantList({required this.restaurants, required this.highlightedRestaurants});

  factory RestaurantList.fromJson(Map<String, dynamic> json) {
    return RestaurantList(
      restaurants: (json['restaurantList'] as List?)
          ?.map((item) => RestaurantModel.fromJson(item))
          .toList() ??
          [],
      highlightedRestaurants: (json['highlightedRestaurants'] as List?)
          ?.map((item) => HighlightedRestaurantModel.fromJson(item))
          .toList() ??
          [],
    );
  }
}

// Restaurant detailed model
class Restaurant {
  final String userId;
  final String restaurantName;
  final String description;
  final Location location;
  final String contactNumber;
  final OpeningHours openingHours;
  final Images images;
  final double ratings;
  final String email;
  final List<FoodItem> foodItems;
  final Pagination pagination;

  Restaurant({
    required this.userId,
    required this.restaurantName,
    required this.description,
    required this.location,
    required this.contactNumber,
    required this.openingHours,
    required this.images,
    required this.ratings,
    required this.email,
    required this.foodItems,
    required this.pagination,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
      userId: json['userId'] ?? '',
      restaurantName: json['restaurantName'] ?? 'Unknown Restaurant',
      description: json['description'] ?? 'No description available',
      location: json['location'] != null ? Location.fromJson(json['location']) : Location.empty(),
      contactNumber: json['contactNumber'] ?? 'N/A',
      openingHours: json['openingHours'] != null ? OpeningHours.fromJson(json['openingHours']) : OpeningHours.empty(),
      images: json['images'] != null ? Images.fromJson(json['images']) : Images.empty(),
      ratings: (json['ratings'] as num?)?.toDouble() ?? 0.0,
      email: json['email'] ?? 'No email provided',
      foodItems: (json['foodItems'] as List?)
          ?.map((item) => FoodItem.fromJson(item))
          .toList() ??
          [],
      pagination: json['pagination'] != null ? Pagination.fromJson(json['pagination']) : Pagination.empty(),
    );
  }
}

class Location {
  final String address;
  final String city;
  final String state;
  final String zipcode;
  final String type;
  final List<double> coordinates;

  Location({
    required this.address,
    required this.city,
    required this.state,
    required this.zipcode,
    required this.type,
    required this.coordinates,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      address: json['address'] ?? 'Unknown Address',
      city: json['city'] ?? 'Unknown City',
      state: json['state'] ?? 'Unknown State',
      zipcode: json['zipcode'] ?? '000000',
      type: json['type'] ?? 'Point',
      coordinates: (json['coordinates'] as List?)
          ?.map((coord) => (coord as num).toDouble())
          .toList() ??
          [],
    );
  }

  factory Location.empty() => Location(
    address: '',
    city: '',
    state: '',
    zipcode: '',
    type: 'Point',
    coordinates: [],
  );
}

class OpeningHours {
  final String open;
  final String close;

  OpeningHours({required this.open, required this.close});

  factory OpeningHours.fromJson(Map<String, dynamic> json) {
    return OpeningHours(
      open: json['open'] ?? '00:00',
      close: json['close'] ?? '00:00',
    );
  }

  factory OpeningHours.empty() => OpeningHours(open: '00:00', close: '00:00');
}

class Images {
  final List<String> hotelImages;
  final List<String> menuImages;
  final List<String> hotelMainImage;

  Images({
    required this.hotelImages,
    required this.menuImages,
    required this.hotelMainImage,
  });

  factory Images.fromJson(Map<String, dynamic> json) {
    return Images(
      hotelImages: List<String>.from(json['hotelImages'] ?? []),
      menuImages: List<String>.from(json['menuImages'] ?? []),
      hotelMainImage: List<String>.from(json['hotelMainImage'] ?? []),
    );
  }

  factory Images.empty() => Images(hotelImages: [], menuImages: [], hotelMainImage: []);
}

class FoodItem {
  final String image;
  final String foodId;
  final String name;
  final String description;
  final String category;
  final double price;

  FoodItem({
    required this.image,
    required this.foodId,
    required this.name,
    required this.description,
    required this.category,
    required this.price,
  });

  factory FoodItem.fromJson(Map<String, dynamic> json) {
    return FoodItem(
      image: json['image'] ?? '',
      foodId: json['foodId'] ?? '',
      name: json['name'] ?? 'Unknown Food',
      description: json['description'] ?? 'No description available',
      category: json['category'] ?? 'Unknown Category',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

class Pagination {
  final int currentPage;
  final int limit;
  final int totalItems;
  final int totalPages;

  Pagination({
    required this.currentPage,
    required this.limit,
    required this.totalItems,
    required this.totalPages,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      currentPage: json['currentPage'] ?? 1,
      limit: json['limit'] ?? 10,
      totalItems: json['totalItems'] ?? 0,
      totalPages: json['totalPages'] ?? 1,
    );
  }

  factory Pagination.empty() => Pagination(currentPage: 1, limit: 10, totalItems: 0, totalPages: 1);
}
