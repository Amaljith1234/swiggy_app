import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../models/API_models/address_model.dart';
import '../../providers/address_provider.dart';
import '../../providers/cart_provider.dart';
import '../../views/mobile/home_bottom_navigation_screen.dart';
import '../account/account_screen.dart';
import '../account/my_account/address/address_list.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AddressProvider>(context, listen: false).fetchAddresses();
      Provider.of<CartProvider>(context, listen: false).fetchCartData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final addressProvider = Provider.of<AddressProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                GestureDetector(
                  onTap: () async {
                    final selectedAddress =
                        await showModalBottomSheet<AddressModel>(
                      context: context,
                      isScrollControlled: true, // Enables full height control
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
                  child: Row(
                    children: [
                      Icon(
                        addressProvider.selectedAddress == null
                            ? Icons.location_off
                            : Icons.location_on,
                        size: 20,
                      ),
                      Text(
                        '${addressProvider.selectedAddress?.street ?? "Location"}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.black87,
                        ),
                      ),
                      Icon(
                        Icons.keyboard_arrow_down_sharp,
                        size: 20,
                      )
                    ],
                  ),
                ),
                Text(
                  '${addressProvider.selectedAddress?.city ?? "City"}, ${addressProvider.selectedAddress?.state ?? "State"}, ${addressProvider.selectedAddress?.zipCode ?? "ZipCode"}',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AccountScreen()),
                );
              },
              child: CircleAvatar(
                radius: 20,
                backgroundColor: Colors.black,
                child: Icon(
                  Icons.person,
                  color: Colors.white,
                ),
              ),
            )
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Search Bar
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => HomeBottomNavigationScreen(
                              selectedIndex: 2,
                            )),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 20),
                  child: AbsorbPointer(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search',
                        hintStyle: TextStyle(color: Colors.grey),
                        prefixIcon: Icon(Icons.search, color: Colors.grey),
                        filled: true,
                        fillColor: Colors.grey[200],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Image Section
              Image.asset(
                'assets/images/banner0.jpeg',
                height: 220,
                width: double.infinity,
                fit: BoxFit.cover,
              ),

              // Two Horizontal Sections (Food Delivery & Instamart)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: <Widget>[
                    _buildServiceCard(
                      title: 'FOOD DELIVERY',
                      subtitle: 'FLASH SALE, LIVE NOW\nFLAT 50% OFF',
                      image: 'assets/icons/foodicon.png',
                      nextPage: HomeBottomNavigationScreen(
                        selectedIndex: 1,
                      ),
                      context: context, // Replace with your image path
                    ),
                    SizedBox(height: 4),
                    _buildServiceCard(
                      title: 'GROCERIES',
                      subtitle: '\n(coming soon...)',
                      image: 'assets/icons/groceries.png',
                      nextPage: HomeBottomNavigationScreen(selectedIndex: 0,),
                      context: context, // Replace with your image path
                    ),
                    SizedBox(height: 4),
                    _buildServiceCard(
                        title: 'DINING',
                        subtitle: '\n(coming soon...)',
                        image: 'assets/icons/food0.png',
                        nextPage: HomeBottomNavigationScreen(selectedIndex: 0,),
                        context: context)
                  ],
                ),
              ),

              SizedBox(height: 16),

              // Live it up! Section
              Container(
                height: 300,
                width: double.infinity,
                color: Colors.black12,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                  child: Row(
                    children: [
                      Text(
                        'Live\nit up!',
                        style: GoogleFonts.kanit(
                          fontSize: 86,
                          color: Colors.black38,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Image.asset('assets/icons/kawaii-sushi.png',
                          height: 100, fit: BoxFit.cover)
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildServiceCard({
    required String title,
    required String subtitle,
    required String image,
    required BuildContext context,
    required Widget nextPage,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => nextPage),
        );
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    title,
                    style: GoogleFonts.roboto(
                      fontWeight: FontWeight.w900,
                      fontSize: 20,
                      color: Colors.black54,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              Image.asset(image, width: 100, fit: BoxFit.cover),
            ],
          ),
        ),
      ),
    );
  }
}
