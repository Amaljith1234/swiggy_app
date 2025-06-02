class AddressModel {
  final String id;
  final String type;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String city;
  final String country;
  final String label;
  final double lat;
  final double lng;
  final String state;
  final String street;
  final String zipCode;
  final List<double> coordinates;
  final bool primaryAddress;

  AddressModel({
    required this.id,
    required this.type,
    required this.createdAt,
    required this.updatedAt,
    required this.city,
    required this.country,
    required this.label,
    required this.lat,
    required this.lng,
    required this.state,
    required this.street,
    required this.zipCode,
    required this.coordinates,
    required this.primaryAddress,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    final coordinates = json['coordinates'] ?? [0.0, 0.0];
    return AddressModel(
      id: json['_id'] ?? '',
      type: json['type'] ?? '',
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.now(),
      city: json['city'] ?? '',
      country: json['country'] ?? '',
      label: json['label'] ?? 'No Label',
      lat: coordinates.isNotEmpty ? (coordinates[1] as num).toDouble() : 0.0,
      lng: coordinates.isNotEmpty ? (coordinates[0] as num).toDouble() : 0.0,
      state: json['state'] ?? '',
      street: json['street'] ?? '',
      zipCode: json['zipCode'] ?? '',
      coordinates: List<double>.from(coordinates.map((x) => (x as num).toDouble())),
      primaryAddress: json['primaryAddress'] ?? false,
    );
  }


  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'type': type,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'city': city,
      'country': country,
      'label': label,
      'lat': lat,
      'lng': lng,
      'state': state,
      'street': street,
      'zipCode': zipCode,
      'coordinates': coordinates,
      'primaryAddress': primaryAddress,
    };
  }
}
