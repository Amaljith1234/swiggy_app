import 'package:flutter/material.dart';
import '../../../../models/API_models/home_model.dart';
import '../../../../providers/home_provider.dart';
import '../../../../utils/ui_helper.dart';
import '../../../../widgets/mobile/food_list_item_view.dart';
import '../../../../widgets/responsive.dart';
import '../../../../pages/restaurant/restaurant_detail_screen.dart';
import 'package:provider/provider.dart';

class RestaurantVerticalListView extends StatelessWidget {
  final String title;

  const RestaurantVerticalListView({
    Key? key,
    required this.title,
  })  : assert(title != ''),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final isTabletDesktop = Responsive.isTabletDesktop(context);

    return Consumer<HomeDetailsProvider>(
      builder: (context, provider, child) {
        if (provider.popularRestaurant.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        final popularRestaurants = provider.popularRestaurant;

        return Container(
          margin: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                title,
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium!
                    .copyWith(fontSize: 20.0),
              ),
              UIHelper.verticalSpaceMedium(),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 1,
                itemBuilder: (context, index) {
                  final restaurant = popularRestaurants[index];

                  return InkWell(
                    onTap: isTabletDesktop
                        ? null
                        : () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RestaurantDetailScreen(
                            restaurantId: restaurant.id,
                          ),
                        ),
                      );
                    },
                    child: RestaurantListView(
                      onTap: (id) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RestaurantDetailScreen(
                              restaurantId: id,
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
