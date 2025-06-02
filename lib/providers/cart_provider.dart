import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:swiggy_app/utils/Network_Utils.dart';
import 'package:swiggy_app/models/API_models/cart_model.dart';

class CartProvider with ChangeNotifier {

  List<CartItem> _cartItems = [];
  List<CartItem> get cartItems => _cartItems;

  Future<void> fetchCartData() async {

    try {
      final response = await NetworkUtil.get(NetworkUtil.GET_ALL_CART_URL);

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final cartData = CartData.fromJson(responseData['data']);
        _cartItems = cartData.cartItems;
        notifyListeners();
      } else {
        // Handle error cases
        print('Failed to load cart data');
      }
    } catch (error) {
      // Handle exceptions
      print('Error fetching cart data: $error');
    }
  }

}

class CartService {

  static Future<bool> addToCart({
    required BuildContext context,
    required String foodId,
    required String restaurantId,
    required int qty,
  }) async {
    Map<String, String> data = {
      'foodId': foodId,
      'restaurantId': restaurantId,
      'qty': qty.toString(),
    };

    try {
      final response =
      await NetworkUtil.post(NetworkUtil.ADD_TO_CART_URL, body: data);

      debugPrint("Cart API Request: $data");
      debugPrint("Response Status: ${response.statusCode}");
      debugPrint("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        // ScaffoldMessenger.of(context).showSnackBar(
        //   const SnackBar(
        //     content: Text('Item added to cart successfully!'),
        //     backgroundColor: Colors.green,
        //     duration: Duration(seconds: 2),
        //   ),
        // );
        return true;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to add item to cart. Please try again.'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 2),
          ),
        );
        return false;
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 2),
        ),
      );
      return false;
    }
  }

  static Future<bool> updateCartItem({
    required BuildContext context,
    required String foodId,
    required String cartId,
    required int qty,
  }) async {
    Map<String, String> data = {
      'foodId': foodId,
      'cartId': cartId,
      'qty': qty.toString(),
    };

    try {
      final response =
      await NetworkUtil.post(NetworkUtil.UPDATE_CART_URL, body: data);

      debugPrint("Cart Update API Request: $data");
      debugPrint("Response Status: ${response.statusCode}");
      debugPrint("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        // ScaffoldMessenger.of(context).showSnackBar(
        //   const SnackBar(
        //     content: Text('Cart Item Updated Successfully'),
        //     backgroundColor: Colors.green,
        //     duration: Duration(seconds: 2),
        //   ),
        // );
        return true;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to remove item from cart. Please try again.'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 2),
          ),
        );
        return false;
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 2),
        ),
      );
      return false;
    }
  }

}