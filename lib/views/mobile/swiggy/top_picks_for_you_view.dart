import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:swiggy_app/utils/Network_Utils.dart';
import 'package:swiggy_app/pages/restaurant/restaurant_detail_screen.dart';
import '../../../models/top_picks_food.dart';
import '../../../providers/home_provider.dart';
import '../../../utils/ui_helper.dart';


class TopPicksForYouView extends StatefulWidget {

  TopPicksForYouView({Key? key}) : super(key: key);

  @override
  State<TopPicksForYouView> createState() => _TopPicksForYouViewState();
}

class _TopPicksForYouViewState extends State<TopPicksForYouView> {
  final foods = TopPicksFood.getTopPicksfoods();

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeDetailsProvider>(
        builder: (context, provider, child) {
          // Check if topDataList is empty and show a loading spinner if true
          if (provider.addsList.isEmpty) {
            return Center(child: CircularProgressIndicator());
          }
          // Get the topData list from the provider
          final adsList = provider.addsList;

          return Container(
            margin: const EdgeInsets.all(15.0),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    const Icon(Icons.thumb_up, size: 20.0),
                    UIHelper.horizontalSpaceSmall(),
                    Text(
                      'Top Picks For You',
                      style: Theme
                          .of(context)
                          .textTheme
                          .headlineMedium!
                          .copyWith(fontSize: 20.0),
                    )
                  ],
                ),
                UIHelper.verticalSpaceLarge(),
                LimitedBox(
                  maxHeight: 188.0,
                  child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: adsList.length,
                      itemBuilder: (context, index) {
                        final adList = adsList[index];
                        return InkWell(
                          onTap: () {
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (
                            //         context) => RestaurantDetailScreen(restaurantId: '',),
                            //   ),
                            // );
                          },
                          child: Container(
                            margin: const EdgeInsets.all(10.0),
                            width: 100.0,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    boxShadow: const <BoxShadow>[
                                      BoxShadow(
                                        color: Colors.grey,
                                        blurRadius: 2.0,
                                      )
                                    ],
                                  ),
                                  child: Image.network(
                                    "${NetworkUtil.base_url}${adList.images[0]}",
                                    width: 100.0,
                                    height: 100.0,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                UIHelper.verticalSpaceSmall(),
                                Flexible(
                                  child: Text(
                                    adList.tagline,
                                    maxLines: 2,
                                    style:
                                    Theme
                                        .of(context)
                                        .textTheme
                                        .titleSmall!
                                        .copyWith(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                UIHelper.verticalSpaceExtraSmall(),
                                Text(
                                  foods[index].minutes,
                                  maxLines: 1,
                                  style: Theme
                                      .of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .copyWith(
                                    color: Colors.grey[700],
                                    fontSize: 13.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                  ),
                )
              ],
            ),
          );
        }
    );
  }
}
