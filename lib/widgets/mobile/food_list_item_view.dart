import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:swiggy_app/utils/Network_Utils.dart';

import '../../models/spotlight_best_top_food.dart';
import '../../providers/home_provider.dart';
import '../../utils/ui_helper.dart';

class RestaurantListView extends StatelessWidget {
  final Function(String) onTap;

  const RestaurantListView({
    Key? key,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeDetailsProvider>(builder: (context, provider, child) {
      if (provider.popularRestaurant.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }

      final popularRestaurant = provider.popularRestaurant;

      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: popularRestaurant.map((popularResto) {
            return InkWell(
              onTap: () => onTap(popularResto.id),
              child: Row(children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.white,
                      boxShadow: const <BoxShadow>[
                        BoxShadow(
                          color: Colors.grey,
                          blurRadius: 5.0,
                        )
                      ],
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Image.network(
                      "${NetworkUtil.base_url}${popularResto.images[0]}",
                      width: 80.0,
                      height: 80.0,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                UIHelper.horizontalSpaceMedium(),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      popularResto.name,
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall!
                          .copyWith(fontSize: 18.0),
                    ),
                    Text('${popularResto.description.substring(0,20)}...',
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge!
                            .copyWith(
                                color: Colors.grey[800], fontSize: 13.5)),
                    UIHelper.verticalSpaceExtraSmall(),
                    Text(
                      popularResto.mainOfferTagLine
                              ?.toString()
                              .substring(0, 10) ??
                          "------",
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(color: Colors.red[900], fontSize: 13.0),
                    ),
                    UIHelper.verticalSpaceSmall(),
                    Row(
                      children: <Widget>[
                        Icon(
                          Icons.star,
                          size: 14.0,
                          color: Colors.grey[600],
                        ),
                        Text(
                          "${popularResto.averageRating.toString().substring(0, 4)}  ----  ${popularResto.mainOfferDeduction ?? "No"} Deduction",
                          // restaurant.ratingTimePrice
                        )
                      ],
                    )
                  ],
                )
              ]),
            );
          }).toList(),
        ),
      );
    });
  }
}
