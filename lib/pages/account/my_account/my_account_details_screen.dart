import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/API_models/address_model.dart';
import '../../../providers/address_provider.dart';
import '../../../utils/ui_helper.dart';
import '../../../widgets/custom_divider_view.dart';
import '../../favorites/favorites.dart';
import '../../offers/offer_screen.dart';
import 'address/address_list.dart';
import 'bankPage/bank_details.dart';

class MyAccountDetailsScreen extends StatefulWidget {
  const MyAccountDetailsScreen({super.key});

  @override
  State<MyAccountDetailsScreen> createState() => _MyAccountDetailsScreenState();
}

class _MyAccountDetailsScreenState extends State<MyAccountDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    final addressProvider = Provider.of<AddressProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Account Details'),
        backgroundColor: Colors.orangeAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10),
        child: ListView(
          children: [
            UIHelper.verticalSpaceLarge(),

            // ✅ Address Section with Provider
            GestureDetector(
              onTap: () async {
                final selectedAddress = await showModalBottomSheet<AddressModel>(
                  context: context,
                  isScrollControlled: true,
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
              child: ListTile(
                leading: Icon(
                  addressProvider.selectedAddress != null
                      ? Icons.location_on
                      : Icons.location_off,
                  color: Colors.blue,
                ),
                title: Text(
                  addressProvider.selectedAddress != null
                      ? '${addressProvider.selectedAddress!.street}, '
                      '${addressProvider.selectedAddress!.city}, '
                      '${addressProvider.selectedAddress!.state}, '
                      '${addressProvider.selectedAddress!.zipCode}'
                      : "Select Address",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                trailing: const Icon(Icons.keyboard_arrow_down_rounded),
              ),
            ),

            UIHelper.verticalSpaceLarge(),
            const CustomDividerView(
              dividerHeight: 0.8,
              color: Colors.black26,
            ),

            // ✅ Bank Section
            UIHelper.verticalSpaceLarge(),
            ListTile(
              leading: const Icon(Icons.account_balance, color: Colors.green),
              title: const Text(
                "Bank Details",
                style: TextStyle(fontSize: 18.0),
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BankDetailsPage(),
                  ),
                );
              },
            ),

            UIHelper.verticalSpaceLarge(),
            const CustomDividerView(
              dividerHeight: 0.8,
              color: Colors.black26,
            ),

            // ✅ Offers Section
            UIHelper.verticalSpaceLarge(),
            ListTile(
              leading: const Icon(Icons.local_offer, color: Colors.red),
              title: const Text(
                "Offers",
                style: TextStyle(fontSize: 18.0),
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => OffersScreen()),
                );
              },
            ),

            UIHelper.verticalSpaceLarge(),
            const CustomDividerView(
              dividerHeight: 0.8,
              color: Colors.black26,
            ),

            UIHelper.verticalSpaceLarge(),
            ListTile(
              leading: const Icon(Icons.favorite, color: Colors.red),
              title: const Text(
                "Favorites",
                style: TextStyle(fontSize: 18.0),
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FavoritePage()),
                );
              },
            ),

            UIHelper.verticalSpaceLarge(),
            const CustomDividerView(
              dividerHeight: 0.8,
              color: Colors.black26,
            ),
          ],
        ),
      ),
    );
  }
}
