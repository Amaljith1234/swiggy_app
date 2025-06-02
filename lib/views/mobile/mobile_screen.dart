import 'package:flutter/material.dart';
import 'package:swiggy_app/pages/LoginPage/loginpage.dart';
import 'package:swiggy_app/views/mobile/home_bottom_navigation_screen.dart';
import '../../utils/AppUtils.dart';

class MobileScreen extends StatefulWidget {
  const MobileScreen({Key? key}) : super(key: key);

  @override
  State<MobileScreen> createState() => _MobileScreenState();
}

class _MobileScreenState extends State<MobileScreen> {
  Widget _initialScreen = const Scaffold(body: Center(child: CircularProgressIndicator()));

  @override
  void initState() {
    super.initState();
    _checkToken();
  }

  Future<void> _checkToken() async {
    String? token = await AppUtil.getToken();

    setState(() {
      _initialScreen = token != null ? HomeBottomNavigationScreen() : LoginScreen();
    });
  }

  @override
  Widget build(BuildContext context) {
    return _initialScreen;
  }
}
