class SearchFoodItem {
  final String id;
  final String foodId;
  final String restaurantId;
  final String restaurantName;
  final String foodItemName;
  final String foodDescription;
  final double price;
  final List<String> images;

  SearchFoodItem({
    required this.id,
    required this.foodId,
    required this.restaurantId,
    required this.restaurantName,
    required this.foodItemName,
    required this.foodDescription,
    required this.price,
    required this.images,
  });

  // Factory method to create a FoodItem from JSON data
  factory SearchFoodItem.fromJson(Map<String, dynamic> json) {
    return SearchFoodItem(
      id: json['_id'] ?? '',
      foodId: json['foodId'] ?? '',
      restaurantId: json['restaurantId'] ?? '',
      restaurantName: json['restaurantName'] ?? 'Unknown Restaurant',
      foodItemName: json['foodItemName'] ?? 'Unknown Food',
      foodDescription: json['foodDescription'] ?? 'No description available',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      images: (json['images'] is List)
          ? List<String>.from(json['images'].whereType<String>())
          : [], // Ensures images is always a valid list
    );
  }
}

class Hotel {
  final String id;
  final String restaurantName;
  final String restaurantDescription;
  final Location? location;
  final List<String> images;

  Hotel({
    required this.id,
    required this.restaurantName,
    required this.restaurantDescription,
    required this.location,
    required this.images,
  });

  factory Hotel.fromJson(Map<String, dynamic> json) {
    return Hotel(
      id: json['_id'] ?? '',
      restaurantName: json['restaurantName'] ?? 'Unknown Restaurant',
      restaurantDescription: json['restaurantDescription'] ?? 'No description available',
      location: json['location'] != null ? Location.fromJson(json['location']) : null,
      images: List<String>.from(json['images'] ?? []),
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
      coordinates: (json['coordinates'] as List?)?.map((coord) => (coord as num).toDouble()).toList() ?? [],
    );
  }
}
