import 'package:flutter/cupertino.dart';

class HomeResponse {
  final int statusCode;
  final String message;
  final bool success;
  final HomeData? data;

  HomeResponse({
    required this.statusCode,
    required this.message,
    required this.success,
    this.data,
  });

  factory HomeResponse.fromJson(Map<String, dynamic> json) {
    return HomeResponse(
      statusCode: json['statusCode'],
      message: json['message'],
      success: json['success'],
      data: json['data'] != null ? HomeData.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'statusCode': statusCode,
      'message': message,
      'success': success,
      'data': data?.toJson(),
    };
  }
}

class HomeData {
  final TopData? topData;
  final ServiceCategoryDetails? serviceCategoryDetails;
  final bool topPicks;
  final List<Add> adds;
  final List<MainFoodCategory> mainFoodCategories;
  final List<SpotlightBestTopFood> spotLight;
  final List<PopularCategories> popularCategories;
  final List<PopularRestaurant> popularrestaurant;
  final List<TopOffer> topoffer;

  HomeData({
    this.topData,
    this.serviceCategoryDetails,
    required this.topPicks,
    required this.adds,
    required this.mainFoodCategories,
    required this.spotLight,
    required this.popularCategories,
    required this.popularrestaurant,
    required this.topoffer,
  });

  factory HomeData.fromJson(Map<String, dynamic> json) {
    return HomeData(
      topData:
          json['topData'] != null ? TopData.fromJson(json['topData']) : null,
      serviceCategoryDetails: json['serviceCategoryDetails'] != null
          ? ServiceCategoryDetails.fromJson(json['serviceCategoryDetails'])
          : null,
      topPicks: json['topPicks'] ?? false,
      adds: (json['adds'] as List<dynamic>)
          .map((add) => Add.fromJson(add))
          .toList(),
      mainFoodCategories: (json['mainFoodCategories'] as List<dynamic>)
          .map((category) => MainFoodCategory.fromJson(category))
          .toList(),
      spotLight: (json['spotlight'] as List<dynamic>)
          .map((spotlight) => SpotlightBestTopFood.fromJson(spotlight))
          .toList(),
      popularCategories: (json['popularCategories'] as List<dynamic>)
          .map((spotlight) => PopularCategories.fromJson(spotlight))
          .toList(),
      popularrestaurant: (json['popularRestaurants'] as List<dynamic>)
          .map((spotlight) => PopularRestaurant.fromJson(spotlight))
          .toList(),
      topoffer: (json['topOffers'] as List<dynamic>)
          .map((spotlight) => TopOffer.fromJson(spotlight))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'topData': topData?.toJson(),
      'serviceCategoryDetails': serviceCategoryDetails?.toJson(),
      'topPicks': topPicks,
      'adds': adds.map((add) => add.toJson()).toList(),
      'mainFoodCategories':
          mainFoodCategories.map((category) => category.toJson()).toList(),
      'spotlight': spotLight.map((spot) => spot.toJson()).toList(),
      'popularCategories':
          popularCategories.map((popular) => popular.toJson()).toString(),
      'popularRestaurants': popularrestaurant.map((popularResto) => popularResto.toJson()).toString(),
      'topOffers': topoffer.map((topOffer) => topOffer.toJson()).toString(),
    };
  }
}

class ServiceCategoryDetails {
  final String id;
  final String title;
  final String description;
  final String mainImage;

  ServiceCategoryDetails({
    required this.id,
    required this.title,
    required this.description,
    required this.mainImage,
  });

  factory ServiceCategoryDetails.fromJson(Map<String, dynamic> json) {
    return ServiceCategoryDetails(
      id: json['_id'],
      title: json['title'],
      description: json['description'],
      mainImage: json['main_image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'description': description,
      'main_image': mainImage,
    };
  }
}

class TopData {
  final String id;
  final String heading;
  final String description;

  TopData({
    required this.id,
    required this.heading,
    required this.description,
  });

  factory TopData.fromJson(Map<String, dynamic> json) {
    return TopData(
      id: json['_id'] ?? '',
      heading: json['heading'] ?? '',
      description: json['description'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'heading': heading,
      'description': description,
    };
  }
}

class MainFoodCategory {
  final String id;
  final String name;
  final String description;
  final List<String> images;

  MainFoodCategory({
    required this.id,
    required this.name,
    required this.description,
    this.images = const [],
  });

  factory MainFoodCategory.fromJson(Map<String, dynamic> json) {
    return MainFoodCategory(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      images:
          json['images'] != null ? List<String>.from(json['images']) : const [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'description': description,
      'images': images,
    };
  }
}

// add.dart
class Add {
  final String id;
  final String type;
  final List<String> images;
  final String tagline;

  Add({
    required this.id,
    required this.type,
    required this.images,
    required this.tagline,
  });

  factory Add.fromJson(Map<String, dynamic> json) {
    return Add(
      id: json['_id'],
      type: json['type'],
      images: List<String>.from(json['images']),
      tagline: json['tagline'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'type': type,
      'images': images,
      'tagline': tagline,
    };
  }
}

class SpotlightBestTopFood {
  final String name;
  final List<String> images;
  final String description;
  final double averageRating;
  final String? mainOfferName;
  final String? mainOfferTagLine;
  final String? mainOfferDeduction;

  SpotlightBestTopFood({
    required this.name,
    required this.images,
    required this.description,
    required this.averageRating,
    this.mainOfferName,
    this.mainOfferTagLine,
    this.mainOfferDeduction,
  });

  factory SpotlightBestTopFood.fromJson(Map<String, dynamic> json) {
    var images =
        List<String>.from(json['hotelDetails']['images']['hotelMainImage']);
    var mainOffer = json['mainOffer'];

    return SpotlightBestTopFood(
      name: json['hotelDetails']['name'],
      images: images,
      description: json['hotelDetails']['description'],
      averageRating: json['ratings']['averageRating'].toDouble(),
      mainOfferName: mainOffer != null ? mainOffer['name'] : null,
      mainOfferTagLine: mainOffer != null ? mainOffer['tag_line'] : null,
      mainOfferDeduction:
          mainOffer != null ? mainOffer['deductionAmount'] : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'images': images,
      'description': description,
      'averageRating': averageRating,
      'mainOfferName': mainOfferName,
      'mainOfferTagLine': mainOfferTagLine,
      'mainOfferDeduction': mainOfferDeduction,
    };
  }
}

class PopularCategories {
  final String id;
  final String name;

  PopularCategories({
    required this.id,
    required this.name,
  });

  factory PopularCategories.fromJson(Map<String, dynamic> json) {
    return PopularCategories(
      id: json['_id'] ?? '', // Default to empty string if null
      name: json['name'] ?? 'Unknown', // Default to 'Unknown' if null
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
    };
  }
}

class PopularRestaurant {
  final String id;
  final String name;
  final String description;
  final List<String> images;
  final double averageRating;
  final String? mainOfferName;
  final String? mainOfferTagLine;
  final String? mainOfferDeduction;

  PopularRestaurant({
    required this.id,
    required this.name,
    required this.description,
    required this.images,
    required this.averageRating,
    this.mainOfferName,
    this.mainOfferTagLine,
    this.mainOfferDeduction,
  });

  factory PopularRestaurant.fromJson(Map<String, dynamic> json) {
    var images = List<String>.from(json['hotelDetails']['images']['hotelMainImage']);
    var mainOffer = json['mainOffer'];

    return PopularRestaurant(
      id: json['_id'],
      name: json['hotelDetails']['name'],
      description: json['hotelDetails']['description'],
      images: images,
      averageRating: json['ratings']['averageRating'].toDouble(),
      mainOfferName: mainOffer != null ? mainOffer['name'] : null,
      mainOfferTagLine: mainOffer != null ? mainOffer['tag_line'] : null,
      mainOfferDeduction: mainOffer != null ? mainOffer['deductionAmount'] : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'description': description,
      'images': images,
      'averageRating': averageRating,
      'mainOfferName': mainOfferName,
      'mainOfferTagLine': mainOfferTagLine,
      'mainOfferDeduction': mainOfferDeduction,
    };
  }
}

class TopOffer {
  final String id;
  final String name;
  final String tagLine;
  final String deductionAmount;
  final String hotelName;
  final String hotelDescription;
  final List<String> hotelImages;
  final String hotelAddress;
  final String hotelCity;
  final String hotelState;
  final String hotelZipcode;

  TopOffer({
    required this.id,
    required this.name,
    required this.tagLine,
    required this.deductionAmount,
    required this.hotelName,
    required this.hotelDescription,
    required this.hotelImages,
    required this.hotelAddress,
    required this.hotelCity,
    required this.hotelState,
    required this.hotelZipcode,
  });

  factory TopOffer.fromJson(Map<String, dynamic> json) {
    // debugPrint("Parsing TopOffer: $json");
    var hotelDetails = json['ownerId']['hotelDetails'] ?? {};
    var location = hotelDetails['location'] ?? {};
    var images = List<String>.from(hotelDetails['images']['hotelMainImage'] ?? []);

    return TopOffer(
      id: json['_id'] ?? "",
      name: json['name'] ?? "",
      tagLine: json['tag_line'] ?? "",
      deductionAmount: json['deductionAmount'] ?? "",
      hotelName: hotelDetails['name'] ?? "",
      hotelDescription: hotelDetails['description'] ?? "",
      hotelImages: images,
      hotelAddress: location['address'] ?? "",
      hotelCity: location['city'] ?? "",
      hotelState: location['state'] ?? "",
      hotelZipcode: location['zipcode'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'tag_line': tagLine,
      'deductionAmount': deductionAmount,
      'hotelName': hotelName,
      'hotelDescription': hotelDescription,
      'hotelImages': hotelImages,
      'hotelAddress': hotelAddress,
      'hotelCity': hotelCity,
      'hotelState': hotelState,
      'hotelZipcode': hotelZipcode,
    };
  }
}
