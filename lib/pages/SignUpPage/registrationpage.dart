import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../Utils/AppUtils.dart';
import '../../Utils/Network_Utils.dart';
import '../../Utils/Validate_utils.dart';
import '../../views/mobile/home_bottom_navigation_screen.dart';
import '../LoginPage/loginpage.dart';

class RegistrationScreen extends StatefulWidget {
  RegistrationScreen({Key? key}) : super(key: key);

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? name;
  String? phone;
  String? hotelLocationCoordinatesLat;
  String? hotelLocationCoordinatesLog;
  String? email;
  String? password;

  String? label;
  String? street;
  String? city;
  String? state;
  String? country;
  String? zipCode;

  String message = '';
  int _login_btn_state = 0;
  bool _isObscured = true;
  String address = '';

  LatLng? currentLocation;
  Placemark? placemark;

  Future<void> fetchAddress() async {
    try {
      Placemark? address = await AppUtil.getAddressFromLatLng(currentLocation!);
      setState(() {
        placemark = address;
      });
    } catch (e) {
      print("Error getting location: $e");
    }
  }

  Future<void> fetchLocation() async {
    try {
      LatLng location = await AppUtil.getCurrentLocation();
      setState(() {
        currentLocation = location;
      });
      // debugPrint("latitude : "+currentLocation!.latitude.toString());
      // debugPrint("longitue : "+currentLocation!.longitude.toString());
    } catch (e) {
      print("Error getting location: $e");
    }
  }

  Future<void> submit() async {
    fetchAddress();
    fetchLocation();

    final form = _formKey.currentState;
    form!.validate();

    String? email_error = Validate.validateEmail(email!);
    if (email_error != null) {
      AppUtil.showToast(context, email_error);
      return;
    }

    String? password_error;
    // Check if password is null or empty
    if (password == null || password!.isEmpty) {
      password_error = "Password required";
    } else if (password!.length < 6) {
      password_error = "Password must be at least 6 characters";
    }

    if (password_error != null) {
      AppUtil.showToast(context, password_error);
      return;
    }

    String? phone_error;
    // Check if password is null or empty
    if (phone == null || phone!.isEmpty) {
      phone_error = "Phone number required";
    } else if (phone!.length != 10) {
      phone_error = "Phone Number must be 10 characters";
    }

    if (phone_error != null) {
      AppUtil.showToast(context, phone_error);
      return;
    }

    if (placemark == null) {
      AppUtil.showToast(context, "Could not fetch address. Please try again.");
      return;
    }


    signUp(
      email: email!,
      password: password!,
      name: name!,
      phone: phone!,
      hotelLocationCoordinatesLat: currentLocation!.latitude.toString(),
      hotelLocationCoordinatesLng: currentLocation!.longitude.toString(),
      label: 'Home',
      street: placemark!.street.toString(),
      city: placemark!.locality.toString(),
      state: placemark!.administrativeArea.toString(),
      country: placemark!.country.toString(),
      zipCode: placemark!.postalCode.toString(),
    );
  }

  Future<void> signUp({
    required String email,
    required String password,
    required String name,
    required String phone,
    required String hotelLocationCoordinatesLat,
    required String hotelLocationCoordinatesLng,

    required String label,
    required String street,
    required String city,
    required String state,
    required String country,
    required String zipCode,
  }) async {
    setState(() {
      _login_btn_state = 1;
    });

    Map<String, String> data = {
      'name': name,
      'email': email,
      'password': password,
      'phone': phone,

      'label': label,
      'street': street,
      'city': city,
      'state': state,
      'country': country,
      'zipCode': zipCode,
      'locationCoordinatesLat': hotelLocationCoordinatesLat,
      'locationCoordinatesLng': hotelLocationCoordinatesLng,
    };

    try {
      final response = await NetworkUtil.post(NetworkUtil.customer_signUp_url, body: data);

      setState(() {
        _login_btn_state = 0;
      });

      debugPrint("Response body: ${response.body}");
      debugPrint("Status: ${response.statusCode}");

      var result = json.decode(response.body);

      if (response.statusCode == 200) {
        if (result['success'] == true) {
          var data = result['data'];
          var token = data['user']['token'];
          await AppUtil.setToken('token', token);
          debugPrint("Token saved: $token");

          AppUtil.showToast(context, "Registration Successful!");
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => HomeBottomNavigationScreen()),
            (Route<dynamic> route) => false,
          );
        } else {
          AppUtil.showToast(
              context, result['message'] ?? "Something went wrong!");
        }
      } else {
        var errorMessage = result['errors']?['message'] ?? "An error occurred. Please try again.";
        AppUtil.showToast(context, errorMessage);
        // AppUtil.showToast(context,
        //     result['message'] ?? "An error occurred. Please try again.");
      }
    } catch (error) {
      setState(() {
        _login_btn_state = 0;
      });
      AppUtil.showToast(context, "Error: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    fetchLocation();
    fetchAddress();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Top Section with Orange Background
              Container(
                color: Colors.orange,
                width: double.infinity,
                height: 250,
                child: Column(
                  children: [
                    const SizedBox(height: 80),
                    const Icon(
                      Icons.person_add_alt_1_outlined,
                      size: 60,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Create Your Account",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // Name Field
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextFormField(
                    keyboardType: TextInputType.text,
                    decoration: CustomInputDecoration(
                        labelText: 'Name', icon: Icon(Icons.perm_identity)),
                    validator: (value) {
                      name = value!.trim();
                      return;
                    }),
              ),

              const SizedBox(height: 20),

              // Email Field
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextFormField(
                    // keyboardType: TextInputType.emailAddress,
                    decoration: CustomInputDecoration(
                        labelText: 'Email ID',
                        icon: Icon(Icons.email_outlined)),
                    validator: (value) {
                      email = value!.trim();
                      return;
                    }),
              ),

              const SizedBox(height: 20),

              //PHONE
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextFormField(
                    keyboardType: TextInputType.phone,
                    decoration: CustomInputDecoration(
                        labelText: 'Phone',
                        icon: Icon(Icons.phone_android_outlined)),
                    validator: (value) {
                      phone = value!.trim();
                      return;
                    }),
              ),

              const SizedBox(height: 20),

              // Password Field
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextFormField(
                    obscureText: _isObscured,
                    decoration: InputDecoration(
                      labelText: "Password",
                      prefixIcon: Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _isObscured = !_isObscured;
                            });
                          },
                          icon: Icon(
                            _isObscured
                                ? Icons.visibility
                                : Icons.visibility_off,
                          )),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.orange),
                      ),
                    ),
                    validator: (value) {
                      password = value!.trim();
                      return;
                    }),
              ),

              const SizedBox(height: 20),

              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 20),
              //   child: TextFormField(
              //     controller: _locationController,
              //     onTap: () async {
              //       final result = await Navigator.push(
              //           context,
              //           MaterialPageRoute(
              //               builder: (context) =>
              //                   MapPicker(Location: _initialLocation)));
              //       LatLng? location = result as LatLng?;
              //       if (location != null) {
              //         _initialLocation = location;
              //         Placemark? placemark =
              //             await AppUtil.getAddressFromLatLng(
              //             _initialLocation!);
              //         if (placemark == null) {
              //           _locationController.text = "Unknown Address";
              //         } else {
              //           _locationController.text =
              //           '${placemark.subLocality}, ${placemark.locality}';
              //         }
              //         setState(() {});
              //       }
              //     },
              //     readOnly: true,
              //       decoration: InputDecoration(
              //         labelText: "Location",
              //         prefixIcon: Icon(Icons.location_on),
              //         suffixIcon: IconButton(
              //             key: _key,
              //             onPressed: () => _showOverlay(context),
              //             icon: Icon(Icons.info_outline)),
              //         border: OutlineInputBorder(
              //           borderRadius: BorderRadius.circular(10),
              //         ),
              //         focusedBorder: OutlineInputBorder(
              //           borderRadius: BorderRadius.circular(10),
              //           borderSide: const BorderSide(color: Colors.orange),
              //         ),
              //       ),
              //       validator: (value) {
              //       hotelLocationCoordinatesLog = _initialLocation!.longitude.toString();
              //       hotelLocationCoordinatesLat = _initialLocation!.latitude.toString();
              //         if (value == null || value.isEmpty) {
              //           return "Please select a location";
              //         }
              //         return null;
              //       }),
              // ),

              const SizedBox(height: 20),

              // Register Button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        if (_login_btn_state == 0) {
                          submit();
                        }
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: _login_btn_state == 0
                        ? Text(
                            "REGISTER",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        : CircularProgressIndicator(color: Colors.white),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Already have an account? then"),
                  SizedBox(
                    width: 5,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              LoginScreen(), // Replace with your RegistrationScreen
                        ),
                      );
                    },
                    child: Text(
                      "LOG IN",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.orange,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 40),

              // Terms and Conditions
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 40),
                child: Text(
                  "By registering, you agree to our Terms & Conditions and Privacy Policy.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

InputDecoration CustomInputDecoration(
    {required String labelText, required Icon icon}) {
  return InputDecoration(
    labelText: labelText,
    prefixIcon: icon,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: Colors.orange),
    ),
  );
}
