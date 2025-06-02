import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:swiggy_app/Utils/AppUtils.dart';
import 'package:swiggy_app/pages/LoginPage/loginpage.dart';
import 'package:swiggy_app/pages/account/past_order.dart';
import 'package:swiggy_app/providers/account_provider.dart';

import '../../../utils/app_colors.dart';
import '../../../utils/ui_helper.dart';
import '../../../widgets/custom_divider_view.dart';
import '../../../widgets/dotted_seperator_view.dart';
import 'my_account/my_account_details_screen.dart';
import 'my_orders.dart';

class AccountScreen extends StatefulWidget {
  AccountScreen({Key? key}) : super(key: key);

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final List<String> titles = [
    'My Account',
    'SUPER Expired',
    'Swiggy Money',
    'Help',
  ];

  final List<String> body = [
    'Address, Payments, Favourites, Referrals & Offers',
    'You had a great savings run. Get SUPER again',
    'Balance & Transactions',
    'FAQ & Links',
  ];

  @override
  void initState() {
    super.initState();
    Provider.of<AccountProvider>(context, listen: false).fetchProfileDetails();
  }

  void _handleNavigation(int index) {
    switch (index) {
      case 0:
        Navigator.push(context,
            MaterialPageRoute(builder: (_) => MyAccountDetailsScreen()));
        break;
      case 1:
        // Navigator.push(context, MaterialPageRoute(builder: (_) => SuperScreen()));
        break;
      case 2:
        // Navigator.push(context, MaterialPageRoute(builder: (_) => SwiggyMoneyScreen()));
        break;
      case 3:
        // Navigator.push(context, MaterialPageRoute(builder: (_) => HelpScreen()));
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              _AppBar(),
              ListView.builder(
                shrinkWrap: true,
                itemCount: titles.length,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) => GestureDetector(
                  onTap: () => _handleNavigation(index),
                  child: _ListItem(
                    title: titles[index],
                    body: body[index],
                    isLastItem: (titles.length - 1) == index,
                  ),
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(left: 15.0),
                height: 50.0,
                color: Colors.grey[200],
                child: Text(
                  'MY ORDERS',
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall!
                      .copyWith(color: Colors.grey[700], fontSize: 12.0),
                ),
              ),
              MyOrdersListView(),
              Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(left: 15.0),
                height: 50.0,
                color: Colors.grey[200],
                child: Text(
                  'PAST ORDERS',
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall!
                      .copyWith(color: Colors.grey[700], fontSize: 12.0),
                ),
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
                    icon: const Icon(Icons.power_settings_new),
                    onPressed: () async {
                      await AppUtil.logout(context);
                    },
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
              // PastOrderListView(),
              // InkWell(
              //   onTap: () async {
              //     await AppUtil.logout(context);
              //   },
              //   child: Container(
              //     padding: const EdgeInsets.only(left: 15.0),
              //     height: 50.0,
              //     color: Colors.red[200],
              //     child: Row(
              //       mainAxisAlignment: MainAxisAlignment.center,
              //       children: [
              //         Text(
              //           'LOG OUT ',
              //           style: Theme.of(context)
              //               .textTheme
              //               .titleSmall!
              //               .copyWith(color: Colors.grey[700], fontSize: 15.0),
              //         ),
              //         Icon(
              //           Icons.logout,
              //           size: 20,
              //           color: Colors.grey[700],
              //         )
              //       ],
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AccountProvider>();
    final account = provider.accountDetails;

    if (account == null) {
      return Container(
        padding: const EdgeInsets.all(15.0),
        child: Center(
            child:
                CircularProgressIndicator()), // Show loader while fetching data
      );
    }

    final subtitleStyle = Theme.of(context).textTheme.bodyLarge;

    return Container(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                account.name.isNotEmpty ? account.name : 'N/A',
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                    ),
              ),
              InkWell(
                child: Text(
                  'EDIT',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(fontSize: 17.0, color: darkOrange),
                ),
                onTap: () {
                  // Handle edit action
                },
              ),
            ],
          ),
          UIHelper.verticalSpaceSmall(),
          Row(
            children: <Widget>[
              Text(
                account.phone > 0 ? account.phone.toString() : 'N/A',
                style: subtitleStyle,
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Text(
                account.email.isNotEmpty ? account.email : 'N/A',
                style: subtitleStyle,
              ),
            ],
          ),
          UIHelper.verticalSpaceSmall(),
          const Divider(
            height: 1.8,
            thickness: 1.8,
            color: Colors.black,
          ),
        ],
      ),
    );
  }
}

class _ListItem extends StatelessWidget {
  const _ListItem({
    Key? key,
    required this.title,
    required this.body,
    this.isLastItem = false,
  })  : assert(title != '', body != ''),
        super(key: key);

  final String title;
  final String body;
  final bool isLastItem;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      title,
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge!
                          .copyWith(fontSize: 15.0),
                    ),
                    UIHelper.verticalSpaceExtraSmall(),
                    Text(
                      body,
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(fontSize: 13.0, color: Colors.black),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              UIHelper.horizontalSpaceSmall(),
              const Icon(Icons.keyboard_arrow_right)
            ],
          ),
          UIHelper.verticalSpaceLarge(),
          isLastItem
              ? const SizedBox()
              : const CustomDividerView(
                  dividerHeight: 0.8,
                  color: Colors.black26,
                ),
        ],
      ),
    );
  }
}
