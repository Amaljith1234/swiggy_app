import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:swiggy_app/models/API_models/address_model.dart';
import '../../../../Utils/AppUtils.dart';
import '../../../../Utils/Network_Utils.dart';
import '../../../Map/map_picker.dart';

class EditAddressScreen extends StatefulWidget {
  final AddressModel address;

  const EditAddressScreen({super.key, required this.address});

  @override
  State<EditAddressScreen> createState() => _EditAddressScreenState();
}

class _EditAddressScreenState extends State<EditAddressScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  LatLng? _initialLocation;
  String addressString = '';

  late TextEditingController labelController;
  late TextEditingController streetController;
  late TextEditingController cityController;
  late TextEditingController stateController;
  late TextEditingController countryController;
  late TextEditingController zipCodeController;
  late TextEditingController latController;
  late TextEditingController lngController;

  bool isPrimary = false;

  @override
  void initState() {
    super.initState();
    _initializeFields();
  }

  void _initializeFields() {
    labelController = TextEditingController(text: widget.address.label);
    streetController = TextEditingController(text: widget.address.street);
    cityController = TextEditingController(text: widget.address.city);
    stateController = TextEditingController(text: widget.address.state);
    countryController = TextEditingController(text: widget.address.country);
    zipCodeController = TextEditingController(text: widget.address.zipCode);
    latController = TextEditingController(text: widget.address.lat.toString());
    lngController = TextEditingController(text: widget.address.lng.toString());
    _initialLocation = LatLng(widget.address.lat, widget.address.lng);

  }

  Future<void> submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    final String primary = isPrimary ? 'true' : 'false';

    Map<String, String> data = {
      'label': labelController.text.trim(),
      'street': streetController.text.trim(),
      'city': cityController.text.trim(),
      'state': stateController.text.trim(),
      'country': countryController.text.trim(),
      'zipCode': zipCodeController.text.trim(),
      'lat': latController.text.trim(),
      'lng': lngController.text.trim(),
      'primaryAddress': primary,
      '_id': widget.address.id,
    };

    try {
      final response = await NetworkUtil.post(NetworkUtil.ADD_UPDATE_ADDRESS_URL, body: data);
      if (response.statusCode == 200) {
        var result = json.decode(response.body);
        if (result['success'] == true) {
          AppUtil.showToast(context, "Address updated successfully!");
          Navigator.pop(context, true);
        } else {
          AppUtil.showToast(context, result['message']);
        }
      } else {
        AppUtil.showToast(context, "Failed to update address.");
      }
    } catch (e) {
      AppUtil.showToast(context, "An error occurred. Please try again.");
    }
  }

  @override
  void dispose() {
    labelController.dispose();
    streetController.dispose();
    cityController.dispose();
    stateController.dispose();
    countryController.dispose();
    zipCodeController.dispose();
    latController.dispose();
    lngController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Address"),
        backgroundColor: Colors.orange,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              customTextField(controller: labelController, hintText: "Label"),
              customTextField(controller: streetController, hintText: "Street"),
              customTextField(controller: cityController, hintText: "City"),
              customTextField(controller: stateController, hintText: "State"),
              customTextField(controller: countryController, hintText: "Country"),
              customTextField(controller: zipCodeController, hintText: "Zip Code"),
              customTextField(controller: latController, hintText: "Latitude", keyboardType: TextInputType.number),
              customTextField(controller: lngController, hintText: "Longitude", keyboardType: TextInputType.number),
              SwitchListTile(
                title: Text("Set as Primary Address"),
                value: isPrimary,
                onChanged: (value) {
                  setState(() {
                    isPrimary = value;
                  });
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                ),
                child: const Text("Update Address", style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget customTextField({
    required TextEditingController controller,
    required String hintText,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        validator: (value) => value == null || value.trim().isEmpty ? "$hintText is required" : null,
        decoration: InputDecoration(
          hintText: hintText,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}
