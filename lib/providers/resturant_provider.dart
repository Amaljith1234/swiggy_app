import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';

import '../models/API_models/restaurant_model.dart';
import '../utils/Network_Utils.dart';

class RestaurantProvider with ChangeNotifier {

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<RestaurantModel> _restaurantItems = [];
  List<HighlightedRestaurantModel> _highlightedRestaurantItems = [];

  List<RestaurantModel> get restaurantItems => _restaurantItems;
  List<HighlightedRestaurantModel> get highlightedRestaurantItems => _highlightedRestaurantItems;

  Future<void> fetchRestaurants() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await NetworkUtil.get(NetworkUtil.RESTAURANTS_URL);

      debugPrint(response.statusCode.toString());
      debugPrint(response.body);

      if (response.statusCode == 200) {
        final result = json.decode(response.body);

        if (result['data'] != null) {
          final data = result['data'];

          debugPrint("data found");
          if (data['highlightedRestaurants'] != null) {
            _highlightedRestaurantItems = (data['highlightedRestaurants'] as List)
                .map((restaurant) => HighlightedRestaurantModel.fromJson(restaurant))
                .toList();
          }

          debugPrint("data found");
          if (data['restaurantList'] != null) {
            _restaurantItems = (data['restaurantList'] as List)
                .map((restaurant) => RestaurantModel.fromJson(restaurant))
                .toList();
          }

          notifyListeners();
          log("Fetched ${_restaurantItems.length} restaurants");
        } else {
          log("API response error: ${result['message']}");
        }
      } else {
        log("Failed to fetch restaurants: Status Code ${response.statusCode}");
      }
    } catch (e) {
      log("Error fetching restaurants: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

}
