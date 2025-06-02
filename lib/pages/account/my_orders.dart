import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:swiggy_app/pages/live_tracking/live_tracking_page/live_tracking_page.dart';
import '../../models/API_models/order_model.dart';
import '../../providers/orders_provider.dart';
import '../../utils/app_colors.dart';
import '../../utils/ui_helper.dart';
import '../../widgets/custom_divider_view.dart';
import '../../widgets/dotted_seperator_view.dart';

class MyOrdersListView extends StatefulWidget {
  const MyOrdersListView({Key? key}) : super(key: key);

  @override
  State<MyOrdersListView> createState() => _MyOrdersListViewState();
}

class _MyOrdersListViewState extends State<MyOrdersListView> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
            () => Provider.of<OrderProvider>(context, listen: false).fetchOrders());
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<OrderProvider>(
      builder: (context, orderProvider, child) {
        if (orderProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (orderProvider.error.isNotEmpty) {
          return Center(child: Text('Error: ${orderProvider.error}'));
        }

        final orders = orderProvider.orders;
        if (orders.isEmpty) {
          return const Center(child: Text('No orders found.'));
        }

        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ListView.builder(
              shrinkWrap: true,
              itemCount: orders.length,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) => _MyOrdersListItemView(
                order: orders[index],
              ),
            ),
          ],
        );
      },
    );
  }
}

class _MyOrdersListItemView extends StatelessWidget {
  final Order order;

  const _MyOrdersListItemView({
    Key? key,
    required this.order,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
      child: Column(
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
                    Row(
                      children: [
                        ClipOval(
                          child: Container(
                            padding: const EdgeInsets.all(2.2),
                            color: Colors.green,
                            child: const Icon(Icons.check,
                                color: Colors.white, size: 12.0),
                          ),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          order.status.isNotEmpty ? order.status : 'Unknown Status',
                          style: TextStyle(color: Colors.grey[800]),
                        ),
                      ],
                    ),
                    UIHelper.verticalSpaceSmall(),
                    Text(
                      order.user.name.isNotEmpty ? order.user.name : 'Unknown User',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    UIHelper.verticalSpaceExtraSmall(),
                    Text(
                      '${order.address.city.isNotEmpty ? order.address.city : 'Unknown City'}, '
                          '${order.address.state.isNotEmpty ? order.address.state : 'Unknown State'}',
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(fontSize: 12.0),
                    ),
                    UIHelper.verticalSpaceSmall(),
                    Row(
                      children: <Widget>[
                        Text('₹${order.totalAmount.toStringAsFixed(2)}'),
                        UIHelper.horizontalSpaceExtraSmall(),
                        Icon(Icons.keyboard_arrow_right,
                            color: Colors.grey[600])
                      ],
                    )
                  ],
                ),
                const Spacer(),
                UIHelper.horizontalSpaceSmall(),
              ],
            ),
          ),
          UIHelper.verticalSpaceSmall(),
          const DottedSeperatorView(),
          UIHelper.verticalSpaceMedium(),

          // Displaying Items with Null Safety
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: order.items.map((item) {
              // Check for empty foodDetails list
              final food = item.foodDetails.isNotEmpty
                  ? item.foodDetails.first
                  : FoodDetails(
                image: '',
                foodId: 'N/A',
                name: 'Unknown Food',
                description: 'No Description',
                category: 'Unknown Category',
              );

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${food.name} x ${item.qty}'),
                  UIHelper.verticalSpaceExtraSmall(),
                  Text('₹${item.price.toStringAsFixed(2)}'),
                  UIHelper.verticalSpaceSmall(),
                ],
              );
            }).toList(),
          ),

          UIHelper.verticalSpaceMedium(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Expanded(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(width: 1.5, color: darkOrange!),
                  ),
                  child: Text(
                    'Track Order',
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall!
                        .copyWith(color: darkOrange),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LiveTrackingPage(order: order)
                            // AddOrderPage(order: order,),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          UIHelper.verticalSpaceMedium(),
          const CustomDividerView(dividerHeight: 1.5, color: Colors.black)
        ],
      ),
    );
  }
}
