import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/API_models/cart_model.dart';
import '../../../providers/cart_provider.dart';

class CartAddButton extends StatefulWidget {
  final int quantity;
  final String foodId;
  final String restaurantId;
  final Function(int) onQuantityChanged;

  const CartAddButton({
    Key? key,
    required this.quantity,
    required this.foodId,
    required this.restaurantId,
    required this.onQuantityChanged,
  }) : super(key: key);

  @override
  State<CartAddButton> createState() => _CartAddButtonState();
}

class _CartAddButtonState extends State<CartAddButton> {
  int cartQuantity = 0;
  String? cartId;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    cartQuantity =
        widget.quantity > 0 ? widget.quantity : 0; // Proper initialization
  }

  /// Function to safely extract cartId
  String? _getCartId(List<CartItem> cartItems, String foodId) {
    for (var item in cartItems) {
      if (item.foodItems != null) {
        for (var food in item.foodItems!) {
          if (food.foodId == foodId) {
            return item.id; // Return the matching cart ID
          }
        }
      }
    }
    return null; // Return null if no match is found
  }

  Future<void> _increment() async {
    if (isLoading) return;

    setState(() => isLoading = true);

    final cartProvider = Provider.of<CartProvider>(context, listen: false);

    try {
      if (cartQuantity == 0) {
        // First time adding item
        bool success = await CartService.addToCart(
          context: context,
          foodId: widget.foodId,
          restaurantId: widget.restaurantId,
          qty: 1,
        );

        if (success) {
          await cartProvider.fetchCartData();
          cartId = _getCartId(cartProvider.cartItems, widget.foodId);

          setState(() {
            cartQuantity = 1;
            widget.onQuantityChanged(cartQuantity);
          });
        }
      } else {
        // Increment existing item
        int newQty = cartQuantity + 1;

        bool success = await CartService.updateCartItem(
          context: context,
          foodId: widget.foodId,
          cartId: cartId!,
          qty: newQty,
        );

        if (success) {
          setState(() => cartQuantity = newQty);
          widget.onQuantityChanged(cartQuantity);
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add item: $e')),
      );
    }

    setState(() => isLoading = false);
  }

  Future<void> _decrement() async {
    if (cartQuantity == 0 || isLoading) return;

    setState(() => isLoading = true);

    final cartProvider = Provider.of<CartProvider>(context, listen: false);

    try {
      int newQty = cartQuantity - 1;

      if (newQty == 0) {
        // Remove item from cart
        bool success = await CartService.updateCartItem(
          context: context,
          foodId: widget.foodId,
          cartId: cartId!,
          qty: 0,
        );

        if (success) {
          await cartProvider.fetchCartData();
          setState(() {
            cartQuantity = 0;
            cartId = null;
            widget.onQuantityChanged(cartQuantity);
          });
        }
      } else {
        // Decrement existing item
        bool success = await CartService.updateCartItem(
          context: context,
          foodId: widget.foodId,
          cartId: cartId!,
          qty: newQty,
        );

        if (success) {
          setState(() => cartQuantity = newQty);
          widget.onQuantityChanged(cartQuantity);
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to remove item: $e')),
      );
    }

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.green,
      child: SizedBox(
        height: 40,
        width: 122,
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(color: Colors.white))
            : cartQuantity == 0
                ? TextButton(
                    child: const Text('Add',
                        style: TextStyle(color: Colors.white)),
                    onPressed: _increment,
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove, color: Colors.white),
                        onPressed: _decrement,
                      ),
                      Text(cartQuantity.toString(),
                          style: const TextStyle(
                              color: Colors.white, fontSize: 20)),
                      IconButton(
                        icon: const Icon(Icons.add, color: Colors.white),
                        onPressed: _increment,
                      ),
                    ],
                  ),
      ),
    );
  }
}
