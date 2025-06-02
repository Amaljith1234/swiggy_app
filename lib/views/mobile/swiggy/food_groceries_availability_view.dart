import 'package:flutter/material.dart';
import '../../../pages/all_restaurants/all_restaurants_screen.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/ui_helper.dart';
import '../../../widgets/responsive.dart';
import 'genie/genie_grocery_card_view.dart';
import 'genie/genie_screen.dart';
import 'meat/meat_screen.dart';

class FoodGroceriesAvailabilityView extends StatelessWidget {
  const FoodGroceriesAvailabilityView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isTabletDesktop = Responsive.isTabletDesktop(context);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Column(
        children: <Widget>[
          if (!isTabletDesktop) UIHelper.verticalSpaceLarge(),
          Stack(
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                child: InkWell(
                  onTap: isTabletDesktop
                      ? () {}
                      : () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AllRestaurantsScreen(),
                            ),
                          );
                        },
                  child: Container(
                    height: 140.0,
                    color: swiggyOrange,
                    child: Column(
                      // crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Align(
                          alignment: Alignment.topLeft,
                          child: FractionallySizedBox(
                            widthFactor: 0.7,
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    'Restaurants',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineMedium!
                                        .copyWith(color: Colors.white),
                                  ),
                                  UIHelper.verticalSpaceExtraSmall(),
                                  Text(
                                    'No-contact delivery available',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .copyWith(color: Colors.white),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        const Spacer(),
                        Container(
                          height: 45.0,
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          color: darkOrange,
                          child: Row(
                            children: <Widget>[
                              Text(
                                'View all',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(
                                        color: Colors.white, fontSize: 18.0),
                              ),
                              UIHelper.horizontalSpaceSmall(),
                              const Icon(
                                Icons.arrow_forward,
                                color: Colors.white,
                                size: 18.0,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                top: -10.0,
                right: -10.0,
                child: ClipOval(
                  child: Image.asset(
                    'assets/images/food1.jpg',
                    width: 130.0,
                    height: 130.0,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          ),
          // UIHelper.verticalSpaceMedium(),
          // Row(
          //   crossAxisAlignment: CrossAxisAlignment.start,
          //   children: <Widget>[
          //     GenieGroceryCardView(
          //       title: 'Genie',
          //       subtitle: 'Anything you need,\ndelivered',
          //       image: 'assets/images/food1.jpg',
          //       onTap: isTabletDesktop
          //           ? () {}
          //           : () {
          //               Navigator.push(
          //                 context,
          //                 MaterialPageRoute(
          //                   builder: (context) => const GenieScreen(),
          //                 ),
          //               );
          //             },
          //     ),
          //     GenieGroceryCardView(
          //       title: 'Veg',
          //       subtitle: 'Esentials delivered\nin 2 Hrs',
          //       image: 'assets/images/food5.jpg',
          //       onTap: isTabletDesktop
          //           ? () {}
          //           : () {
          //               Navigator.push(
          //                 context,
          //                 MaterialPageRoute(
          //                   builder: (context) => const GenieScreen(),
          //                 ),
          //               );
          //             },
          //     ),
          //     GenieGroceryCardView(
          //       title: 'Meat',
          //       subtitle: 'Fesh meat\ndelivered safe',
          //       image: 'assets/images/food6.jpg',
          //       onTap: isTabletDesktop
          //           ? () {}
          //           : () {
          //               Navigator.push(
          //                 context,
          //                 MaterialPageRoute(
          //                   builder: (context) => const MeatScreen(),
          //                 ),
          //               );
          //             },
          //     ),
          //   ],
          // )
        ],
      ),
    );
  }
}
