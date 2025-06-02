// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get/get_core/src/get_main.dart';
// import '../live_tracking_page/live_tracking_page.dart';
// import 'order_list_controller.dart';
//
// class OrdersListPage extends StatelessWidget {
//   const OrdersListPage({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return GetBuilder<OrderListController>(
//         init: OrderListController(),
//         builder: (controller) {
//           return Scaffold(
//             appBar: AppBar(
//               title: const Text('Orders List'),
//             ),
//             body: ListView.builder(
//               itemCount: controller.orders.length,
//               itemBuilder: (context, index) {
//                 return ListTile(
//                   title: Text('Order ID: ${controller.orders[index].id}'),
//                   subtitle: Text('Customer: ${controller.orders[index].name}'),
//                   onTap: () {
//                     Get.to(LiveTrackingPage(order: controll));
//                   },
//                 );
//               },
//             ),
//           );
//         });
//   }
// }
