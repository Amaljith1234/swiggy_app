import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import '../Utils/Network_Utils.dart';
import '../models/API_models/search_model.dart';

class SearchProvider extends ChangeNotifier {
  static const int _pageSize = 10;

  final PagingController<int, Hotel> restaurantPagingController =
  PagingController(firstPageKey: 1);
  final PagingController<int, SearchFoodItem> foodPagingController =
  PagingController(firstPageKey: 1);

  String _currentKeyword = "";
  int _currentTab = 0;

  SearchProvider() {
    restaurantPagingController.addPageRequestListener((pageKey) {
      fetchSearchResults(_currentKeyword, pageKey, 0);
    });

    foodPagingController.addPageRequestListener((pageKey) {
      fetchSearchResults(_currentKeyword, pageKey, 1);
    });
  }

  Future<void> fetchSearchResults(String keyword, int pageKey, int tabIndex) async {
    try {
      final response = await NetworkUtil.get(
        '${NetworkUtil.SEARCH_URL}/$pageKey/$_pageSize?keyword=$keyword',
      );

      debugPrint(response.statusCode.toString());
      debugPrint(response.body);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final resultList = List<dynamic>.from(data['data']['result'] ?? []);
        final result = resultList.isNotEmpty ? resultList.first : {};

        final List<dynamic> newItems = tabIndex == 0
            ? (result['restaurants'] as List<dynamic>?)
            ?.map((hotel) => Hotel.fromJson(hotel))
            .toList() ?? []
            : (result['foodItems'] as List<dynamic>?)
            ?.map((food) => SearchFoodItem.fromJson(food))
            .toList() ?? [];

        final isLastPage = newItems.length < _pageSize;
        if (isLastPage) {
          _getPagingController(tabIndex).appendLastPage(newItems);
        } else {
          _getPagingController(tabIndex).appendPage(newItems, pageKey + 1);
        }
      } else {
        _getPagingController(tabIndex).error = 'Failed to load data';
      }
    } catch (e) {
      _getPagingController(tabIndex).error = e.toString();
    }
  }

  void triggerSearch(String keyword, int tabIndex) {
    _currentKeyword = keyword;
    _currentTab = tabIndex;
    _getPagingController(tabIndex).refresh();
  }

  PagingController<int, dynamic> _getPagingController(int tabIndex) {
    return tabIndex == 0 ? restaurantPagingController : foodPagingController;
  }
}
