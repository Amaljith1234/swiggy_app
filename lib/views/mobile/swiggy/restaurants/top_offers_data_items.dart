import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:swiggy_app/utils/Network_Utils.dart';
import 'package:swiggy_app/pages/restaurant/restaurant_detail_screen.dart';
import '../../../../providers/home_provider.dart';
import '../../../../widgets/responsive.dart';


class TopOffersDataItemCard extends StatefulWidget {
  const TopOffersDataItemCard({Key? key}) : super(key: key);

  @override
  State<TopOffersDataItemCard> createState() =>
      _TopOffersDataItemCardState();
}

class _TopOffersDataItemCardState extends State<TopOffersDataItemCard> {

  // List<Widget> getStars(double rating) {
  //   int fullStars = rating.floor(); // Get the full stars
  //   bool hasHalfStar = (rating - fullStars) >= 0.5; // Check for half star
  //   int emptyStars =
  //       5 - fullStars - (hasHalfStar ? 1 : 0); // Remaining empty stars
  //
  //   // Create a list of star icons
  //   List<Widget> stars = [];
  //
  //   // Add full stars
  //   for (int i = 0; i < fullStars; i++) {
  //     stars.add(const Icon(Icons.star, color: Colors.orange, size: 16));
  //   }
  //
  //   // Add half star if necessary
  //   if (hasHalfStar) {
  //     stars.add(const Icon(Icons.star_half, color: Colors.orange, size: 16));
  //   }
  //
  //   // Add empty stars
  //   for (int i = 0; i < emptyStars; i++) {
  //     stars.add(const Icon(Icons.star_border, color: Colors.orange, size: 16));
  //   }
  //
  //   return stars;
  // }

  @override
  Widget build(BuildContext context) {
    final isTabletDesktop = Responsive.isTabletDesktop(context);

    return Consumer<HomeDetailsProvider>(
      builder: (context, provider, child) {
        debugPrint("Top Offers List: ${provider.topOffers}");
        if (provider.topOffers.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        final topOffersList = provider.topOffers;

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: topOffersList.map((topOffers) {
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
                  width: 250,
                  // Set a fixed width for horizontal consistency
                  margin: const EdgeInsets.symmetric(horizontal: 8.0),
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Colors.white,
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.grey,
                        blurRadius: 4.0,
                        offset: Offset(2, 2),
                      )
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Spotlight image
                      Container(
                        height: 120,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          color: Colors.grey[200],
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: topOffers.hotelImages.isNotEmpty
                            ? Image.network(
                          "${NetworkUtil.base_url}${topOffers.hotelImages[0]}",
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.cover,
                        )
                            : const Icon(Icons.image, size: 50),
                      ),
                      const SizedBox(height: 8),
                      // Restaurant name
                      Text(
                        topOffers.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      // Restaurant description
                      Text(
                        topOffers.hotelDescription,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall!
                            .copyWith(color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 4),
                      // Offer tag line
                      if (topOffers.tagLine != null)
                        Text(
                          topOffers.tagLine!,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(color: Colors.red),
                        ),
                      const Divider(),
                      // Rating
                      // Row(
                      //   children: [
                      //     Row(
                      //       children: getStars(topOffers.),
                      //     ),
                      //     const SizedBox(width: 8),
                      //     // Show the rating value rounded to 3 decimal places
                      //     Text(
                      //       spotlight.averageRating.toStringAsFixed(3),
                      //       style: Theme.of(context)
                      //           .textTheme
                      //           .bodyLarge!
                      //           .copyWith(fontSize: 14),
                      //     ),
                      //   ],
                      // )
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
