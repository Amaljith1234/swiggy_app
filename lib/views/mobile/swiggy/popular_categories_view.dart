import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/popular_category.dart';
import '../../../providers/home_provider.dart';
import '../../../utils/ui_helper.dart';

class PopularCategoriesView extends StatelessWidget {
  final categories = PopularCategory.getPopularCategories();

  PopularCategoriesView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeDetailsProvider>(builder: (context, provider, child) {
      // Check if topDataList is empty and show a loading spinner if true
      if (provider.popularCategory.isEmpty) {
        return Center(child: CircularProgressIndicator());
      }
      // Get the topData list from the provider
      final popular = provider.popularCategory;

      return Container(
        alignment: Alignment.topLeft,
        margin: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Popular Categories',
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium!
                  .copyWith(fontSize: 20.0),
            ),
            UIHelper.verticalSpaceMedium(),
            LimitedBox(
              maxHeight: 124.0,
              child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: popular.length,
                itemBuilder: (context, index) {
                  final Popular = popular[index];
                  return Container(
                      margin: const EdgeInsets.all(10.0),
                      width: 70.0,
                      child: Stack(
                        alignment: Alignment.topCenter,
                        children: <Widget>[
                          ClipRRect(
                            borderRadius: BorderRadius.circular(5.0),
                            child: Container(
                              height: 50.0,
                              color: Colors.grey[200],
                            ),
                          ),
                          Positioned(
                            top: 20.0,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Image.asset(
                                  categories[index].image,
                                  height: 40.0,
                                  width: 40.0,
                                  fit: BoxFit.cover,
                                ),
                                UIHelper.verticalSpaceSmall(),
                                Text(
                                  Popular.name.toString(),
                                  // categories[index].name,
                                  maxLines: 2,
                                  textAlign: TextAlign.center,
                                )
                              ],
                            ),
                          ),
                        ],
                      ));
                }
              ),
            )
          ],
        ),
      );
    });
  }
}
