import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:swiggy_app/Utils/Network_Utils.dart';

import '../../../../models/indian_food.dart';
import '../../../../providers/home_provider.dart';
import '../../../../utils/ui_helper.dart';
import 'indian_delight_screen.dart';

class IndianFoodView extends StatelessWidget {
  final restaurants = IndianFood.getIndianRestaurants();

  IndianFoodView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeDetailsProvider>(
      builder: (context, provider, child) {
        if (provider.mainFoodCategories.isEmpty) {
          return Center(child: CircularProgressIndicator());
        }

        final mainFoods = provider.mainFoodCategories;

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: 230,
            child: GridView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal, // Horizontal scrolling
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Two rows
                crossAxisSpacing: 10, // Space between columns
                mainAxisSpacing: 10, // Space between rows
                childAspectRatio: 1, // Aspect ratio of items
              ),
              itemCount: mainFoods.length,
              itemBuilder: (context, index) {
                final mainfoods = mainFoods[index];

                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const IndianDelightScreen(),
                      ),
                    );
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.grey, width: 2),
                        ),
                        child: ClipOval(
                          child: Image.network(
                            "${NetworkUtil.base_url}${mainfoods.images[0]}",
                            height: 70.0,
                            width: 70.0,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Icon(Icons.broken_image, size: 70),
                          ),
                        ),
                      ),
                      UIHelper.verticalSpaceExtraSmall(),
                      Text(
                        mainfoods.name.toString(),
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
