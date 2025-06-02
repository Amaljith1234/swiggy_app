import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';

import '../../Utils/Network_Utils.dart';
import '../../models/API_models/restaurant_model.dart';
import '../../models/restaurant_detail.dart';
import '../../providers/cart_provider.dart';
import '../../providers/favorites_provider.dart';
import '../../utils/ui_helper.dart';
import '../../widgets/custom_divider_view.dart';
import '../../widgets/veg_badge_view.dart';
import '../cart/components/add_to_cart_button.dart';
import '../favorites/favorite_button.dart';
import '../view_cart_items.dart';

class RestaurantDetailScreen extends StatefulWidget {
  final String restaurantId;

  const RestaurantDetailScreen({Key? key, required this.restaurantId})
      : super(key: key);

  @override
  State<RestaurantDetailScreen> createState() => _RestaurantDetailScreenState();
}

class _RestaurantDetailScreenState extends State<RestaurantDetailScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0.0,
        actions: <Widget>[
          FavoriteButton(restaurantId: widget.restaurantId),
          UIHelper.horizontalSpaceSmall(),
          // const Icon(Icons.search),
          UIHelper.horizontalSpaceSmall(),
        ],
      ),
      body: _OrderNowView(
        restaurantId: widget.restaurantId,
      ),
      bottomNavigationBar: Consumer<CartProvider>(
        builder: (context, cartProvider, child) {
          bool isCartEmpty = cartProvider.cartItems.isEmpty;

          return isCartEmpty
              ? const SizedBox.shrink() // Hides the cart section when empty
              : SizedBox(
                  height: 70, // Fixed height for the cart section
                  child: ViewCartItems(),
                );
        },
      ),
    );
  }
}

class _OrderNowView extends StatefulWidget {
  final String restaurantId;

  const _OrderNowView({Key? key, required this.restaurantId}) : super(key: key);

  @override
  State<_OrderNowView> createState() => _OrderNowViewState();
}

class _OrderNowViewState extends State<_OrderNowView> {
  static const int _pageSize = 20;

  Restaurant? _restaurant;
  Restaurant? get restaurant => _restaurant;

  List<FoodItem> _recommendedFoods = [];
  List<FoodItem> get recommendedFoods => _recommendedFoods;

  final PagingController<int, FoodItem> restaurantDetailsPagingControl =
      PagingController(firstPageKey: 1);

  Future<void> fetchRestaurantDetails(String restaurantId, int pageKey) async {
    try {
      final response = await NetworkUtil.get(
          '${NetworkUtil.RESTAURANT_DETAILS_URL}/${widget.restaurantId}/${pageKey}/$_pageSize');

      debugPrint('restaurant details status code : ${response.statusCode}');
      debugPrint('restaurant details body : ${response.body}');

      if (response.statusCode == 200 && response.body.isNotEmpty) {
        final Map<String, dynamic> result = json.decode(response.body);

        if (result['data'] != null) {
          setState(() {
            _restaurant = Restaurant.fromJson(result['data']);
            final isLastPage = _recommendedFoods.length < _pageSize;
            _recommendedFoods = (result['data']['foodItems'] as List)
                .map((item) => FoodItem.fromJson(item))
                .toList();
          });
          log("Fetched restaurant details successfully");
        } else {
          log("API response error: ${result['message']}");
        }
      } else {
        log("Failed to fetch restaurant: Status Code ${response.statusCode}");
      }
    } catch (e) {
      log("Error fetching restaurant details: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    fetchRestaurantDetails(widget.restaurantId, 1);
  }

  @override
  Widget build(BuildContext context) {
    return _restaurant == null
        ? Center(
            child: CircularProgressIndicator(),
          )
        : SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        _restaurant?.restaurantName ?? "Loading....",
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(
                            fontWeight: FontWeight.bold, fontSize: 16.0),
                      ),
                      UIHelper.verticalSpaceSmall(),
                      Text(_restaurant?.description ?? "",
                          style: Theme.of(context).textTheme.bodyLarge),
                      UIHelper.verticalSpaceExtraSmall(),
                      Text(
                          '${_restaurant!.location.address}, ${_restaurant?.location.city}, ${_restaurant!.location.state}, ${_restaurant!.location.zipcode}',
                          style: Theme.of(context).textTheme.bodyLarge),
                      UIHelper.verticalSpaceMedium(),
                      const CustomDividerView(dividerHeight: 1.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          _buildVerticalStack(
                              context,
                              _restaurant?.ratings.toString().substring(0, 3) ??
                                  "",
                              'Packaging 80%'),
                          _buildVerticalStack(
                              context, '29 mins', 'Delivery Time'),
                          // _buildVerticalStack(context, '${euro} ${_restaurant?.}', 'For Two'),
                        ],
                      ),
                      const CustomDividerView(dividerHeight: 1.0),
                      UIHelper.verticalSpaceMedium(),
                      Column(
                        children: <Widget>[
                          _buildOfferTile(context,
                              '30% off up to Rs75 | Use code SWIGGYIT'),
                          _buildOfferTile(context,
                              '20% off up to Rs100 with SBI credit cards, once per week | Use code 100SBI')
                        ],
                      ),
                      UIHelper.verticalSpaceSmall(),
                    ],
                  ),
                ),
                const CustomDividerView(dividerHeight: 15.0),
                // Container(
                //   height: 80.0,
                //   padding: const EdgeInsets.all(10.0),
                //   child: Column(
                //     mainAxisAlignment: MainAxisAlignment.center,
                //     children: <Widget>[
                //       Expanded(
                //         child: Row(
                //           crossAxisAlignment: CrossAxisAlignment.center,
                //           children: <Widget>[
                //             const Icon(
                //               Icons.filter_vintage,
                //               color: Colors.green,
                //               size: 12.0,
                //             ),
                //             UIHelper.horizontalSpaceExtraSmall(),
                //             Text('PURE VEG',
                //                 style: Theme.of(context)
                //                     .textTheme
                //                     .titleSmall!
                //                     .copyWith(
                //                         fontWeight: FontWeight.bold,
                //                         fontSize: 16.0))
                //           ],
                //         ),
                //       ),
                //       const CustomDividerView(
                //           dividerHeight: 0.5, color: Colors.black)
                //     ],
                //   ),
                // ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    'Recommended',
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall!
                        .copyWith(fontSize: 18.0),
                  ),
                ),
                CustomDividerView(dividerHeight: 0.5, color: Colors.black),
                UIHelper.verticalSpaceMedium(),
                _RecommendedFoodView(
                    recommendedFoods: recommendedFoods, restaurant: restaurant),
                // const CustomDividerView(dividerHeight: 15.0),
                // _FoodListView(
                //   title: 'Breakfast',
                //   foods: RestaurantDetail.getBreakfast(),
                // ),
                // const CustomDividerView(dividerHeight: 15.0),
                // _FoodListView(
                //   title: 'All Time Favourite',
                //   foods: RestaurantDetail.getAllTimeFavFoods(),
                // ),
                // const CustomDividerView(dividerHeight: 15.0),
                // _FoodListView(
                //   title: 'Kozhukattaiyum & Paniyarams',
                //   foods: RestaurantDetail.getOtherDishes(),
                // )
              ],
            ),
          );
  }

  Padding _buildOfferTile(BuildContext context, String desc) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Row(
          children: <Widget>[
            Icon(Icons.local_offer, color: Colors.red[600], size: 15.0),
            UIHelper.horizontalSpaceSmall(),
            Flexible(
              child: Text(
                desc,
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(fontSize: 13.0),
              ),
            )
          ],
        ),
      );

  Expanded _buildVerticalStack(
          BuildContext context, String title, String subtitle) =>
      Expanded(
        child: SizedBox(
          height: 60.0,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                title,
                style: Theme.of(context)
                    .textTheme
                    .titleSmall!
                    .copyWith(fontSize: 15.0),
              ),
              UIHelper.verticalSpaceExtraSmall(),
              Text(subtitle,
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(fontSize: 13.0))
            ],
          ),
        ),
      );
}


class _RecommendedFoodView extends StatefulWidget {
  final List<FoodItem> recommendedFoods;
  final Restaurant? restaurant;

  const _RecommendedFoodView({
    Key? key,
    required this.recommendedFoods,
    required this.restaurant,
  }) : super(key: key);

  @override
  State<_RecommendedFoodView> createState() => _RecommendedFoodViewState();
}

class _RecommendedFoodViewState extends State<_RecommendedFoodView> {
  int cartQuantity = 0;

  void _updateCartQuantity(int quantity) {
    setState(() {
      cartQuantity = quantity;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.recommendedFoods.isEmpty) {
      return const Center(child: Text("No Recommendation"));
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: widget.recommendedFoods.length,
      itemBuilder: (context, index) {
        final food = widget.recommendedFoods[index];

        return SizedBox(
          height: 180,
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
                              food.name,
                              style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                            UIHelper.verticalSpaceExtraSmall(),
                            Text(
                              food.description,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 13),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              '₹${food.price.toStringAsFixed(2)}',
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
                            child: _buildFoodImage(context, food),
                          ),
                        ),
                        Positioned(
                          top: 100,
                          left: 5,
                          child: CartAddButton(
                            onQuantityChanged: _updateCartQuantity,
                            quantity: cartQuantity,
                            foodId: food.foodId,
                            restaurantId: widget.restaurant!.userId,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ✅ Corrected the image rendering logic
  Widget _buildFoodImage(BuildContext context, FoodItem food) {
    final image = food.image;
    bool hasValidImage = image != null && image.isNotEmpty;

    String imageUrl = hasValidImage
        ? '${NetworkUtil.base_url}$image'
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
}

// class AddBtnView extends StatelessWidget {
//   const AddBtnView({
//     Key? key,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 25.0),
//       decoration: BoxDecoration(
//         border: Border.all(color: Colors.grey),
//       ),
//       child: Text(
//         'ADD',
//         style: Theme.of(context)
//             .textTheme
//             .titleSmall!
//             .copyWith(color: Colors.green),
//       ),
//     );
//   }
// }

// class _FoodListView extends StatelessWidget {
//   const _FoodListView({
//     Key? key,
//     required this.title,
//     required this.foods,
//   }) : super(key: key);
//
//   final String title;
//   final List<RestaurantDetail> foods;
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: <Widget>[
//           UIHelper.verticalSpaceMedium(),
//           Text(
//             title,
//             style: Theme.of(context)
//                 .textTheme
//                 .titleSmall!
//                 .copyWith(fontSize: 18.0),
//           ),
//           ListView.builder(
//             shrinkWrap: true,
//             itemCount: foods.length,
//             physics: const NeverScrollableScrollPhysics(),
//             itemBuilder: (context, index) => Container(
//               padding: const EdgeInsets.symmetric(vertical: 10.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: <Widget>[
//                   UIHelper.verticalSpaceSmall(),
//                   Row(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: <Widget>[
//                       const VegBadgeView(),
//                       UIHelper.horizontalSpaceMedium(),
//                       Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.stretch,
//                           children: <Widget>[
//                             Text(
//                               foods[index].title,
//                               style: Theme.of(context).textTheme.bodyLarge,
//                             ),
//                             UIHelper.verticalSpaceSmall(),
//                             Text(
//                               foods[index].price,
//                               style: Theme.of(context)
//                                   .textTheme
//                                   .bodyLarge!
//                                   .copyWith(fontSize: 14.0),
//                             ),
//                             UIHelper.verticalSpaceMedium(),
//                             Text(
//                               foods[index].desc,
//                               maxLines: 2,
//                               overflow: TextOverflow.ellipsis,
//                               style: Theme.of(context)
//                                   .textTheme
//                                   .bodyLarge!
//                                   .copyWith(
//                                     fontSize: 12.0,
//                                     color: Colors.grey[500],
//                                   ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       // const AddBtnView()
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }
