import 'package:flutter/material.dart';
import 'package:swiggy_app/views/mobile/swiggy/restaurants/top_offers_data_items.dart';

import '../../../models/spotlight_best_top_food.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/ui_helper.dart';
import '../../../widgets/mobile/spotlight_best_top_food_item.dart';


class TopOffersViews extends StatelessWidget {
  final restaurants = SpotlightBestTopFood.getTopRestaurants();

  TopOffersViews({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    const Icon(Icons.security),
                    UIHelper.horizontalSpaceExtraSmall(),
                    Text(
                      'Top Offers',
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium!
                          .copyWith(fontSize: 20.0),
                    ),
                    const Spacer(),
                    Row(
                      children: <Widget>[
                        // Text(
                        //   'SEE ALL',
                        //   style: Theme.of(context)
                        //       .textTheme
                        //       .bodyLarge!
                        //       .copyWith(fontWeight: FontWeight.bold),
                        // ),
                        // UIHelper.horizontalSpaceExtraSmall(),
                        // ClipOval(
                        //   child: Container(
                        //     alignment: Alignment.center,
                        //     color: swiggyOrange,
                        //     height: 25.0,
                        //     width: 25.0,
                        //     child: const Icon(
                        //       Icons.arrow_forward_ios,
                        //       size: 12.0,
                        //       color: Colors.white,
                        //     ),
                        //   ),
                        // )
                      ],
                    )
                  ],
                ),
                UIHelper.verticalSpaceExtraSmall(),
                Text(
                  'Get 20-50% Off',
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(color: Colors.grey),
                ),
              ],
            ),
          ),
          UIHelper.verticalSpaceMedium(),
          LimitedBox(
            maxHeight: 270.0,
            child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: 1,
              itemBuilder: (context, index) => SizedBox(
                width: MediaQuery.of(context).size.width / 1.1,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TopOffersDataItemCard(
                        // restaurant: restaurants[index][0]
                    ),
                    // SpotlightBestTopFoodItem(
                        // restaurant: restaurants[index][1]
                    // )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
