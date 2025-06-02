import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:swiggy_app/views/mobile/swiggy/swiggy_screen.dart';
import '../../pages/Home/home_page.dart';
import '../../pages/cart/cart_screen.dart';
import '../../pages/search/search_screen.dart';
import '../../pages/view_cart_items.dart';
import '../../providers/cart_provider.dart';
import '../../utils/app_colors.dart';

class HomeBottomNavigationScreen extends StatefulWidget {
  int selectedIndex = 0;

  HomeBottomNavigationScreen({Key? key, this.selectedIndex = 0})
      : super(key: key);

  @override
  _HomeBottomNavigationScreenState createState() =>
      _HomeBottomNavigationScreenState();
}

class _HomeBottomNavigationScreenState
    extends State<HomeBottomNavigationScreen> {
  final List<Widget> _children = [
    HomePage(),
    const SwiggyScreen(),
    const SearchScreen(),
    const CartScreen(),
  ];

  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    this.selectedIndex = widget.selectedIndex;
  }

  @override
  Widget build(BuildContext context) {
    final labelTextStyle =
        Theme.of(context).textTheme.titleSmall!.copyWith(fontSize: 8.0);
    return Scaffold(
        body: _children[selectedIndex],
        bottomNavigationBar:
            Consumer<CartProvider>(builder: (context, cartProvider, child) {
          bool isCartEmpty = cartProvider.cartItems.isEmpty;
          bool isOnCartPage = selectedIndex == 3;

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (!isCartEmpty && !isOnCartPage)
                SizedBox(
                  height: 70, // Fixed height for the cart section
                  child: ViewCartItems(),
                ),
              BottomNavigationBar(
                backgroundColor: Colors.white,
                type: BottomNavigationBarType.fixed,
                selectedItemColor: darkOrange,
                unselectedItemColor: Colors.grey,
                currentIndex: selectedIndex,
                selectedLabelStyle: labelTextStyle,
                unselectedLabelStyle: labelTextStyle,
                onTap: (index) {
                  setState(() {
                    selectedIndex = index;
                  });
                },
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home),
                    label: 'Folo',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.fastfood),
                    label: 'Food',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.search),
                    label: 'SEARCH',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.add_shopping_cart),
                    label: 'CART',
                  ),
                ],
              ),
            ],
          );
        }));
  }
}
