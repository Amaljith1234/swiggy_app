import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:location/location.dart' as prefix;
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:swiggy_app/pages/live_tracking/Order%20Add/add_order_controller.dart';
import 'package:swiggy_app/pages/live_tracking/firebase_option.dart';
import 'package:swiggy_app/providers/account_provider.dart';
import 'package:swiggy_app/providers/address_provider.dart';
import 'package:swiggy_app/providers/cart_provider.dart';
import 'package:swiggy_app/providers/favorites_provider.dart';
import 'package:swiggy_app/providers/food_provider.dart';
import 'package:swiggy_app/providers/home_provider.dart';
import 'package:swiggy_app/providers/offer_provider.dart';
import 'package:swiggy_app/providers/orders_provider.dart';
import 'package:swiggy_app/providers/resturant_provider.dart';
import 'package:swiggy_app/providers/search_provider.dart';
import 'package:swiggy_app/utils/AppUtils.dart';
import 'package:swiggy_app/views/mobile/home_bottom_navigation_screen.dart';
import 'package:swiggy_app/views/tab_desktop/tab_screen.dart';
import 'pages/LoginPage/loginpage.dart';
import 'shared/app_theme.dart';
import 'views/tab_desktop/desktop_screen.dart';
import 'views/mobile/mobile_screen.dart';
import 'widgets/responsive.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: firebaseOptions);
  await requestLocationPermission();

  Get.put(AddOrderController());
  runApp(MultiProvider(providers: providers, child: const MyApp()),);
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Folo',
      debugShowCheckedModeBanner: false,
      theme: appPrimaryTheme(),
      home: const Responsive(
        mobile: MobileScreen(),
        tablet: MobileScreen(),
        desktop: DesktopScreen(),
      ),
    );
  }
}

Future<void> requestLocationPermission() async {
  PermissionStatus status = await Permission.location.request();

  if (!status.isGranted) {
    // If permission is denied, open app settings
    openAppSettings();
  }
}

List<SingleChildWidget> providers = [
  ChangeNotifierProvider<HomeDetailsProvider>(
      create: (_) => HomeDetailsProvider()),
  ChangeNotifierProvider<AccountProvider>(
      create: (_) => AccountProvider()),
  ChangeNotifierProvider<CartProvider>(
      create: (_) => CartProvider()),
  ChangeNotifierProvider<OfferProvider>(
      create: (_) => OfferProvider()),
  ChangeNotifierProvider<RestaurantProvider>(
      create: (_) => RestaurantProvider()),
  ChangeNotifierProvider<AddressProvider>(
      create: (_) => AddressProvider()),
  ChangeNotifierProvider<SearchProvider>(
      create: (_) => SearchProvider()),
  ChangeNotifierProvider<OrderProvider>(
      create: (_) => OrderProvider()),
  ChangeNotifierProvider<FavoriteProvider>(
      create: (_) => FavoriteProvider()),
  ChangeNotifierProvider<FoodProvider>(
      create: (_) => FoodProvider()),
];
