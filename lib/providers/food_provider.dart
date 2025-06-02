import 'dart:convert';
import 'package:flutter/material.dart';
import '../Utils/Network_Utils.dart';
import '../models/API_models/food_model.dart';

class FoodProvider with ChangeNotifier {
  FoodDetailsModel? _foodDetails; // Store a single foodDetails object
  FoodDetailsModel? get foodDetails => _foodDetails;

  /// Fetches food details from the API
  Future<void> fetchFoodDetails(String foodId) async {
    try {
      final response = await NetworkUtil.get("${NetworkUtil.FOOD_DETAILS_URL}/$foodId");

      debugPrint("Response Headers: ${response.headers}");
      debugPrint("Food details status: ${response.statusCode}");
      debugPrint("Food details body: ${response.body}");

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final Map<String, dynamic> foodData = responseData['data']['foodDetails']; // It's a single object

        _foodDetails = FoodDetailsModel.fromJson(foodData); // Parse the single object

        notifyListeners();
      } else {
        debugPrint('Failed to load food details');
      }
    } catch (error) {
      debugPrint('Error fetching food details: $error');
    }
  }
}
