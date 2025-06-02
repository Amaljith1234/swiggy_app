import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:swiggy_app/pages/restaurant/restaurant_detail_screen.dart';
import '../../../models/popular_brands.dart';
import '../../../providers/home_provider.dart';
import '../../../utils/ui_helper.dart';
import '../../../widgets/responsive.dart';

class PopularBrandsView extends StatelessWidget {
  final brands = PopularBrands.getPopularBrands();

  PopularBrandsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isTabletDesktop = Responsive.isTabletDesktop(context);
    return Consumer<HomeDetailsProvider>(builder: (context, provider, child)
    {
      // Check if topDataList is empty and show a loading spinner if true
      if (provider.popularCategory.isEmpty) {
        return Center(child: CircularProgressIndicator());
      }
      // Get the topData list from the provider
      final popularBrands = provider.popularCategory;

      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            UIHelper.verticalSpaceSmall(),
            _buildPopularHeader(context),
            LimitedBox(
              maxHeight: 190.0,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: brands.length,
                  itemBuilder: (context, index) {
                    final popBrands = popularBrands[index];
                    return InkWell(
                      onTap: isTabletDesktop
                          ? () {}
                          : () {
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) =>
                        //     const RestaurantDetailScreen(restaurantId: '',),
                        //   ),
                        // );
                      },
                      child: Container(
                        margin: const EdgeInsets.only(right: 15.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.grey[300]!,
                                  width: 3.0,
                                ),
                                borderRadius: BorderRadius.circular(40.0),
                              ),
                              child: ClipOval(
                                child: Image.asset(
                                  brands[index].image,
                                  height: 80.0,
                                  width: 80.0,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            UIHelper.verticalSpaceSmall(),
                            Text(
                              popBrands.name,
                              style: Theme
                                  .of(context)
                                  .textTheme
                                  .titleSmall!
                                  .copyWith(fontWeight: FontWeight.w500),
                            ),
                            UIHelper.verticalSpace(2.0),
                            Text(
                              brands[index].minutes,
                              style: Theme
                                  .of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(
                                  color: Colors.grey, fontSize: 13.0),
                            )
                          ],
                        ),
                      ),
                    );
                  }
                ),
              ),
            )
          ],
        ),
      );
    });
  }

  Column _buildPopularHeader(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(
            'Popular Brands',
            style:
                Theme.of(context).textTheme.headlineMedium!.copyWith(fontSize: 20.0),
          ),
          UIHelper.verticalSpaceExtraSmall(),
          Text(
            'Most ordered from around your locality',
            style: Theme.of(context)
                .textTheme
                .bodyLarge!
                .copyWith(color: Colors.grey),
          ),
        ],
      );
}
