import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Utils/Network_Utils.dart';
import '../../providers/favorites_provider.dart';
import '../../utils/ui_helper.dart';
import '../../widgets/veg_badge_view.dart';
import '../cart/components/add_to_cart_button.dart';
import '../../models/API_models/favorites_model.dart';
import '../restaurant/restaurant_detail_screen.dart';
import 'favorite_button.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({Key? key}) : super(key: key);

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  int cartQuantity = 0;

  void _updateCartQuantity(int quantity) {
    setState(() {
      cartQuantity = quantity;
    });
  }

  @override
  void initState() {
    super.initState();

    /// Fetch favorite restaurants when the page loads
    Future.delayed(Duration.zero, () {
      Provider.of<FavoriteProvider>(context, listen: false)
          .fetchFavoriteFoods();
    });
  }

  @override
  Widget build(BuildContext context) {
    final favoriteProvider = Provider.of<FavoriteProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite Foods'),
      ),
      body: favoriteProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : favoriteProvider.favoriteFoods.isEmpty
              ? const Center(child: Text("No Favorites Found"))
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.8,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: favoriteProvider.favoriteFoods.length,
                    itemBuilder: (context, index) {
                      final FavoriteRestaurant restaurant =
                          favoriteProvider.favoriteFoods[index];

                      /// Null safety and default values
                      final imageUrl = restaurant.hotelDetails?.images?.hotelMainImage
                                  .isNotEmpty ??
                              false
                          ? '${NetworkUtil.base_url}${restaurant.hotelDetails?.images?.hotelMainImage.first}'
                          : 'assets/images/noImage.png';

                      final restaurantName = restaurant.hotelDetails?.name ?? 'Unknown';
                      '₹${(restaurant.ratings?.averageRating ?? 0).toStringAsFixed(2)}';
                      final restaurantId = restaurant.id;

                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RestaurantDetailScreen(restaurantId: restaurant.id),
                            ),
                          );
                        },
                        child: Card(
                          color: Colors.white,
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              Expanded(
                                child: Image.network(
                                  imageUrl,
                                  fit: BoxFit.cover,
                                  loadingBuilder:
                                      (context, child, loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return const Center(
                                        child: CircularProgressIndicator());
                                  },
                                  errorBuilder: (context, error, stackTrace) {
                                    return Image.asset(
                                      'assets/images/noImage.png',
                                      fit: BoxFit.cover,
                                    );
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        // const VegBadgeView(),
                                        // UIHelper.horizontalSpaceExtraSmall(),
                                        Flexible(
                                          child: Text(
                                            restaurantName,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        FavoriteButton(restaurantId: restaurant.id),
                                      ],
                                    ),
                                    Text(
                                      restaurant.hotelDetails!.description,
                                      maxLines: 4,
                                      overflow: TextOverflow.visible,
                                      style: const TextStyle(),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}
