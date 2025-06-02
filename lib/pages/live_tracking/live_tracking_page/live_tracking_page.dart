import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../models/API_models/order_model.dart' as MyModels;
import 'live_tracking_controller.dart';

class LiveTrackingPage extends StatefulWidget {
  final MyModels.Order order;

  LiveTrackingPage({super.key, required this.order});

  @override
  State<LiveTrackingPage> createState() => _LiveTrackingPageState();
}

class _LiveTrackingPageState extends State<LiveTrackingPage> {
  late MyModels.Order order;

  @override
  void initState() {
    super.initState();
    order = widget.order;
    // Get.put(LiveTrackingController(order: order));
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LiveTrackingController>(
      init: LiveTrackingController(order: order),
      builder: (controller) {
        controller.myOrder = order;
        //
        // controller.startTracking(order.id);
        // controller.order = widget.order;
        // if (controller.deliveryBoyLocation != null) {
          // controller.initializePolyline();
        // }
        debugPrint("🚀 Order ID From Live Location Control: ${order.id}");
        return Scaffold(
          appBar: AppBar(
            title: const Text('Order Tracking'),
          ),
          body:
          // controller.remainingDistance == 0
          //     ? SizedBox(
          //         child: Center(
          //           child: Text("The DELIVERY BOY not picked up your order"),
          //         ),
          //       )
          //     :
          Stack(
                  children: [
                    GoogleMap(
                      key: ValueKey(controller.deliveryBoyLocation),
                      onMapCreated: (GoogleMapController mpCtrl) {
                        controller.mapController = mpCtrl;
                        controller.updateDestinationLocation(order.address.lat , order.address.lng);
                        controller.startTracking(order.id);
                        // controller.getPolylinePoints();
                      },
                      initialCameraPosition: CameraPosition(
                        target: controller.destination ,
                        zoom: 15.0,
                      ),
                      markers: controller.markers,
                      polylines: controller.polylines,
                    ),
                    Positioned(
                      top: 16.0,
                      left: 16.0,
                      right: 16.0,
                      child: Container(
                        padding: const EdgeInsets.all(12.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 5,
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Order ID: ${order.id}",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Remaining Distance: ${controller.remainingDistance.toStringAsFixed(2)} km",
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.blue,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
        );
      },
    );
  }
}
