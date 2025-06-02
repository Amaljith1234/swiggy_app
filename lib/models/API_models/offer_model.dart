class OfferResponse {
  final int statusCode;
  final String message;
  final bool success;
  final OfferData? data;

  OfferResponse({
    required this.statusCode,
    required this.message,
    required this.success,
    this.data,
  });

  factory OfferResponse.fromJson(Map<String, dynamic> json) {
    return OfferResponse(
      statusCode: json['statusCode'],
      message: json['message'],
      success: json['success'],
      data: json['data'] != null ? OfferData.fromJson(json['data']) : null,
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


class OfferData {
  final List<Offer> offers;

  OfferData({
    required this.offers,
  });

  factory OfferData.fromJson(Map<String, dynamic> json) {
    return OfferData(
      offers: (json['result'] as List<dynamic>)
          .map((offer) => Offer.fromJson(offer))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'result': offers.map((offer) => offer.toJson()).toList(),
    };
  }
}

class Offer {
  final bool mainOffer;
  final String id;
  final String deductionAmount;
  final String name;
  final Owner ownerId;
  final String tagLine;

  Offer({
    required this.mainOffer,
    required this.id,
    required this.deductionAmount,
    required this.name,
    required this.ownerId,
    required this.tagLine,
  });

  factory Offer.fromJson(Map<String, dynamic> json) {
    return Offer(
      mainOffer: json['mainOffer'],
      id: json['_id'],
      deductionAmount: json['deductionAmount'],
      name: json['name'],
      ownerId: Owner.fromJson(json['ownerId']),
      tagLine: json['tag_line'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'mainOffer': mainOffer,
      '_id': id,
      'deductionAmount': deductionAmount,
      'name': name,
      'ownerId': ownerId.toJson(),
      'tag_line': tagLine,
    };
  }
}

class Owner {
  final String id;
  final String name;
  final HotelDetails hotelDetails;

  Owner({
    required this.id,
    required this.name,
    required this.hotelDetails,
  });

  factory Owner.fromJson(Map<String, dynamic> json) {
    return Owner(
      id: json['_id'],
      name: json['name'],
      hotelDetails: HotelDetails.fromJson(json['hotelDetails']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'hotelDetails': hotelDetails.toJson(),
    };
  }
}

class HotelDetails {
  final List<String> hotelMainImage;
  final String name;
  final String description;

  HotelDetails({
    required this.hotelMainImage,
    required this.name,
    required this.description,
  });

  factory HotelDetails.fromJson(Map<String, dynamic> json) {
    return HotelDetails(
      hotelMainImage:
      List<String>.from(json['images']['hotelMainImage'] as List<dynamic>),
      name: json['name'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'images': {
        'hotelMainImage': hotelMainImage,
      },
      'name': name,
      'description': description,
    };
  }
}
