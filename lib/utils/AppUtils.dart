import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:getwidget/components/toast/gf_toast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swiggy_app/pages/LoginPage/loginpage.dart';

class AppUtil {
  static String? token = null;
  static String? name = null;
  static String? mobile = null;
  static String? email = null;

  static Future<void> logout(BuildContext context) async {
    SharedPreferences storage = await SharedPreferences.getInstance();
    await storage.remove('token');

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  // static getAppBar(String title) {
  //   return AppBar(
  //     backgroundColor: primaryColor,
  //     title: Text(
  //       title.toUpperCase(),
  //       style: TextStyle(fontSize: 16),
  //     ),
  //   );
  // }

  static showToast(BuildContext context, String msg, {Duration duration = const Duration(seconds: 3)}) {
    GFToast.showToast(
      msg,
      context,
    );
  }

  // static sql_date_convert(String sql_date) {
  //   var inputFormat = DateFormat('yyyy-MM-dd');
  //   var inputDate = inputFormat.parse(sql_date); // <-- Incoming date
  //
  //   var outputFormat = DateFormat('dd-MM-yyyy');
  //   var outputDate = outputFormat.format(inputDate); // <-- Desired date
  //   return outputDate.toString();
  // }

  static Future<String?> getToken() async {
    SharedPreferences storage = await SharedPreferences.getInstance();
    String? token = storage.getString('token');
    return token;
  }

  static setToken(String key, String value) async {
    SharedPreferences storage = await SharedPreferences.getInstance();
    await storage.setString(key, value);
  }

  static Future<void> removeToken() async {
    SharedPreferences storage = await SharedPreferences.getInstance();
    await storage.remove('token');
  }

  static Future<Placemark?> getAddressFromLatLng(LatLng location) async {
    Placemark? placemark = null;
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(location.latitude, location.longitude);
      if (placemarks != null && placemarks.isNotEmpty) {
        placemark = placemarks[0];
      } else {}
    } catch (e) {
      print(e);
    }
    return placemark;
  }

  static Future<LatLng> getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    return LatLng(position.latitude, position.longitude);
  }

  static void errorAlert(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: Colors.red,
      content: Text(msg),
    ));
  }

// /*static ImageProvider getImageProvider(String? icon) {
  //   if (icon == null) {
  //     return AssetImage("assets/no_image.jpg");
  //   } else {
  //     return NetworkImage(
  //       base_url + icon.toString(),
  //     );
  //   }
  // }*/

  // static String toProperCase(String input) {
  //   return input.split(' ').map((word) {
  //     if (word.isEmpty) return word;
  //     return word[0].toUpperCase() + word.substring(1).toLowerCase();
  //   }).join(' ');
  // }

}
