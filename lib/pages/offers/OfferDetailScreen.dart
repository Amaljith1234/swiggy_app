import 'package:flutter/material.dart';

import '../../models/API_models/offer_model.dart';
import '../../utils/ui_helper.dart';

class OfferDetails extends StatefulWidget {
  final Offer offer; // Accept offer data

  const OfferDetails({Key? key, required this.offer}) : super(key: key);

  @override
  State<OfferDetails> createState() => _OfferDetailsState();
}

class _OfferDetailsState extends State<OfferDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // actions: [
        //   IconButton(
        //     icon: Icon(Icons.favorite_border),
        //     onPressed: () {},
        //   ),
        //   IconButton(
        //     icon: Icon(Icons.search),
        //     onPressed: () {},
        //   ),
        // ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.offer.name,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4),
            Text(
              widget.offer.tagLine,
              style: TextStyle(color: Colors.grey[700]),
            ),
            SizedBox(height: 4),
            // Text(
            //   "70605 Stanley Road, Tayaboro, Mississippi, 81224-3218",
            //   style: TextStyle(color: Colors.grey[700]),
            // ),
            Divider(height: 30, thickness: 1),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Text("2.7", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    Text("Packaging 80%")
                  ],
                ),
                Column(
                  children: [
                    Text("29 mins", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    Text("Delivery Time")
                  ],
                ),
                Column(
                  children: [
                    Text('${euro} ${widget.offer.deductionAmount}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    Text("For Two")
                  ],
                ),
              ],
            ),
            Divider(height: 30, thickness: 1),
            ListTile(
              leading: Icon(Icons.local_offer, color: Colors.red),
              title: Text("30% off up to ${euro} 75 | Use code SWIGGYIT"),
            ),
            ListTile(
              leading: Icon(Icons.local_offer, color: Colors.red),
              title: Text("20% off up to ${euro} 100 with SBI credit cards, once per week | Use code 100SBI"),
            ),
            // SizedBox(height: 16),
            // Row(
            //   children: [
            //     Icon(Icons.verified, color: Colors.green),
            //     SizedBox(width: 8),
            //     Text("PURE VEG", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            //   ],
            // ),
            // Divider(height: 30, thickness: 1),
            // Text("Recommended", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            // SizedBox(height: 10),
            // GridView.builder(
            //   shrinkWrap: true,
            //   physics: NeverScrollableScrollPhysics(),
            //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            //     crossAxisCount: 2,
            //     crossAxisSpacing: 10,
            //     mainAxisSpacing: 10,
            //     childAspectRatio: 0.7,
            //   ),
            //   itemCount: 2,
            //   itemBuilder: (context, index) {
            //     return Card(
            //       elevation: 3,
            //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            //       child: Column(
            //         crossAxisAlignment: CrossAxisAlignment.start,
            //         children: [
            //           Expanded(
            //             child: Container(
            //               decoration: BoxDecoration(
            //                 image: DecorationImage(
            //                   image: AssetImage("assets/restaurant.jpg"),
            //                   fit: BoxFit.cover,
            //                 ),
            //                 borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
            //               ),
            //             ),
            //           ),
            //           Padding(
            //             padding: EdgeInsets.all(8.0),
            //             child: Column(
            //               crossAxisAlignment: CrossAxisAlignment.start,
            //               children: [
            //                 Text("Tasty Concrete Ball", style: TextStyle(fontWeight: FontWeight.bold)),
            //                 SizedBox(height: 4),
            //                 Text("BREAKFAST", style: TextStyle(color: Colors.grey[600])),
            //                 SizedBox(height: 4),
            //                 Row(
            //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //                   children: [
            //                     Text("Rs 533.05"),
            //                     ElevatedButton(
            //                       onPressed: () {},
            //                       child: Text("ADD"),
            //                     ),
            //                   ],
            //                 ),
            //               ],
            //             ),
            //           ),
            //         ],
            //       ),
            //     );
            //   },
            // ),
          ],
        ),
      ),
    );
  }
}