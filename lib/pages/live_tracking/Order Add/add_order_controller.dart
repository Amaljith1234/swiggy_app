import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../../../providers/address_provider.dart';
import '../order.dart';

class AddOrderController extends GetxController {
  TextEditingController nameController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController idController = TextEditingController();

  GoogleMapController? mapController;
  LatLng currentLocation = const LatLng(0.0, 0.0);
  LatLng selectedLocation = const LatLng(0.0, 0.0);

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  late CollectionReference orderCollection;

  @override
  Future<void> onInit() async {
    orderCollection = firestore.collection("order");
    super.onInit();
  }

  /// ✅ Method to populate controller with `Order` values
  void setOrder(MyOrder order) {
    idController.text = order.id;
    nameController.text = order.name;
    amountController.text = order.amount.toString();
    selectedLocation = LatLng(order.latitude, order.longitude);
    update();
  }

  void addOrder(BuildContext context) {
    try {
      if (nameController.text.isEmpty ||
          idController.text.isEmpty ||
          amountController.text.isEmpty) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Please fill field')));
        return;
      } else if (selectedLocation.longitude == 0 ||
          selectedLocation.latitude == 0) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please select a location')));
        return;
      } else {
        DocumentReference doc = orderCollection.doc(idController.text);
        MyOrder order = MyOrder(
          id: doc.id,
          name: nameController.text,
          latitude: selectedLocation.latitude.toDouble(),
          longitude: selectedLocation.longitude.toDouble(),
          // phone: phoneController.text,
          // address: addressController.text,
          amount: double.parse(amountController.text),
        );

        final orderJson = order.toJson();
        doc.set(orderJson);
        clearTextFields();
        // ScaffoldMessenger.of(context).showSnackBar(
        //     const SnackBar(content: Text('Order added successfully')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Failed to add order')));
      rethrow;
    }
  }

  clearTextFields() {
    idController.clear();
    nameController.clear();
    // phoneController.clear();
    // addressController.clear();
    amountController.clear();
  }
}
