import 'package:flutter/material.dart';
import '../../Utils/Network_Utils.dart';
import '../../models/API_models/search_model.dart';
import '../favorites/favorite_button.dart';
import '../restaurant/restaurant_detail_screen.dart';

class SearchListViewHotelsItem extends StatelessWidget {
  final Hotel item;

  const SearchListViewHotelsItem({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RestaurantDetailScreen(restaurantId: item.id),
            ),
          );
        },
        child: Container(
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
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 120,
                    width: 190,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      color: Colors.grey[200],
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: (item.images.isNotEmpty && item.images[0].isNotEmpty)
                        ? Image.network(
                      "${NetworkUtil.base_url}${item.images[0]}",
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.broken_image, size: 50, color: Colors.grey),
                    )
                        : const Icon(Icons.image, size: 50, color: Colors.grey),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.restaurantName.isNotEmpty ? item.restaurantName : "Unknown Restaurant",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item.restaurantDescription.isNotEmpty ? item.restaurantDescription : "No description available",
                          maxLines: 4,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      _getFormattedAddress(item.location),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall!
                          .copyWith(color: Colors.grey[600]),
                    ),
                  ),
                  FavoriteButton(restaurantId: item.id),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Returns a formatted address or a fallback if `location` is null.
  String _getFormattedAddress(Location? location) {
    if (location == null) return "Location not available";
    return "${location.address.isNotEmpty ? location.address : 'Unknown Address'}, "
        "${location.city.isNotEmpty ? location.city : 'Unknown City'}, "
        "${location.state.isNotEmpty ? location.state : 'Unknown State'}, "
        "${location.zipcode.isNotEmpty ? location.zipcode : 'Unknown Zipcode'}";
  }
}
