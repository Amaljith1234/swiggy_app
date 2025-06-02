import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../Utils/AppUtils.dart';
import '../../utils/app_colors.dart';
import '../../utils/ui_helper.dart';
import '../../widgets/custom_divider_view.dart';
import '../../widgets/dotted_seperator_view.dart';

class PastOrderListView extends StatelessWidget {
  final List<String> restaurants = [
    'Sea Emperor',
    'Fireflies Restaurant',
    'Chai Truck',
  ];

  final List<String> foods = [
    'Pepper BBQ x 1',
    'Chicken Noodles x 1',
    'Milk Tea x 1',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        ListView.builder(
          shrinkWrap: true,
          itemCount: restaurants.length,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) => _PastOrdersListItemView(
            restaurant: restaurants[index],
            foodItem: foods[index],
          ),
        ),
        TextButton(
          child: Text(
            'VIEW MORE ORDERS',
            style: Theme.of(context)
                .textTheme
                .titleSmall!
                .copyWith(color: darkOrange),
          ),
          onPressed: () {},
        ),
        UIHelper.verticalSpaceSmall(),
        const CustomDividerView(),
        Row(
          children: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(left: 10.0),
              height: 50.0,
              child: Text(
                'LOGOUT',
                style: Theme.of(context)
                    .textTheme
                    .titleSmall!
                    .copyWith(fontSize: 16.0),
              ),
            ),
            const Spacer(),
            IconButton(
                icon: Icon(Icons.power_settings_new),
                onPressed: () async {
                  await AppUtil.logout(context);
                }
            ),
            UIHelper.horizontalSpaceSmall(),
          ],
        ),
        Container(
          alignment: Alignment.topCenter,
          padding: const EdgeInsets.only(top: 20.0),
          height: 130.0,
          color: Colors.grey[200],
          child: Text(
            'App Version v3.2.0',
            style: Theme.of(context)
                .textTheme
                .bodyLarge!
                .copyWith(color: Colors.grey[700], fontSize: 13.0),
          ),
        )
      ],
    );
  }
}

class _PastOrdersListItemView extends StatelessWidget {
  const _PastOrdersListItemView({
    Key? key,
    required this.restaurant,
    required this.foodItem,
  })  : assert(restaurant != '', foodItem != ''),
        super(key: key);

  final String restaurant;
  final String foodItem;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      restaurant,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    UIHelper.verticalSpaceExtraSmall(),
                    Text(
                      'Medavakkam',
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(fontSize: 12.0),
                    ),
                    UIHelper.verticalSpaceSmall(),
                    Row(
                      children: <Widget>[
                        const Text('Rs112'),
                        UIHelper.horizontalSpaceExtraSmall(),
                        Icon(Icons.keyboard_arrow_right,
                            color: Colors.grey[600])
                      ],
                    )
                  ],
                ),
                const Spacer(),
                Text('Delivered',
                    style: Theme.of(context).textTheme.titleSmall),
                UIHelper.horizontalSpaceSmall(),
                ClipOval(
                  child: Container(
                    padding: const EdgeInsets.all(2.2),
                    color: Colors.green,
                    child: const Icon(Icons.check,
                        color: Colors.white, size: 14.0),
                  ),
                )
              ],
            ),
          ),
          UIHelper.verticalSpaceSmall(),
          const DottedSeperatorView(),
          UIHelper.verticalSpaceMedium(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(foodItem),
              UIHelper.verticalSpaceExtraSmall(),
              const Text('July 14, 2:11 AM'),
              UIHelper.verticalSpaceSmall(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(width: 1.5, color: darkOrange!),
                          ),
                          child: Text(
                            'REORDER',
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .copyWith(color: darkOrange),
                          ),
                          onPressed: () {},
                        ),
                        UIHelper.verticalSpaceMedium(),
                        const Text(
                          'Delivery rating not\napplicable for this order',
                          maxLines: 2,
                        )
                      ],
                    ),
                  ),
                  UIHelper.horizontalSpaceMedium(),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(
                              width: 1.5,
                              color: Colors.black,
                            ),
                          ),
                          child: Text(
                            'RATE FOOD',
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .copyWith(color: Colors.black),
                          ),
                          onPressed: () {},
                        ),
                        UIHelper.verticalSpaceMedium(),
                        const Text("You haven't rated\nthis food yet")
                      ],
                    ),
                  )
                ],
              ),
              UIHelper.verticalSpaceMedium(),
              const CustomDividerView(dividerHeight: 1.5, color: Colors.black)
            ],
          )
        ],
      ),
    );
  }
}
