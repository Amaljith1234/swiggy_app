import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/cart_provider.dart';
import '../../utils/ui_helper.dart';
import '../../widgets/custom_divider_view.dart';

class OrderView extends StatefulWidget {
  @override
  _OrderViewState createState() => _OrderViewState();
}

class _OrderViewState extends State<OrderView> {
  int itemCount = 0;

  @override
  void initState() {
    super.initState();
    Provider.of<CartProvider>(context, listen: false).fetchCartData();
  }

  Future<bool> _updateCartItem(String foodId, String cartId, int newQty) async {
    bool success = await CartService.updateCartItem(
      context: context,
      foodId: foodId,
      cartId: cartId,
      qty: newQty,
    );

    if (success) {
      Provider.of<CartProvider>(context, listen: false).fetchCartData();
      setState(() {});
    }
    return success;
  }

  @override
  Widget build(BuildContext context) {
    final subtitleStyle = Theme.of(context).textTheme.bodyLarge;

    return Consumer<CartProvider>(
      builder: (context, provider, child) {
        if (provider.cartItems.isEmpty) {
          return Center(child: Text(''));
        }

        return ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          // Prevents double scrolling issues
          itemCount: provider.cartItems.length,
          itemBuilder: (context, index) {
            final cartItem = provider.cartItems[index];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //restaurant name
                UIHelper.verticalSpaceSmall(),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15),
                  child: Text(
                    cartItem.restaurantDetails!.name.toString(),
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),

                //food list
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  // Prevent nested scrolling issues
                  itemCount: cartItem.foodItems?.length ?? 0,
                  itemBuilder: (context, foodIndex) {
                    final foodItem = cartItem.foodItems![foodIndex];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 5.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                foodItem.foodDetails?.name ?? "Food Item",
                                style: subtitleStyle,
                                overflow: TextOverflow.fade,
                                maxLines: 2,
                              ),
                              UIHelper.horizontalSpaceSmall(),
                              Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5.0),
                                height: 35.0,
                                width: 100.0,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.grey,
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    InkWell(
                                      child: const Icon(Icons.remove,
                                          color: Colors.green),
                                      onTap: () {
                                        if (foodItem.qty! >= 0) {
                                          _updateCartItem(
                                              foodItem.foodId ?? '',
                                              cartItem.id ?? '',
                                              foodItem.qty! - 1);
                                        }
                                      },
                                    ),
                                    const Spacer(),
                                    foodItem.qty == null
                                        ? CircularProgressIndicator()
                                        : Text(
                                            '${foodItem.qty}',
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleSmall!
                                                .copyWith(fontSize: 16.0),
                                          ),
                                    const Spacer(),
                                    InkWell(
                                      child: const Icon(Icons.add,
                                          color: Colors.green),
                                      onTap: () {
                                        _updateCartItem(
                                            foodItem.foodId ?? '',
                                            cartItem.id ?? '',
                                            foodItem.qty! + 1);
                                      },
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                          UIHelper.verticalSpaceSmall(),
                        ],
                      ),
                    );
                  },
                ),
                CustomDividerView(
                  dividerHeight: 1.0,
                  color: Colors.grey[400],
                ),
                UIHelper.verticalSpaceMedium(),
              ],
            );
          },
        );
      },
    );
  }
}
