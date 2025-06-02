import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'AppUtils.dart';

class NetworkUtil {
  static String? token;

  static String base_url = "http://13.126.146.173:4000/";

  static String customer_login_url = "customer/login";

  static String customer_signUp_url = "customer/signup/";


  static String HOME_PAGE_URL = 'customer/profile/home/1/10'; //PAGE

  static String SEARCH_URL = 'customer/profile/search'; //PAGE

  static String OFFERS_URL = 'customer/profile/offers/restaurant/1/10'; // PAGE

  static String RESTAURANTS_URL = 'customer/profile/restaurants/1/50'; //PAGE

  static String ACCOUNT_DETAILS_URL = 'customer/profile/account/1/3'; //PAGE

  static String ADD_UPDATE_BANK_DETAISL_URL = 'customer/profile/bank-details';


  static String ADD_UPDATE_ADDRESS_URL = 'customer/profile/address';

  static String ADDRESS_LIST_URL = "address/list";

  static String DELETE_ADDRESS_URL = 'customer/profile/address';


  static String PLACE_ORDER_URL = "user/ordering";

  static String ADD_TO_CART_URL = "user/cart/add-to-cart";

  static String GET_ALL_CART_URL = "user/cart/";

  static String UPDATE_CART_URL = "user/cart/update-cart";

  static String DELETE_CART_URL = "user/cart/delete-cart-item";


  static String FOOD_DETAILS_URL = "food";

  static String RESTAURANT_DETAILS_URL = "customer/profile/restaurant";


  static String GET_ALL_ORDERS_URL = "user/ordering/customer/list/1/10";


  static String FORGOT_PASSWORD_URL = 'customer/profile/forgot-password';

  static String RESET_PASSWORD_WITH_OTP_URL = 'customer/profile/reset-password';


  static String ADD_and_REMOVE_TO_FAVORITES_URL = 'customer/profile/add-or-remove-from-favorite-list';

  static String FAVORITES_LIST_URL = 'customer/profile/favorites-list/1/20';




  static Future<http.Response> get(String uri,
      {Map<String, dynamic>? body}) async {
    try {
      token = await AppUtil.getToken();
      Map<String, String> headers = {
        'Content-Type': 'application/x-www-form-urlencoded',
      };

      if (token != null) {
        headers[HttpHeaders.authorizationHeader] = 'Bearer $token';
      }

      // Build URL dynamically
      Uri url = Uri.parse(base_url + uri);

      if (body != null && body.isNotEmpty) {
        url = url.replace(queryParameters: body);
      }

      debugPrint("Request URL: $url");

      final response = await http.get(url, headers: headers);
      return response;
    } on SocketException catch (e) {
      throw SocketException(e.toString());
    } on FormatException {
      throw const FormatException("Unable to process the data");
    } catch (e) {
      throw e;
    }
  }

  static Future<http.Response> post(String uri, {body}) async {
    try {
      token = await AppUtil.getToken();
      debugPrint("Token retrieved: " + (token ?? "No token found"));

      Map<String, String> headers = {};
      if (token != null) {
        headers = {
          'Content-Type': 'application/x-www-form-urlencoded',
          // 'Accept': 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer ' + token!
        };
      } else {
        headers = {
          'Content-Type': 'application/x-www-form-urlencoded',
          // 'Accept': 'application/json'
        };
      }

      var url = Uri.parse(base_url + uri);
      debugPrint(url.toString());
      debugPrint(body.toString());
      final response = await http.post(url, headers: headers, body: body);
      return response;
    } on SocketException catch (e) {
      throw SocketException(e.toString());
    } on FormatException catch (_) {
      throw const FormatException("Unable to process the data");
    } catch (e) {
      throw e;
    }
  }

  static Future<http.Response> delete(String uri,
      {Map<String, dynamic>? body}) async {
    try {
      token = await AppUtil.getToken();
      Map<String, String> headers = {
        'Content-Type': 'application/x-www-form-urlencoded',
      };

      if (token != null) {
        headers[HttpHeaders.authorizationHeader] = 'Bearer $token';
      }

      var url = Uri.parse(base_url + uri);

      debugPrint("DELETE Request URL: $url");
      debugPrint("Request Body: $body");

      final request = http.Request("DELETE", url);
      request.headers.addAll(headers);

      // Encode and attach body if provided
      if (body != null && body.isNotEmpty) {
        request.bodyFields =
            body.map((key, value) => MapEntry(key, value.toString()));
      }

      final response = await http.Client().send(request);
      return http.Response.fromStream(response);
    } on SocketException catch (e) {
      throw SocketException(e.toString());
    } on FormatException {
      throw const FormatException("Unable to process the data");
    } catch (e) {
      throw e;
    }
  }
}

const String API_TOKEN = "token";

const String PLACES_API_KEY = "AIzaSyBqpg1fgJ9dgCRJPZLIh-Qug-e_MqgWty8";