import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:swiggy_app/providers/cart_provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Utils/Network_Utils.dart';
import '../../models/API_models/address_model.dart';
import '../../providers/address_provider.dart';
import '../../utils/ui_helper.dart';
import '../account/account_screen.dart';
import '../account/my_account/address/address_list.dart';
import 'package:http/http.dart' as http;

import '../live_tracking/Order Add/add_order_controller.dart';

class CartPaymentView extends StatefulWidget {
  @override
  State<CartPaymentView> createState() => _CartPaymentViewState();
}

class _CartPaymentViewState extends State<CartPaymentView> {
  late final CartProvider provider;
  var items;
  Map<String, dynamic>? paymentIntent;

  @override
  void initState() {
    super.initState();
    provider = context.read<CartProvider>();
    Stripe.publishableKey =
        'pk_test_51Qtl1NPG28nbQzTTd8F2q7OUIA5wVmngHBsiA3QazY0DPmrSYAxa0jCoWK08yuWIKVsDY2lkJ4DvNBvuZLeaMlR6000dMNL26K';
  }

  Future<void> makePayment() async {
    try {
      String? totalPrice = provider.cartItems.first.totalPrice.toString();

      paymentIntent = await createPaymentIntent(totalPrice, 'EUR');
      debugPrint(paymentIntent.toString());
      //STEP 2: Initialize Payment Sheet
      await Stripe.instance
          .initPaymentSheet(
              paymentSheetParameters: SetupPaymentSheetParameters(
                  paymentIntentClientSecret: paymentIntent!['client_secret'],
                  merchantDisplayName: 'Folo'))
          .then((value) {});

      //STEP 3: Display Payment sheet
      displayPaymentSheet();
    } catch (err) {
      debugPrint("ERROR -> " + err.toString());
      throw Exception(err);
    }
  }

  displayPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet().then((value) {
        placeOrder();
        debugPrint(
            "////////////////////////////////////////////////////////////////////////\n////////////////////  Payment success full in the ui  //////////////////\n//////////////////////////////////////////////////////////////////////////");
        showDialog(
            context: context,
            builder: (_) => AlertDialog(
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: 100.0,
                      ),
                      SizedBox(height: 10.0),
                      Text("Payment Successful!"),
                    ],
                  ),
                ));
        paymentIntent = null;
      }).onError((error, stackTrace) {
        throw Exception(error);
      });
    } on StripeException catch (e) {
      print('Error is:---> $e');
      AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: const [
                Icon(
                  Icons.cancel,
                  color: Colors.red,
                ),
                Text("Payment Failed"),
              ],
            ),
          ],
        ),
      );
    } catch (e) {
      print('$e');
    }
  }

  createPaymentIntent(String amount, String currency) async {
    try {
      //Request body
      Map<String, dynamic> body = {
        'amount': calculateAmount(amount),
        'currency': currency,
        "automatic_payment_methods[enabled]": "true",
      };
      debugPrint("sending money : " + calculateAmount(amount));

      String STRIPE_SECRET_KEY =
          "sk_test_51Qtl1NPG28nbQzTTap5D8abBpOQskiJUhRazRMaU7Z6tu20TbMvfKgqRBzffu6SpB8PBLtb4dYpryFnvUfG8v5bF00bdF4xdjk";

      Map<String, String> headers = {
        'Authorization': 'Bearer $STRIPE_SECRET_KEY',
        'Content-Type': 'application/x-www-form-urlencoded'
      };

      debugPrint(headers.toString());
      //Make post request to Stripe
      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: headers,
        body: body,
      );

      return json.decode(response.body);
    } catch (err) {
      throw Exception(err.toString());
    }
  }

  calculateAmount(String amount) {
    double? parsedAmount = double.tryParse(amount.trim());
    if (parsedAmount == null) {
      throw FormatException("Invalid amount format: $amount");
    }
    int finalAmount = (parsedAmount * 100).toInt();
    return finalAmount.toString(); // Stripe needs this as a string
  }

  //Stripe ends here

  _makingPhoneCall() async {
    var _url = Uri.parse("tel:1234567890");
    if (!await launchUrl(_url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $_url');
    }
  }

  @override
  Widget build(BuildContext context) {
    final addressProvider = Provider.of<AddressProvider>(context);
    final provider = context.watch<CartProvider>();
    final items = provider.cartItems;

    if (items == null) {
      return Container(
        padding: const EdgeInsets.all(15.0),
        child: Center(
            child:
                CircularProgressIndicator()), // Show loader while fetching data
      );
    }

    return items.isEmpty
        ? Center(child: Text(''))
        : Column(
            children: <Widget>[
              GestureDetector(
                onTap: _makingPhoneCall,
                child: Container(
                  height: 50.0,
                  color: Colors.black,
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.phone, color: Colors.yellow[800]),
                      UIHelper.horizontalSpaceSmall(),
                      Expanded(
                        child: Text(
                          'Want your order left outside? Call delivery executive',
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(color: Colors.white),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Stack(
                      children: <Widget>[
                        Container(
                          alignment: Alignment.center,
                          height: 60.0,
                          width: 60.0,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey,
                              width: 1.0,
                            ),
                          ),
                          child: const Icon(Icons.add_location, size: 30.0),
                        ),
                        Positioned(
                          top: 0.0,
                          right: 0.0,
                          child: Icon(
                            addressProvider.selectedAddress == null
                                ? Icons.cancel
                                : Icons.check_circle,
                            color: addressProvider.selectedAddress == null
                                ? Colors.red
                                : Colors.green,
                          ),
                        )
                      ],
                    ),
                    UIHelper.horizontalSpaceMedium(),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            addressProvider.selectedAddress?.label ??
                                'Deliver to Other',
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .copyWith(fontSize: 16.0),
                          ),
                          Text(
                            addressProvider.selectedAddress != null
                                ? '${addressProvider.selectedAddress!.street}, ${addressProvider.selectedAddress!.city},\n ${addressProvider.selectedAddress!.state}, ${addressProvider.selectedAddress!.zipCode}'
                                : 'Tap to select address',
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                    InkWell(
                      child: Row(
                        children: [
                          Text(
                            'Address',
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(color: Colors.grey),
                          ),
                          Icon(
                            Icons.keyboard_arrow_down_sharp,
                            color: Colors.grey,
                          ),
                        ],
                      ),
                      onTap: () async {
                        final selectedAddress =
                            await showModalBottomSheet<AddressModel>(
                          context: context,
                          isScrollControlled:
                              true, // Enables full height control
                          builder: (BuildContext context) {
                            return DraggableScrollableSheet(
                              expand: false,
                              initialChildSize: 0.7,
                              minChildSize: 0.5,
                              maxChildSize: 1.0,
                              builder: (context, scrollController) {
                                return AddressListPage();
                              },
                            );
                          },
                        );
                        if (selectedAddress != null) {
                          addressProvider.setAddress(selectedAddress);
                        }
                      },
                    ),
                    UIHelper.verticalSpaceMedium(),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(10.0),
                      color: Colors.grey[200],
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "${euro} ${items.first.totalPrice.toString() ?? 0.0} /-",
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .copyWith(fontSize: 16.0),
                          ),
                          // UIHelper.verticalSpaceExtraSmall(),
                          // Text(
                          //   'VIEW DETAIL BILL',
                          //   style: Theme.of(context)
                          //       .textTheme
                          //       .titleSmall!
                          //       .copyWith(color: Colors.blue, fontSize: 13.0),
                          // ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () async {
                        if (addressProvider.selectedAddress == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Please select an address first!"),
                            ),
                          );
                        } else {
                          makePayment();
                          // placeOrder();
                          debugPrint(
                              provider.cartItems.first.totalPrice.toString());
                        }
                      },
                      child: Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(10.0),
                        color: Colors.green,
                        height: 58.0,
                        child: Text(
                          'PROCEED TO PAY',
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall!
                              .copyWith(color: Colors.white),
                        ),
                      ),
                    ),
                  )
                ],
              )
            ],
          );
  }

  Future<void> placeOrder() async {
    final addressProvider =
        Provider.of<AddressProvider>(context, listen: false);
    final provider = context.read<CartProvider>();
    final items = provider.cartItems;

    if (items.isEmpty || items.first.foodItems!.isEmpty ?? true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Your cart is empty!'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    Map<String, String> data = {
      'cartId': items.first.id.toString(),
      'addressId': addressProvider.selectedAddress!.id,
      'phone': '1234567890',
      'paidThrough': 'card',
    };

    debugPrint("Cart Update API Request: $data");

    try {
      final response =
          await NetworkUtil.post(NetworkUtil.PLACE_ORDER_URL, body: data);

      debugPrint("Place Order Response Status: ${response.statusCode}");
      debugPrint("Place Order Response Body: ${response.body}");

      if (response.statusCode == 201) {
        // ✅ Extract data from response
        final responseData = json.decode(response.body);
        final orderDetails = responseData['data']['orderDetails'];

        final AddOrderController addOrderController =
            Get.find<AddOrderController>();

        // ✅ Prepopulate the controller with the response data
        addOrderController.idController.text = orderDetails['_id'].toString();
        addOrderController.nameController.text = orderDetails['phone'];
        addOrderController.amountController.text =
            orderDetails['totalAmount'].toString();

        addOrderController.selectedLocation = LatLng(
          double.parse(orderDetails['address']['lat'].toString()),
          double.parse(orderDetails['address']['lng'].toString()),
        );

        debugPrint("----------------------\nOrder ID : " +
            orderDetails['_id'].toString());
        debugPrint("Phone Number : " + orderDetails['phone']);
        debugPrint("Total amount : " + orderDetails['totalAmount'].toString());
        debugPrint("Latitude : " + orderDetails['address']['lat'].toString());
        debugPrint("Longitude : " +
            orderDetails['address']['lng'].toString() +
            "\n------------------------------");

        // ✅ Call the `addOrder()` method to save the data in Firestore
        addOrderController.addOrder(context);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Order placed successfully'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
        deleteCart();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to place order: ${response.body}'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      debugPrint("Error placing order: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> deleteCart() async {
    final provider = context.read<CartProvider>();
    final cartId = provider.cartItems.first.id;

    try {
      final response =
          await NetworkUtil.delete('${NetworkUtil.DELETE_CART_URL}/$cartId');

      debugPrint("Response Status: ${response.statusCode}");
      debugPrint("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        // ScaffoldMessenger.of(context).showSnackBar(
        //   const SnackBar(
        //     content: Text('Cart deleted successfully!'),
        //     backgroundColor: Colors.green,
        //     duration: Duration(seconds: 2),
        //   ),
        // );

        // Refresh cart data after deletion
        await provider.fetchCartData();
      } else {
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(
        //     content: Text('Failed to delete cart: ${response.body}'),
        //     backgroundColor: Colors.red,
        //     duration: Duration(seconds: 2),
        //   ),
        // );
      }
    } catch (error) {
      debugPrint("Error deleting cart: $error");

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error deleting cart: $error'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }
}
