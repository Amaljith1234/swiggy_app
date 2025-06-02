import 'dart:convert';
import 'dart:ui' as ui;
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import '../../../models/API_models/order_model.dart' as MyModels;

class LiveTrackingController extends GetxController {
  final MyModels.Order order;

  LiveTrackingController({required this.order});

  late MyModels.Order _myOrder;

  MyModels.Order get myOrder => _myOrder;

  set myOrder(MyModels.Order order) {
    _myOrder = order;
    debugPrint("✅ myOrder setter called with order ID: ${order.id}");
  }

  // Variables
  late LatLng destination = LatLng(0.0, 0.0);
  LatLng? deliveryBoyLocation;

  GoogleMapController? mapController;

  BitmapDescriptor markerIcon = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow,);
  BitmapDescriptor destinationIcon = BitmapDescriptor.defaultMarker;

  double remainingDistance = 0.0;

  // Polyline variables
  Set<Marker> markers = <Marker>{}.obs;
  Set<Polyline> polylines = <Polyline>{}.obs;
  List<LatLng> polylineCoordinates = <LatLng>[].obs;

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  late CollectionReference orderTrackingCollection;

  @override
  void onInit() {
    super.onInit();
    orderTrackingCollection = firestore.collection('orderTracking');
    debugPrint("🔥 Tracking initialized for order: ${order.id}");
    // updateDestinationLocation(order.address.lat, order.address.lng);
    // startTracking(order.id);
  }

  /// ✅ Add custom markers
  // void addCustomMarkers() async {
  //   debugPrint("🟢 Adding custom markers...");
  //   markerIcon = await getResizedMarker('assets/location.png', 80);
  //   destinationIcon = await getResizedMarker('assets/destination.png', 80);
  //   debugPrint("✅ Custom markers added.");
  // }

  /// ✅ Resize markers
  Future<BitmapDescriptor> getResizedMarker(String assetPath, int size) async {
    try {
      debugPrint("🟡 Loading marker image: $assetPath");
      ByteData data = await rootBundle.load(assetPath);

      ui.Codec codec = await ui.instantiateImageCodec(
        data.buffer.asUint8List(),
        targetWidth: size,
        targetHeight: size,
      );
      ui.FrameInfo fi = await codec.getNextFrame();
      ByteData? byteData =
          await fi.image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List resizedImage = byteData!.buffer.asUint8List();
      debugPrint("✅ Marker resized successfully.");
      return BitmapDescriptor.fromBytes(resizedImage);
    } catch (e) {
      debugPrint("❌ Error resizing marker: $e");
      return BitmapDescriptor.defaultMarker;
    }
  }

  /// ✅ Initialize Polyline
  // Future<void> initializePolyline() async {
  //   if (deliveryBoyLocation != null) {
  //     debugPrint("🚩 Initializing polyline...");
  //     debugPrint("🚩 Initializing polyline..."  +  deliveryBoyLocation!.longitude.toString() +  " " +  deliveryBoyLocation!.longitude.toString() );
  //     // await getPolylinePoints();
  //     // updatePolyline();
  //
  //     if (polylineCoordinates.isNotEmpty) {
  //       polylines = {
  //         Polyline(
  //           polylineId: const PolylineId('route'),
  //           points: polylineCoordinates,
  //           color: Colors.blue,
  //           width: 5,
  //           startCap: Cap.roundCap,
  //           endCap: Cap.roundCap,
  //         )
  //       };
  //       update();
  //       debugPrint("✅ Polyline initialized.");
  //     } else {
  //       debugPrint("⚠️ No polyline coordinates fetched.");
  //     }
  //   } else {
  //     debugPrint("⚠️ Delivery boy location is NULL. Skipping polyline.");
  //   }
  // }

  /// ✅ Real-time Firestore tracking
  void startTracking(String orderId) {
    debugPrint("🟠 Starting tracking for order: $orderId");
    try {
      orderTrackingCollection.doc(orderId).snapshots().listen((snapshot) {
        if (snapshot.exists) {
          // if (snapshot.metadata.hasPendingWrites) {
          var trackingData = snapshot.data() as Map<String, dynamic>;
          debugPrint("📌 Firestore Data: $trackingData"); // ✅ Log the data
          if (trackingData.containsKey('latitude') &&
              trackingData.containsKey('longitude')) {
            double latitude = trackingData['latitude'];
            double longitude = trackingData['longitude'];

            if (latitude != 0.0 && longitude != 0.0) {
              debugPrint("✅ Valid location received: ($latitude, $longitude)");
              updateUIWithLocation(latitude, longitude);

            } else {
              debugPrint(
                  "⚠️ Invalid location data received: ($latitude, $longitude)");
            }
          } else {
            debugPrint("⚠️ No latitude/longitude found in Firestore.");
          }
        } else {
          debugPrint("📌Customer location Showing");
          if(order.address.lat != 0.0 &&  order.address.lng != 0.0){
            mapController!
                .animateCamera(CameraUpdate.newLatLng( LatLng(order.address.lat , order.address.lng, )));
            markers = {
              Marker(
                markerId: const MarkerId("destination"),
                position: destination,
                icon: destinationIcon,
                infoWindow: const InfoWindow(title: "Me / No Delivery Boy"),
              ),
            };

            update();
          }

          debugPrint("⚠️ No snapshot exists for order: $orderId");
        }
        // }
      });
    } catch (e) {
      debugPrint("❌ Error in tracking: $e");
    }
  }

  /// ✅ Update UI with new location
  void updateUIWithLocation(double latitude, double longitude) {
    debugPrint("🔵 Updating UI with location: ($latitude, $longitude)");
    deliveryBoyLocation = LatLng(latitude, longitude);
    if (mapController != null) {
        mapController!
            .animateCamera(CameraUpdate.newLatLng(deliveryBoyLocation!));

      calculateRemainingDistance();
      // update();
    } else {
      debugPrint("⚠️ Map controller is NULL.");
    }
  }

  /// ✅ Calculate remaining distance
  void calculateRemainingDistance() {
    if (deliveryBoyLocation != null) {
      double distance = Geolocator.distanceBetween(
        deliveryBoyLocation!.latitude,
        deliveryBoyLocation!.longitude,
        destination.latitude,
        destination.longitude,
      );
      remainingDistance = distance / 1000;
      debugPrint(
          "✅ Remaining Distance: ${remainingDistance.toStringAsFixed(2)} km");
      update();
    } else {
      debugPrint(
          "⚠️ Delivery boy location is NULL, skipping distance calculation.");
    }
  }

  /// ✅ Set destination location
  void updateDestinationLocation(double latitude, double longitude) {
    destination = LatLng(latitude, longitude);
    debugPrint("📍 Destination set to: (${destination!.latitude}, ${destination!.longitude})");
    try {

      updatePolyline();

    }catch (e) {debugPrint("❌ Error in User Marker");}
    update();
  }

  /// ✅ Get polyline points from Google Maps API
  Future<void> getPolylinePoints() async {
    try {
      debugPrint("🚀 Get Polyline Started");
      if (deliveryBoyLocation == null) {
        debugPrint(
            "⚠️ Skipping polyline fetch: delivery boy location is NULL.");
        return;
      }

      // String apiKey = "AIzaSyBqpg1fgJ9dgCRJPZLIh-Qug-e_MqgWty8";
      String apiKey = '';
      String url =
          "https://maps.googleapis.com/maps/api/directions/json?origin=${deliveryBoyLocation!.latitude},${deliveryBoyLocation!.longitude}&destination=${destination.latitude},${destination.longitude}&key=$apiKey";

      debugPrint("🔵 Fetching polyline from: $url");

      var response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        debugPrint("polyLine Status : " + response.statusCode.toString());
        var data = json.decode(response.body);

        if (data["status"] == "OK") {
          var points = data["routes"][0]["overview_polyline"]["points"];
          debugPrint("points " + points.toString());

          polylineCoordinates = _decodePolyline(points);

          if (polylineCoordinates.isNotEmpty) {
            debugPrint("✅ Polyline fetched successfully.");
            updatePolyline();
          } else {
            debugPrint("⚠️ No coordinates decoded.");
          }
        } else {
          debugPrint("⚠️ No routes found in API response.");
        }
      } else {
        debugPrint(
            "❌ Failed to fetch polyline. Status Code: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  /// ✅ Update Polyline on the Map
  void updatePolyline() {
    try {
      if (polylineCoordinates.isEmpty) { // changed to isEmpty
        // debugPrint("PolyLine polylineCoordinates : " + polylineCoordinates.toString());
        // polylines.clear();

        // polylines.add(
        //   Polyline(
        //     polylineId: const PolylineId('route'),
        //     points: polylineCoordinates,
        //     color: Colors.blue,
        //     width: 5,
        //     startCap: Cap.roundCap,
        //     endCap: Cap.roundCap,
        //   ),
        // );
        markers = {
          Marker(
            markerId: const MarkerId("start"),
            position: deliveryBoyLocation ?? LatLng(0, 0),
            icon: markerIcon,
            infoWindow: const InfoWindow(title: "Delivery Boy"),
          ),
          Marker(
            markerId: const MarkerId("destination"),
            position: destination,
            icon: destinationIcon,
            infoWindow: const InfoWindow(title: "Me"),
          ),
        };

        update();

        debugPrint("✅ Polyline and markers updated.");
      } else {
        debugPrint("⚠️ No polyline coordinates to display.");
      }
    } catch (e) {
      debugPrint("⚠️ Polyline coordinates error." + e.toString());
    }
  }

  List<LatLng> _decodePolyline(String encoded) {
    List<PointLatLng> result = PolylinePoints().decodePolyline(encoded);
    return result
        .map((point) => LatLng(point.latitude, point.longitude))
        .toList();
  }

  /// ✅ Decode polyline
// List<LatLng> decodePolyline(String encoded) {
//   List<LatLng> polylinePoints = [];
//   int index = 0, len = encoded.length;
//   int lat = 0, lng = 0;
//
//   while (index < len) {
//     int b, shift = 0, result = 0;
//     do {
//       b = encoded.codeUnitAt(index++) - 63;
//       result |= (b & 0x1F) << shift;
//       shift += 5;
//     } while (b >= 0x20);
//
//     int dlat = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
//     lat += dlat;
//
//     int dlng = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
//     lng += dlng;
//
//     polylinePoints.add(LatLng(lat / 1E5, lng / 1E5));
//   }
//
//   return polylinePoints;
// }
}
