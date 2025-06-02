import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:swiggy_app/providers/offer_provider.dart';

import '../../../../utils/Network_Utils.dart';
import '../../../../models/available_coupon.dart';
import '../../../../models/spotlight_best_top_food.dart';
import '../../../../utils/ui_helper.dart';
import '../../../../widgets/custom_divider_view.dart';
import '../../models/API_models/offer_model.dart';
import '../restaurant/restaurant_detail_screen.dart';
import 'OfferDetailScreen.dart';

class OffersScreen extends StatefulWidget {
  const OffersScreen({Key? key}) : super(key: key);

  @override
  State<OffersScreen> createState() => _OffersScreenState();
}

class _OffersScreenState extends State<OffersScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.black),
          title: Text(
            'OFFERS',
            style: Theme.of(context)
                .textTheme
                .titleSmall!
                .copyWith(fontSize: 17.0),
          ),
          bottom: const TabBar(
            indicatorColor: Colors.black,
            tabs: <Widget>[
              Tab(child: Text('RESTAURANT OFFERS')),
              Tab(child: Text('PAYMENT OFFERS/COUPONS')),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _RestaurantOfferView(),
            _PaymentOffersCouponView(),
          ],
        ),
      ),
    );
  }
}

class _RestaurantOfferView extends StatefulWidget {
  @override
  State<_RestaurantOfferView> createState() => _RestaurantOfferViewState();
}

class _RestaurantOfferViewState extends State<_RestaurantOfferView> {
  @override
  void initState() {
    super.initState();
    Provider.of<OfferProvider>(context, listen: false).fetchOffers();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<OfferProvider>(
      builder: (context, offerProvider, _) {
        final offers = offerProvider.offers;

        if (offers.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        return Container(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              UIHelper.verticalSpaceSmall(),
              Text(
                'All Offers (${offers.length})',
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                ),
              ),
              UIHelper.verticalSpaceMedium(),
              Expanded(
                child: ListView.builder(
                  itemCount: offers.length,
                  itemBuilder: (context, index) {
                    final offer = offers[index];
                    return _buildOfferCard(context, offer);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildOfferCard(BuildContext context, Offer offer) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OfferDetails(offer: offer),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Container(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Hotel Image
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(
                  '${NetworkUtil.base_url}${offer.ownerId.hotelDetails.hotelMainImage.first}',
                  height: 80,
                  width: 80,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Icon(
                    Icons.broken_image,
                    size: 80,
                    color: Colors.grey[400],
                  ),
                ),
              ),
              const SizedBox(width: 12.0),
              // Offer Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      offer.name,
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      offer.tagLine,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Colors.grey[600],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      '- ₹${offer.deductionAmount}',
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: Colors.redAccent,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 18.0, color: Colors.grey)
            ],
          ),
        ),
      ),
    );
  }
}

class _PaymentOffersCouponView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final coupons = AvailableCoupon.getAvailableCoupons();

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.only(left: 15.0),
          height: 40.0,
          color: Colors.grey[200],
          child: Text('No Available Coupons',
              style: Theme.of(context).textTheme.titleSmall),
        ),
        // Expanded(
        //   child: ListView.separated(
        //     shrinkWrap: true,
        //     itemCount: coupons.length,
        //     separatorBuilder: (context, index) => const Divider(),
        //     itemBuilder: (context, index) => Container(
        //       margin: const EdgeInsets.all(10.0),
        //       child: Column(
        //         crossAxisAlignment: CrossAxisAlignment.start,
        //         children: <Widget>[
        //           Container(
        //             padding: const EdgeInsets.all(10.0),
        //             decoration: BoxDecoration(
        //               color: Colors.orange[100],
        //               border: Border.all(color: Colors.grey[400]!),
        //             ),
        //             child: Row(
        //               mainAxisSize: MainAxisSize.min,
        //               mainAxisAlignment: MainAxisAlignment.start,
        //               children: <Widget>[
        //                 Image.asset(
        //                   'assets/images/food1.jpg',
        //                   height: 10.0,
        //                   width: 10.0,
        //                   fit: BoxFit.cover,
        //                 ),
        //                 UIHelper.horizontalSpaceMedium(),
        //                 Text(coupons[index].coupon,
        //                     style: Theme.of(context).textTheme.titleSmall)
        //               ],
        //             ),
        //           ),
        //           UIHelper.verticalSpaceSmall(),
        //           Text(
        //             coupons[index].discount,
        //             style: Theme.of(context).textTheme.titleSmall,
        //           ),
        //           UIHelper.verticalSpaceMedium(),
        //           const CustomDividerView(
        //             dividerHeight: 1.0,
        //             color: Colors.grey,
        //           ),
        //           UIHelper.verticalSpaceMedium(),
        //           Text(
        //             coupons[index].desc,
        //             style: Theme.of(context)
        //                 .textTheme
        //                 .bodyLarge!
        //                 .copyWith(fontSize: 13.0),
        //           ),
        //           UIHelper.verticalSpaceMedium(),
        //           InkWell(
        //             child: Text(
        //               '+ MORE',
        //               style: Theme.of(context)
        //                   .textTheme
        //                   .titleSmall!
        //                   .copyWith(color: Colors.blue),
        //             ),
        //           )
        //         ],
        //       ),
        //     ),
        //   ),
        // )
      ],
    );
  }
}
