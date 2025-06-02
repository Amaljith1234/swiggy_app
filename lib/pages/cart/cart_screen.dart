import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:swiggy_app/providers/cart_provider.dart';
import 'package:swiggy_app/providers/orders_provider.dart';
import 'package:swiggy_app/views/mobile/home_bottom_navigation_screen.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/ui_helper.dart';
import '../../../widgets/custom_divider_view.dart';
import '../../../widgets/veg_badge_view.dart';
import '../../providers/address_provider.dart';
import '../account/account_screen.dart';
import '../search/search_screen.dart';
import 'cart_address_payment_view.dart';
import 'cart_bill_details_view.dart';
import 'cart_order_view.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchCartData();
  }

  Future<void> _fetchCartData() async {
    try {
      await Provider.of<CartProvider>(context, listen: false).fetchCartData();
    } catch (e) {
      debugPrint("Error fetching cart data: $e");
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false; // Update loading state
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final isCartEmpty = cartProvider.cartItems.isEmpty;

    return Scaffold(
      body: SafeArea(
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : isCartEmpty
                ? Container(
                    width: double.infinity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/emptyCart.jpeg',
                          height: 200.0,
                          width: 250.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Your Cart is",
                              style: GoogleFonts.nunito(
                                  textStyle: TextStyle(
                                fontSize: 35,
                              )),
                            ),
                            Text(
                              " Empty!",
                              style: GoogleFonts.nunito(
                                  textStyle: TextStyle(
                                      fontSize: 35,
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Text(
                            "Must add items on the cart before you proceed to pay"),
                        SizedBox(height: 25),
                        SizedBox(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        HomeBottomNavigationScreen(
                                            selectedIndex: 2)),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Colors.red, // Change button color
                              foregroundColor:
                                  Colors.white, // Change text color
                            ),
                            child: Text("Browse product"),
                          ),
                        ),
                        SizedBox(height: 20),
                        Text("OR"),
                        TextButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AccountScreen()));
                            },
                            child: Text(
                              'see your order details',
                              style:
                              TextStyle(color: Colors.red[90], fontSize: 12),
                            ))
                      ],
                    ),
                  )
                : Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          child: Container(
                            margin: const EdgeInsets.only(top: 15.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                OrderView(),
                                const CustomDividerView(dividerHeight: 15.0),
                                _CouponView(),
                                const CustomDividerView(dividerHeight: 15.0),
                                BillDetailView(),
                                _DecoratedView(),
                              ],
                            ),
                          ),
                        ),
                      ),
                      CartPaymentView(),
                    ],
                  ),
      ),
    );
  }
}

class _CouponView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: <Widget>[
          Icon(Icons.local_offer, size: 20.0, color: Colors.grey[700]),
          UIHelper.horizontalSpaceMedium(),
          Text(
            'APPLY COUPON',
            style: Theme.of(context)
                .textTheme
                .titleSmall!
                .copyWith(fontSize: 16.0),
          ),
          const Spacer(),
          const Icon(Icons.keyboard_arrow_right, color: Colors.grey),
        ],
      ),
    );
  }
}

class _DecoratedView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100.0,
      color: Colors.grey[200],
    );
  }
}
