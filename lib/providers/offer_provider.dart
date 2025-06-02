import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:swiggy_app/utils/Network_Utils.dart';
import 'package:swiggy_app/models/API_models/offer_model.dart';

class OfferProvider with ChangeNotifier {

  List<Offer> _offers = [];
  List<Offer> get offers => _offers;

  Future<void> fetchOffers() async {
    try {
      final response = await NetworkUtil.get(NetworkUtil.OFFERS_URL);

      debugPrint("Status Code: ${response.statusCode}");
      debugPrint("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        // Parse JSON response into OfferResponse model
        final responseData = jsonDecode(response.body);
        final offerResponse = OfferResponse.fromJson(responseData);

        // Update the offers list
        if (offerResponse.data != null) {
          _offers = offerResponse.data!.offers;
          notifyListeners();
        } else {
          print("No offer data found");
        }
      } else {
        // Handle non-200 status codes
        print("Failed to load offers: ${response.statusCode}");
      }
    } catch (error) {
      // Handle exceptions
      print("Error fetching offers: $error");
    }
  }
}
