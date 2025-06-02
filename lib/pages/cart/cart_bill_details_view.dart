import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/cart_provider.dart';
import '../../utils/ui_helper.dart';
import '../../widgets/custom_divider_view.dart';

class BillDetailView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final provider = context.watch<CartProvider>();
    final items = provider.cartItems;

    if (items == null) {
      return Container(
        padding: const EdgeInsets.all(15.0),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    final textStyle =
    Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 16.0);

    return items.isEmpty
      ? Center(child: Text(''),)
      : Container(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Bill Details',
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(fontSize: 17.0),
          ),
          UIHelper.verticalSpaceSmall(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('Item total', style: textStyle),
              Text("${euro} ${items.first.totalPrice.toString()?? 0.0}", style: textStyle),
            ],
          ),
          UIHelper.verticalSpaceMedium(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text('Delivery Fee', style: textStyle),
                        UIHelper.horizontalSpaceSmall(),
                        const Icon(Icons.info_outline, size: 14.0)
                      ],
                    ),
                    UIHelper.verticalSpaceSmall(),
                    Text(
                      'Your Delivery Partner is travelling long distance to deliver your order',
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(fontSize: 13.0),
                    ),
                  ],
                ),
              ),
              Text('${euro}${items.first.deliveryFee}', style: textStyle),
            ],
          ),
          UIHelper.verticalSpaceLarge(),
          _buildDivider(),
          Container(
            alignment: Alignment.center,
            height: 60.0,
            child: Row(
              children: <Widget>[
                Text('Taxes and Charges', style: textStyle),
                UIHelper.horizontalSpaceSmall(),
                const Icon(Icons.info_outline, size: 14.0),
                const Spacer(),
                Text('${euro}${items.first.tax}', style: textStyle),
              ],
            ),
          ),
          _buildDivider(),
          Container(
            alignment: Alignment.center,
            height: 60.0,
            child: Row(
              children: <Widget>[
                Text('To Pay', style: Theme.of(context).textTheme.titleSmall),
                const Spacer(),
                Text('${euro}${items.first.totalPrice}', style: textStyle),
              ],
            ),
          ),
        ],
      ),
    );
  }

  CustomDividerView _buildDivider() => CustomDividerView(
    dividerHeight: 1.0,
    color: Colors.grey[400],
  );
}