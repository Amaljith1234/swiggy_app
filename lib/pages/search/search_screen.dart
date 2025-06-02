import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:swiggy_app/views/mobile/home_bottom_navigation_screen.dart';
import '../../../models/API_models/search_model.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/ui_helper.dart';
import '../../../widgets/custom_divider_view.dart';
import '../../providers/cart_provider.dart';
import '../../providers/search_provider.dart';
import '../cart/cart_address_payment_view.dart';
import '../view_cart_items.dart';
import 'search_result_food.dart';
import 'search_result_restaurant.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
    with SingleTickerProviderStateMixin {
  final FocusNode _focusNode = FocusNode();
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final searchProvider = Provider.of<SearchProvider>(context, listen: false);

    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Search Bar
              Container(
                padding:
                    const EdgeInsets.only(left: 15.0, top: 2.0, bottom: 2.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[400]!),
                  borderRadius: BorderRadius.circular(2.0),
                ),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        focusNode: _focusNode,
                        controller: _searchController,
                        onChanged: (value) => searchProvider.triggerSearch(
                            value, _tabController.index),
                        decoration: InputDecoration(
                          hintText: 'Search for restaurants and food',
                          hintStyle:
                              Theme.of(context).textTheme.titleSmall!.copyWith(
                                    color: Colors.grey,
                                    fontSize: 17.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () => searchProvider.triggerSearch(
                          _searchController.text, _tabController.index),
                    ),
                  ],
                ),
              ),

              UIHelper.verticalSpaceExtraSmall(),

              // Tab Bar
              TabBar(
                unselectedLabelColor: Colors.grey,
                labelColor: Colors.black,
                controller: _tabController,
                indicatorColor: darkOrange,
                labelStyle: Theme.of(context)
                    .textTheme
                    .titleSmall!
                    .copyWith(fontSize: 18.0, color: darkOrange),
                unselectedLabelStyle:
                    Theme.of(context).textTheme.titleSmall!.copyWith(
                          fontSize: 18.0,
                          color: Colors.grey[200],
                        ),
                indicatorSize: TabBarIndicatorSize.tab,
                tabs: const [
                  Tab(child: Text('Restaurant')),
                  Tab(child: Text('Dishes')),
                ],
              ),

              UIHelper.verticalSpaceSmall(),
              const CustomDividerView(dividerHeight: 8.0),

              // Search Results
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    // Restaurant Search Results
                    PagedListView<int, Hotel>(
                      pagingController:
                          searchProvider.restaurantPagingController,
                      builderDelegate: PagedChildBuilderDelegate<Hotel>(
                        itemBuilder: (context, item, index) =>
                            SearchListViewHotelsItem(item: item),
                        noItemsFoundIndicatorBuilder: (context) => const Center(
                          child: Text("No restaurants found",
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 16)),
                        ),
                      ),
                    ),

                    // Food Search Results
                    PagedListView<int, SearchFoodItem>(
                      pagingController: searchProvider.foodPagingController,
                      builderDelegate:
                          PagedChildBuilderDelegate<SearchFoodItem>(
                        itemBuilder: (context, item, index) =>
                            SearchFoodListItemView(food: item),
                        noItemsFoundIndicatorBuilder: (context) => const Center(
                          child: Text("No dishes found",
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 16)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
