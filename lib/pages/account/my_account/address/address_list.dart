import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:swiggy_app/models/API_models/address_model.dart';
import '../../../../Utils/AppUtils.dart';
import '../../../../Utils/Network_Utils.dart';
import '../../../../widgets/custom_divider_view.dart';
import '../../../Map/map_picker.dart';
import 'add_address_screen.dart';

class AddressListPage extends StatefulWidget {
  const AddressListPage({super.key});

  @override
  State<AddressListPage> createState() => _AddressListPageState();
}

class _AddressListPageState extends State<AddressListPage> {
  LatLng? _initialLocation;
  String address = '';
  List<AddressModel> _addressItems = [];

  @override
  void initState() {
    super.initState();
    fetchAddressList();
  }

  /// Fetch Address List from API
  Future<void> fetchAddressList() async {
    try {
      final response = await NetworkUtil.get(NetworkUtil.ADDRESS_LIST_URL);

      debugPrint("status code : "+response.statusCode.toString());
      debugPrint("adress body : "+response.body);

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final List<dynamic> addressList = responseData['data']['addressData'];

        setState(() {
          _addressItems =
              addressList.map((addr) => AddressModel.fromJson(addr)).toList();
        });
      } else {
        showSnackBar('Failed to load address data');
      }
    } catch (error) {
      showSnackBar('Error fetching address data: $error');
    }
  }

  /// Delete Address from API
  Future<void> deleteAddress(String addressId) async {
    Map<String, String> data = {
      'addressId': addressId,
    };

    try {
      final response =
          await NetworkUtil.delete(NetworkUtil.DELETE_ADDRESS_URL, body: data);

      debugPrint(response.statusCode.toString());
      debugPrint(response.body);

      if (response.statusCode == 200) {
        showSnackBar("Address deleted successfully!");
        fetchAddressList();
      } else {
        showSnackBar("Failed to delete address.");
      }
    } catch (error) {
      showSnackBar("Error deleting address: $error");
    }
  }

  /// Show Snackbar for errors
  void showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: Colors.red,
    ));
  }

  /// Open Map Picker and get new address
  Future<void> _pickLocation() async {
    final result = await Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => MapPicker(Location: _initialLocation)));

    if (result is LatLng) {
      setState(() {
        _initialLocation = result;
      });

      Placemark? placemark =
          await AppUtil.getAddressFromLatLng(_initialLocation!);
      if (placemark != null) {
        setState(() {
          address =
              'Street: ${placemark.subThoroughfare ?? ''}, City: ${placemark.locality ?? ''}, '
              'State: ${placemark.administrativeArea ?? ''}, Zip: ${placemark.postalCode ?? ''}, '
              'Country: ${placemark.country ?? ''}';
        });
      }
      fetchAddressList(); // Refresh address list
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Choose your Address",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLocationOption(
              Icons.my_location_outlined, "Use my current location"),
          _buildLocationOption(Icons.add, "Add new address"),
          const Divider(indent: 10, endIndent: 10),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 22),
            child: Text(
              "S A V E D  A D D R E S S E S",
              style: GoogleFonts.atkinsonHyperlegible(fontSize: 16),
            ),
          ),
          Expanded(
            child: _addressItems.isEmpty
                ? const Center(child: Text("No Address Found"))
                : ListView.builder(
                    itemCount: _addressItems.length,
                    itemBuilder: (context, index) {
                      final address = _addressItems[index];
                      return Column(
                        children: [
                          ListTile(
                            leading: const Icon(Icons.location_on,
                                color: Colors.orange),
                            title: Row(
                              children: [
                                Text(address.label.isNotEmpty
                                    ? address.label
                                    : 'No label available'),
                                SizedBox(
                                  width: 5,
                                ),
                                Icon(
                                  address.primaryAddress == true
                                      ? Icons.check_box_outlined
                                      : null,
                                  size: 15,
                                ),
                              ],
                            ),
                            subtitle: Text(
                              '${address.street ?? 'No street'}, ${address.city ?? 'No city'}, '
                              '${address.state ?? 'No state'}, ${address.country ?? 'No country'}, '
                              '${address.zipCode ?? 'No zipCode'}',
                            ),
                            trailing: Column(
                              children: [
                                InkWell(
                                    onTap: () async {
                                      bool? updated = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              EditAddressScreen(
                                                  address: address),
                                        ),
                                      );

                                      if (updated == true) {
                                        fetchAddressList();
                                      }
                                    },
                                    child: Icon(Icons.edit)),
                                SizedBox(height: 5,),
                                InkWell(
                                  onTap: () {
                                    deleteAddress(address.id);
                                  },
                                  child: Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                    size: 17,
                                  ),
                                ),
                              ],
                            ),
                            onTap: () {
                              Navigator.pop(context, address);
                            },
                          ),
                          const CustomDividerView(
                              dividerHeight: 0.8, color: Colors.black26),
                        ],
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  /// Widget to create location selection options
  Widget _buildLocationOption(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 17),
      child: GestureDetector(
        onTap: _pickLocation,
        child: Row(
          children: [
            Icon(icon, color: Colors.deepOrange),
            Text(
              " $text",
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                  color: Colors.deepOrange),
            ),
          ],
        ),
      ),
    );
  }
}
