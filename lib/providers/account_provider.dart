import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';

import '../Utils/AppUtils.dart';
import '../Utils/Network_Utils.dart';
import '../models/API_models/account_model.dart';

class AccountProvider with ChangeNotifier {

  CustomerDetails? _accountDetails; // Now it's a single object, not a list
  CustomerDetails? get accountDetails => _accountDetails;

  Future<void> fetchProfileDetails() async {
    try {
      final token = await AppUtil.getToken();
      debugPrint("Fetched token: $token");

      final response = await NetworkUtil.get(NetworkUtil.ACCOUNT_DETAILS_URL);

      debugPrint("Status Code: ${response.statusCode}");
      debugPrint("Body: ${response.body}");

      if (response.statusCode == 200) {
        final result = json.decode(response.body);

        debugPrint("Decoded result: $result");

        if (result['statusCode'] == 200) {
          final data = result['data'];
          debugPrint("Fetched data: $data");

          // Check if data is not null before parsing
          if (data != null) {
            _accountDetails = CustomerDetails.fromJson(data);
            debugPrint("Profile data parsed successfully: $_accountDetails");
          } else {
            log("No data found in response.");
          }

          // Notify listeners to update the UI
          notifyListeners();
        } else {
          log("API returned success=false: ${result['message']}");
        }
      } else {
        log("Failed to fetch account details: ${response.statusCode}");
      }
    } catch (e) {
      log("Error fetching account details: $e");
      rethrow; // Optionally rethrow the error to notify UI about failure.
    }
  }

}
