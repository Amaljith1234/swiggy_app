class FavoriteRestaurant {
  final HotelDetails? hotelDetails;
  final Ratings? ratings;
  final DeliveryPartnerDetails? deliveryPartnerDetails;
  final CustomerDetails? customerDetails;
  final String status;
  final List<String> cart;
  final List<String> orders;
  final String role;
  final String id;
  final List<dynamic> order;
  final String name;
  final String email;
  final String password;
  final int version;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  FavoriteRestaurant({
    required this.hotelDetails,
    required this.ratings,
    required this.deliveryPartnerDetails,
    required this.customerDetails,
    required this.status,
    required this.cart,
    required this.orders,
    required this.role,
    required this.id,
    required this.order,
    required this.name,
    required this.email,
    required this.password,
    required this.version,
    required this.createdAt,
    required this.updatedAt,
  });

  factory FavoriteRestaurant.fromJson(Map<String, dynamic> json) {
    return FavoriteRestaurant(
      hotelDetails: json['hotelDetails'] != null
          ? HotelDetails.fromJson(json['hotelDetails'])
          : null,
      ratings: json['ratings'] != null
          ? Ratings.fromJson(json['ratings'])
          : null,
      deliveryPartnerDetails: json['deliveryPartnerDetails'] != null
          ? DeliveryPartnerDetails.fromJson(json['deliveryPartnerDetails'])
          : null,
      customerDetails: json['customerDetails'] != null
          ? CustomerDetails.fromJson(json['customerDetails'])
          : null,
      status: json['status'] ?? '',
      cart: (json['cart'] as List?)?.map((e) => e.toString()).toList() ?? [],
      orders: (json['orders'] as List?)?.map((e) => e.toString()).toList() ?? [],
      role: json['role'] ?? '',
      id: json['_id'] ?? '',
      order: json['order'] ?? [],
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      password: json['password'] ?? '',
      version: json['__v'] ?? 0,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'])
          : null,
    );
  }
}

class HotelDetails {
  final Location? location;
  final OpeningHours? openingHours;
  final Images? images;
  final bool partnerBrand;
  final int priorityIndex;
  final String name;
  final String description;
  final String contactNumber;

  HotelDetails({
    required this.location,
    required this.openingHours,
    required this.images,
    required this.partnerBrand,
    required this.priorityIndex,
    required this.name,
    required this.description,
    required this.contactNumber,
  });

  factory HotelDetails.fromJson(Map<String, dynamic> json) {
    return HotelDetails(
      location: json['location'] != null
          ? Location.fromJson(json['location'])
          : null,
      openingHours: json['openingHours'] != null
          ? OpeningHours.fromJson(json['openingHours'])
          : null,
      images: json['images'] != null
          ? Images.fromJson(json['images'])
          : null,
      partnerBrand: json['partnerBrand'] ?? false,
      priorityIndex: json['priorityIndex'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      contactNumber: json['contactNumber'] ?? '',
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
      address: json['address'] ?? '',
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      zipcode: json['zipcode'] ?? '',
      type: json['type'] ?? '',
      coordinates: (json['coordinates'] as List?)
          ?.map((e) => e is num ? e.toDouble() : 0.0)
          .toList() ?? [],
    );
  }
}

class OpeningHours {
  final String open;
  final String close;

  OpeningHours({
    required this.open,
    required this.close,
  });

  factory OpeningHours.fromJson(Map<String, dynamic> json) {
    return OpeningHours(
      open: json['open'] ?? '',
      close: json['close'] ?? '',
    );
  }
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
      hotelImages: (json['hotelImages'] as List?)
          ?.map((e) => e.toString())
          .toList() ?? [],
      menuImages: (json['menuImages'] as List?)
          ?.map((e) => e.toString())
          .toList() ?? [],
      hotelMainImage: (json['hotelMainImage'] as List?)
          ?.map((e) => e.toString())
          .toList() ?? [],
    );
  }
}

class Ratings {
  final double averageRating;
  final double totalRatings;

  Ratings({
    required this.averageRating,
    required this.totalRatings,
  });

  factory Ratings.fromJson(Map<String, dynamic> json) {
    return Ratings(
      averageRating: (json['averageRating'] ?? 0.0).toDouble(),
      totalRatings: (json['totalRatings'] ?? 0.0).toDouble(),
    );
  }
}

class DeliveryPartnerDetails {
  final String vehicleType;
  final String status;
  final int totalDeliveries;
  final int earnings;

  DeliveryPartnerDetails({
    required this.vehicleType,
    required this.status,
    required this.totalDeliveries,
    required this.earnings,
  });

  factory DeliveryPartnerDetails.fromJson(Map<String, dynamic> json) {
    return DeliveryPartnerDetails(
      vehicleType: json['vehicleType'] ?? '',
      status: json['status'] ?? '',
      totalDeliveries: json['totalDeliveries'] ?? 0,
      earnings: json['earnings'] ?? 0,
    );
  }
}

class CustomerDetails {
  final CurrentLocation? currentLocation;
  final List<dynamic> favoriteRestaurants;
  final List<dynamic> savedAddresses;
  final List<dynamic> orders;

  CustomerDetails({
    required this.currentLocation,
    required this.favoriteRestaurants,
    required this.savedAddresses,
    required this.orders,
  });

  factory CustomerDetails.fromJson(Map<String, dynamic> json) {
    return CustomerDetails(
      currentLocation: json['currentLocation'] != null
          ? CurrentLocation.fromJson(json['currentLocation'])
          : null,
      favoriteRestaurants: json['favoriteRestaurants'] ?? [],
      savedAddresses: json['savedAddresses'] ?? [],
      orders: json['orders'] ?? [],
    );
  }
}

class CurrentLocation {
  final List<dynamic> coordinates;

  CurrentLocation({required this.coordinates});

  factory CurrentLocation.fromJson(Map<String, dynamic> json) {
    return CurrentLocation(
      coordinates: (json['coordinates'] as List?) ?? [],
    );
  }
}
