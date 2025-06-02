class CustomerDetails {
  final String name;
  final int phone;
  final String email;
  final BankDetails bankDetails;
  final List<Address> address;
  final List<dynamic> orders;

  CustomerDetails({
    required this.name,
    required this.phone,
    required this.email,
    required this.bankDetails,
    required this.address,
    required this.orders,
  });

  factory CustomerDetails.fromJson(Map<String, dynamic> json) {
    return CustomerDetails(
      name: json['name'] ?? '',
      phone: json['phone'] ?? 0,
      email: json['email'] ?? '',
      bankDetails: BankDetails.fromJson(json['bankDetails'] ?? {}),
      address: (json['address'] as List?)
          ?.map((e) => Address.fromJson(e))
          .toList() ??
          [],
      orders: json['orders'] ?? [],
    );
  }
}

class BankDetails {
  final String accountName;
  final String accountNumber;
  final String bankName;
  final String ifscCode;

  BankDetails({
    required this.accountName,
    required this.accountNumber,
    required this.bankName,
    required this.ifscCode,
  });

  factory BankDetails.fromJson(Map<String, dynamic> json) {
    return BankDetails(
      accountName: json['accountName'] ?? '',
      accountNumber: json['accountNumber'] ?? '',
      bankName: json['bankName'] ?? '',
      ifscCode: json['ifscCode'] ?? '',
    );
  }
}

class Address {
  final String id;
  final String label;
  final String type;
  final String street;
  final String city;
  final String state;
  final String country;
  final String zipCode;
  final double lng;
  final double lat;
  final List<double> coordinates;
  final String createdAt;
  final String updatedAt;

  Address({
    required this.id,
    required this.label,
    required this.type,
    required this.street,
    required this.city,
    required this.state,
    required this.country,
    required this.zipCode,
    required this.lng,
    required this.lat,
    required this.coordinates,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      id: json['_id'] ?? '',
      label: json['label'] ?? '',
      type: json['type'] ?? '',
      street: json['street'] ?? '',
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      country: json['country'] ?? '',
      zipCode: json['zipCode'] ?? '',
      lng: (json['lng'] ?? 0).toDouble(),
      lat: (json['lat'] ?? 0).toDouble(),
      coordinates: (json['coordinates'] as List?)
          ?.map((e) => (e as num).toDouble())
          .toList() ??
          [],
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
    );
  }
}

