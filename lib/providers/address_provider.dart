import 'dart:convert';
import 'package:flutter/material.dart';
import '../../models/API_models/address_model.dart';
import '../Utils/Network_Utils.dart';
import 'package:collection/collection.dart';

class AddressProvider with ChangeNotifier {
  List<AddressModel> _addresses = [];
  AddressModel? _selectedAddress;

  List<AddressModel> get addresses => _addresses;
  AddressModel? get selectedAddress => _selectedAddress;

  /// Sets the selected address and notifies listeners
  void setAddress(AddressModel address) {
    _selectedAddress = address;
    notifyListeners();
  }

  /// Fetches addresses from the API and sets the primary address by default
  Future<void> fetchAddresses() async {
    try {
      final response = await NetworkUtil.get(NetworkUtil.ADDRESS_LIST_URL);

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final List<dynamic> addressList = responseData['data']['addressData'];

        _addresses = addressList.map((addr) => AddressModel.fromJson(addr)).toList();

        // Auto-select primary address if available, otherwise select first address
        _selectedAddress = _addresses.firstWhereOrNull((address) => address.primaryAddress == true) ??
            (_addresses.isNotEmpty ? _addresses[0] : null);

        notifyListeners();
      } else {
        debugPrint('Failed to load address data');
      }
    } catch (error) {
      debugPrint('Error fetching address data: $error');
    }
  }
}
