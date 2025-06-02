import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:swiggy_app/providers/home_provider.dart';
import '../../../models/API_models/address_model.dart';
import '../../../models/spotlight_best_top_food.dart';
import '../../../pages/account/account_screen.dart';
import '../../../pages/account/my_account/address/address_list.dart';
import '../../../pages/all_restaurants/all_restaurants_screen.dart';
import '../../../pages/offers/offer_banner_view.dart';
import '../../../pages/offers/offer_screen.dart';
import '../../../providers/address_provider.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/ui_helper.dart';
import '../../../widgets/custom_divider_view.dart';
import '../../../widgets/responsive.dart';
import '../home_bottom_navigation_screen.dart';
import 'best_in_safety_view.dart';
import 'food_groceries_availability_view.dart';
import 'genie/genie_view.dart';
import 'in_the_spotlight_view.dart';
import 'indian_food/indian_food_view.dart';
import 'popular_brand_view.dart';
import 'popular_categories_view.dart';
import 'restaurants/restaurant_vertical_list_view.dart';
import 'swiggy_safety_banner_view.dart';
import 'top_offer_view.dart';
import 'top_picks_for_you_view.dart';

class SwiggyScreen extends StatefulWidget {
  const SwiggyScreen({Key? key}) : super(key: key);

  @override
  State<SwiggyScreen> createState() => _SwiggyScreenState();
}

class _SwiggyScreenState extends State<SwiggyScreen> {
  @override
  void initState() {
    super.initState();
    final provider = Provider.of<HomeDetailsProvider>(context, listen: false);
    provider.fetchHomeDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 8,
        backgroundColor: swiggyOrange,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  _buildAppBar(context),
                  OfferBannerView(),
                  const CustomDividerView(),
                  IndianFoodView(),
                  const CustomDividerView(),
                  TopPicksForYouView(),
                  const CustomDividerView(),
                  InTheSpotlightView(),
                  const CustomDividerView(),
                  PopularBrandsView(),
                  const CustomDividerView(),
                  const SwiggySafetyBannerView(),
                  BestInSafetyViews(),
                  const CustomDividerView(),
                  TopOffersViews(),
                  const CustomDividerView(),
                  const GenieView(),
                  const CustomDividerView(),
                  PopularCategoriesView(),
                  const CustomDividerView(),
                  RestaurantVerticalListView(
                    title: 'Popular Restaurants',
                  ),
                  const CustomDividerView(),
                  // RestaurantVerticalListView(
                  //   title: 'All Restaurants Nearby',
                  // ),
                  const SeeAllRestaurantBtn(),
                  const LiveForFoodView(),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Container _buildAppBar(BuildContext context) {
    final addressProvider = Provider.of<AddressProvider>(context);
    return Container(
      height: 270.0,
      width: double.infinity,
      decoration: BoxDecoration(
          color: swiggyOrange,
          borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(20),
              bottomLeft: Radius.circular(20))),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () async {
                        final selectedAddress =
                            await showModalBottomSheet<AddressModel>(
                          context: context,
                          isScrollControlled: true,
                          // Enables full height control
                          builder: (BuildContext context) {
                            return DraggableScrollableSheet(
                              expand: false,
                              initialChildSize: 0.7,
                              minChildSize: 0.5,
                              maxChildSize: 1.0,
                              builder: (context, scrollController) {
                                return AddressListPage();
                              },
                            );
                          },
                        );
                        if (selectedAddress != null) {
                          addressProvider.setAddress(selectedAddress);
                        }
                      },
                      child: Row(
                        children: [
                          Icon(
                            addressProvider.selectedAddress == null
                                ? Icons.location_off
                                : Icons.location_on,
                            size: 20,
                            color: Colors.white,
                          ),
                          Text(
                            '${addressProvider.selectedAddress?.street ?? "Location"}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
                          Icon(
                            Icons.keyboard_arrow_down_sharp,
                            size: 20,
                            color: Colors.white,
                          )
                        ],
                      ),
                    ),
                    Text(
                      '${addressProvider.selectedAddress?.city ?? "City"}, ${addressProvider.selectedAddress?.state ?? "State"}, ${addressProvider.selectedAddress?.zipCode ?? "ZipCode"}',
                      style: TextStyle(fontSize: 12, color: Colors.white),
                    ),
                  ],
                ),
                const Spacer(),
                const Icon(
                  Icons.local_offer,
                  color: Colors.white,
                ),
                InkWell(
                  child: Container(
                    padding: const EdgeInsets.all(5.0),
                    child: Text('Offer',
                        style: Theme.of(context)
                            .textTheme
                            .titleSmall!
                            .copyWith(fontSize: 18.0, color: Colors.white)),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const OffersScreen(),
                      ),
                    );
                  },
                ),
                UIHelper.horizontalSpaceExtraSmall(),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AccountScreen()),
                    );
                  },
                  child: CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.black,
                    child: Icon(
                      Icons.person,
                      color: Colors.white,
                    ),
                  ),
                ),
                UIHelper.horizontalSpaceExtraSmall(),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => HomeBottomNavigationScreen(
                            selectedIndex: 2,
                          )),
                );
              },
              child: AbsorbPointer(
                child: TextField(
                  decoration: InputDecoration(
                    suffixIcon: Icon(Icons.search, color: Colors.black),
                    hintText: 'Search',
                    hintStyle: TextStyle(color: Colors.black),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Stack(
            children: <Widget>[
              ClipRRect(
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AllRestaurantsScreen(),
                      ),
                    );
                  },
                  child: Container(
                    height: 120.0,
                    color: swiggyOrange,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
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
                        // const Spacer(),
                        // Container(
                        //   height: 45.0,
                        //   padding:
                        //       const EdgeInsets.symmetric(horizontal: 10.0),
                        //   color: darkOrange,
                        //   child: Row(
                        //     children: <Widget>[
                        //       Text(
                        //         'View all',
                        //         style: Theme.of(context)
                        //             .textTheme
                        //             .bodyLarge!
                        //             .copyWith(
                        //                 color: Colors.white, fontSize: 18.0),
                        //       ),
                        //       UIHelper.horizontalSpaceSmall(),
                        //       const Icon(
                        //         Icons.arrow_forward,
                        //         color: Colors.white,
                        //         size: 18.0,
                        //       ),
                        //     ],
                        //   ),
                        // )
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
        ],
      ),
    );
  }
}

class SeeAllRestaurantBtn extends StatelessWidget {
  const SeeAllRestaurantBtn({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isTabletDesktop = Responsive.isTabletDesktop(context);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 15.0),
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      height: 50.0,
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: darkOrange),
        child: Text(
          'See all restaurants',
          style: Theme.of(context)
              .textTheme
              .titleSmall!
              .copyWith(color: Colors.white, fontSize: 19.0),
        ),
        onPressed: isTabletDesktop
            ? () {}
            : () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AllRestaurantsScreen(),
                  ),
                );
              },
      ),
    );
  }
}

class LiveForFoodView extends StatelessWidget {
  const LiveForFoodView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20.0),
      padding: const EdgeInsets.all(15.0),
      height: 400.0,
      color: Colors.grey[200],
      child: Stack(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'LIVE\nFOR\nFOOD',
                style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                      color: Colors.grey[400],
                      fontSize: 80.0,
                      letterSpacing: 0.2,
                      height: 0.8,
                    ),
              ),
              UIHelper.verticalSpaceLarge(),
              Text(
                'MADE BY FOOD LOVERS',
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(color: Colors.grey),
              ),
              Text(
                'SWIGGY HQ, BANGALORE',
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(color: Colors.grey),
              ),
              UIHelper.verticalSpaceExtraLarge(),
              Row(
                children: <Widget>[
                  Container(
                    height: 1.0,
                    width: MediaQuery.of(context).size.width / 4,
                    color: Colors.grey,
                  ),
                ],
              )
            ],
          ),
          Positioned(
            left: 140.0,
            top: 90.0,
            child: Image.asset(
              'assets/images/burger.png',
              height: 80.0,
              width: 80.0,
            ),
          )
        ],
      ),
    );
  }
}
