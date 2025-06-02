import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/resturant_provider.dart';
import '../../utils/Network_Utils.dart';
import '../../utils/ui_helper.dart';
import '../../pages/restaurant/restaurant_detail_screen.dart';

class SearchFoodListItemView extends StatefulWidget {
  const SearchFoodListItemView({Key? key}) : super(key: key);

  @override
  State<SearchFoodListItemView> createState() => _SearchFoodListItemViewState();
}

class _SearchFoodListItemViewState extends State<SearchFoodListItemView> {

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<RestaurantProvider>(context, listen: false);
    provider.fetchRestaurants();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<RestaurantProvider>(
      builder: (context, provider, child) {
        if (provider.restaurantItems.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final restaurant = provider.restaurantItems;

        return SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.all(10.0),
            child: Column(
              children: restaurant.map((restroItem) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 10.0),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => RestaurantDetailScreen(restaurantId: restroItem.id.toString(),)));
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Colors.white,
                            boxShadow: const <BoxShadow>[
                              BoxShadow(
                                color: Colors.grey,
                                blurRadius: 4.0,
                              ),
                            ],
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: Image.network(
                           "${NetworkUtil.base_url}${restroItem.image}",
                            height: 80.0,
                            width: 80.0,
                            fit: BoxFit.cover,
                          ),
                        ),
                        UIHelper.horizontalSpaceSmall(),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              // Access the restaurant's name
                              Text(
                                restroItem.name.toString(), // Provided name from RestaurantProvider
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall!
                                    .copyWith(fontSize: 15.0),
                              ),
                              Text(
                                restroItem.description.toString().substring(0,18), // Use the correct property or a fallback value
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(color: Colors.grey[600], fontSize: 13.5),
                              ),
                              UIHelper.verticalSpaceSmall(),
                              Row(
                                children: <Widget>[
                                  Icon(
                                    Icons.star,
                                    size: 14.0,
                                    color: Colors.grey[600],
                                  ),
                                  Text(restroItem.ratings.toString().substring(0,4)), // Provided rating from RestaurantProvider
                                ],
                              ),

                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}
