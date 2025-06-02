import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import '../utils/AppUtils.dart';
import '../utils/Network_Utils.dart';
import '../models/API_models/home_model.dart';

class HomeDetailsProvider with ChangeNotifier {
  // Initialize lists to empty to avoid null values.
  List<TopData> _topDataList = [];
  List<MainFoodCategory> _mainFoodCategories = [];
  List<Add> _addsList = [];
  List<SpotlightBestTopFood> _spotLightList = [];
  List<PopularCategories> _popularCategory = [];
  List<PopularRestaurant> _popularRestaurant = [];
  List<TopOffer> _topOffers = [];

  List<TopData> get topDataList => _topDataList;
  List<MainFoodCategory> get mainFoodCategories => _mainFoodCategories;
  List<Add> get addsList => _addsList;
  List<SpotlightBestTopFood> get spotLightList => _spotLightList;
  List<PopularCategories> get popularCategory => _popularCategory;
  List<PopularRestaurant> get popularRestaurant => _popularRestaurant;
  List<TopOffer> get topOffers => _topOffers;

  // Fetch Home Details from the API
  Future<void> fetchHomeDetails() async {
    try {
      final token = await AppUtil.getToken();
      debugPrint("Fetched token: $token");

      final response = await NetworkUtil.get(NetworkUtil.HOME_PAGE_URL);

      debugPrint("Status Code: ${response.statusCode}");
      debugPrint("Body: ${response.body}");

      if (response.statusCode == 200) {
        final result = json.decode(response.body);

        if (result['statusCode'] == 200) {
          final homeData = result['data'];

          // Parse Top Data (check if it's a Map, and wrap it in a List if needed)
          if (homeData['topData'] != null) {
            if (homeData['topData'] is List) {
              _topDataList = (homeData['topData'] as List)
                  .map((json) => TopData.fromJson(json))
                  .toList();
            } else {
              // If it's not a list, handle it as a single object
              _topDataList = [TopData.fromJson(homeData['topData'])];
            }
          }

          // Parse Main Food Categories (Check for List)
          if (homeData['mainFoodCategories'] != null) {
            _mainFoodCategories = (homeData['mainFoodCategories'] as List)
                .map((json) => MainFoodCategory.fromJson(json))
                .toList();
          }

          if (homeData['spotlight'] != null) {
            _spotLightList = (homeData['spotlight'] as List)
                .map((json) => SpotlightBestTopFood.fromJson(json))
                .toList();
          }

          // debugPrint(homeData['popularCategories']?.toString() ?? "Popular categories data is null");
          // Parse Popular Categories (Check for List)
          if (homeData['popularCategories'] != null &&
              homeData['popularCategories'] is List) {
            _popularCategory = (homeData['popularCategories'] as List)
                .map((json) => PopularCategories.fromJson(json))
                .toList();
          }

          // Parse Adds (Check for List)
          if (homeData['adds'] != null) {
            _addsList = (homeData['adds'] as List)
                .map((json) => Add.fromJson(json))
                .toList();
          }

          // debugPrint("data found");
          if (homeData['popularRestaurants'] != null) {
            _popularRestaurant = (homeData['popularRestaurants'] as List)
                .map((json) => PopularRestaurant.fromJson(json))
                .toList();
          } else {
            debugPrint(
                "Popular restaurants data is either null or not formatted correctly.");
          }

          debugPrint(homeData['topOffers']?.toString() ?? "Popular categories data is null");
          debugPrint('Data Found');
          if (homeData['topOffers'] != null && homeData['topOffers']['offers'] != null) {
            _topOffers = (homeData['topOffers']['offers'] as List)
                .map((json) => TopOffer.fromJson(json))
                .toList();
            debugPrint("TopOffers data: $_topOffers");
          } else {
            debugPrint("No topOffers data found.");
          }

          // Notify listeners when the data is successfully fetched and parsed.
          notifyListeners();
        } else {
          log("API returned success=false: ${result['message']}");
        }
      } else {
        log("Failed to fetch home details: ${response.statusCode}");
      }
    } catch (e) {
      log("Error fetching home details: $e");
      rethrow; // Optionally rethrow the error to notify UI about failure.
    }
  }
}
