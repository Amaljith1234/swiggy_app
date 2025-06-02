import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Utils/Network_Utils.dart';
import '../../models/API_models/search_model.dart';
import '../../providers/cart_provider.dart';
import '../../providers/food_provider.dart';
import '../../providers/search_provider.dart';
import '../cart/components/add_to_cart_button.dart';
import '../view_cart_items.dart';

class SearchFoodListItemView extends StatefulWidget {
  final SearchFoodItem food;

  const SearchFoodListItemView({Key? key, required this.food})
      : super(key: key);

  @override
  State<SearchFoodListItemView> createState() => _SearchFoodListItemViewState();
}

class _SearchFoodListItemViewState extends State<SearchFoodListItemView> {
  // int itemCount = 0;
  int cartQuantity = 0;

  void _updateCartQuantity(int quantity) {
    setState(() {
      cartQuantity = quantity;
    });
  }

  void _showFoodDetails(BuildContext context, String foodId) async{
    final foodProvider = Provider.of<FoodProvider>(context, listen: false);

    // Fetch food details before opening the modal
    await foodProvider.fetchFoodDetails(foodId);

    // Check if food details are available
    if (foodProvider.foodDetails == null) {
      debugPrint("Food details not available");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Food details not found.")),
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        final food = foodProvider.foodDetails!;
          // (
              // (item) => item.id == foodId,
          // orElse: () => FoodDetails(), // Handle case when food is not found
        // );
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: _buildFoodImage(),
              ),
              const SizedBox(height: 10),
              Text(
                food.name ?? "No Name Available" ,
                style:
                    const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                food.description ?? "No description",
                style: TextStyle(fontSize: 16, color: Colors.grey[700]),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '₹ ${food.price?.toStringAsFixed(2)}',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  CartAddButton(
                    onQuantityChanged: _updateCartQuantity,
                    quantity: food.cartEntry!.qty!.toInt(),
                    foodId: widget.food.foodId,
                    restaurantId: widget.food.restaurantId,
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFoodImage() {
    bool hasValidImage =
        widget.food.images.isNotEmpty && widget.food.images.first.isNotEmpty;
    String imageUrl = hasValidImage
        ? '${NetworkUtil.base_url}${widget.food.images.first}'
        : '';

    return hasValidImage
        ? Image.network(
            imageUrl,
            height: 200,
            width: double.infinity,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return const Center(child: CircularProgressIndicator());
            },
            errorBuilder: (context, error, stackTrace) {
              return Image.asset(
                'assets/images/noImage.png',
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              );
            },
          )
        : Image.asset(
            'assets/images/noImage.png',
            height: 200,
            width: double.infinity,
            fit: BoxFit.cover,
          );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            height: 170,
            child: InkWell(
              onTap: () => _showFoodDetails(context, widget.food.foodId),
              child: Card(
                color: Colors.white,
                elevation: 2,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.food.foodItemName,
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  widget.food.foodDescription,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  '₹${widget.food.price.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 180,
                        child: Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Container(
                                height: 120,
                                width: 140,
                                color: Colors.grey[200],
                                child: _buildFoodImage(),
                              ),
                            ),
                            Positioned(
                              top: 100,
                              left: 5,
                              child: CartAddButton(
                                onQuantityChanged: _updateCartQuantity,
                                quantity: cartQuantity,
                                foodId: widget.food.foodId,
                                restaurantId: widget.food.restaurantId,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
