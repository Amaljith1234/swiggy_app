import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:swiggy_app/Utils/Network_Utils.dart';
import '../models/API_models/order_model.dart';

class OrderProvider with ChangeNotifier {

  List<Order> _orders = [];
  bool _isLoading = false;
  String _error = '';

  List<Order> get orders => _orders;
  bool get isLoading => _isLoading;
  String get error => _error;

  static const String baseUrl = 'http://15.206.84.213:4000';  // Replace with your API URL

  Future<void> fetchOrders() async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      final response = await NetworkUtil.get(NetworkUtil.GET_ALL_ORDERS_URL);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        if (jsonData['data'] != null && jsonData['data']['orders'] != null) {
          _orders = (jsonData['data']['orders'] as List)
              .map((orderJson) => Order.fromJson(orderJson))
              .toList();
        } else {
          _error = 'No orders found';
        }
      } else {
        _error = 'Failed to load orders: ${response.statusCode}';
      }
    } catch (e) {
      _error = 'Error fetching orders: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
