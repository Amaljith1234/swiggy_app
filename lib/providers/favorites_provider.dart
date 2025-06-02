import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:swiggy_app/Utils/Network_Utils.dart';
import '../models/API_models/favorites_model.dart';

class FavoriteProvider with ChangeNotifier {
  List<FavoriteRestaurant> _favoriteFoods = [];
  bool _isLoading = false;

  List<FavoriteRestaurant> get favoriteFoods => _favoriteFoods;

  bool get isLoading => _isLoading;

  /// Fetch favorite food list
  Future<void> fetchFavoriteFoods() async {
    try {
      _isLoading = true;
      notifyListeners();

      final response = await NetworkUtil.get(NetworkUtil.FAVORITES_LIST_URL);

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);

        if (jsonResponse['data'] != null &&
            jsonResponse['data']['favoriteRestaurants'] != null) {
          final List<dynamic> data =
              jsonResponse['data']['favoriteRestaurants'];

          /// Map the response to the `FavoriteRestaurant` model
          _favoriteFoods = data
              .map((json) =>
                  FavoriteRestaurant.fromJson(json as Map<String, dynamic>))
              .toList();
        }
      } else {
        throw Exception('Failed to load favorite foods');
      }
    } catch (error) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// ✅ Add and Remove Restaurant from Favorites
  Future<void> addAndRemoveToFavorites(
      String restaurantId, BuildContext context) async {
    try {
      Map<String, String> data = {
        'restaurantId': restaurantId,
      };

      final response = await NetworkUtil.post(
          NetworkUtil.ADD_and_REMOVE_TO_FAVORITES_URL,
          body: data);

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);

        if (jsonResponse['data'] != null) {
          final newFavorite = FavoriteRestaurant.fromJson(jsonResponse['data']);

          bool isFavorite = false;

          // ✅ Toggle favorite status correctly
          if (_favoriteFoods.any((item) => item.id == restaurantId)) {
            _favoriteFoods.removeWhere((item) => item.id == restaurantId);
            isFavorite = false; // Removed from favorites
          } else {
            _favoriteFoods.add(newFavorite);
            isFavorite = true; // Added to favorites
          }

          notifyListeners();

          // ✅ Display Success Message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                isFavorite
                    ? 'Added to favorites successfully!'
                    : 'Removed from favorites!',
              ),
              backgroundColor: isFavorite ? Colors.green : Colors.red,
              duration: const Duration(seconds: 2),
            ),
          );
        }
      } else {
        throw Exception('Failed to add/remove favorite');
      }
    } catch (error) {
      rethrow;
    }
  }
}
