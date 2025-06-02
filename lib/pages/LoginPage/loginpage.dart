import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:swiggy_app/views/mobile/home_bottom_navigation_screen.dart';
import '../../utils/AppUtils.dart';
import '../../utils/Network_Utils.dart';
import '../../utils/Validate_utils.dart';
import '../SignUpPage/registrationpage.dart';
import 'forgot password/forgot_password.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? email;
  String? password;
  String message = '';
  int _login_btn_state = 0;
  bool _isObscured = true;

  Future<void> submit() async {
    final form = _formKey.currentState;
    form!.validate();

    // String? email_error = Validate.validateEmail(email!);
    // if (email_error != null) {
    //   AppUtil.showToast(context, email_error);
    //   return;
    // }

    String? password_error =
        Validate.requiredField(password!, "Password required");
    if (password_error != null) {
      AppUtil.showToast(context, password_error);
      return;
    }

    login(email: email!, password: password!);
  }

  Future<void> login({required String email, required String password}) async {
    setState(() {
      _login_btn_state = 1;
    });

    Map<String, String> data = {
      'email': email,
      'password': password,
    };

    try {
      final response =
          await NetworkUtil.post(NetworkUtil.customer_login_url, body: data);

      debugPrint("Response body: ${response.body}");
      debugPrint("Status: ${response.statusCode}");

      if (response.statusCode == 200) {
        var result = json.decode(response.body);

        if (result['success'] == true) {
          var data = result['data'];
          var token = data['user']['token'];

          if (token != null && token.isNotEmpty) {
            await AppUtil.setToken('token', token);
            debugPrint("Token saved: $token");
          } else {
            debugPrint("Token is empty or null");
          }

          if (mounted) {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (context) =>
                      HomeBottomNavigationScreen(selectedIndex: 0)),
              (Route<dynamic> route) => false,
            );
          }
        } else {
          AppUtil.showToast(context, result['message']);
        }
      } else {
        var errorResult = json.decode(response.body);
        AppUtil.showToast(context,
            "${errorResult['message']} : Login failed! Please try again.");
      }
    } catch (e) {
      debugPrint("Login Error: $e");
      AppUtil.showToast(
          context, "An error occurred. Please check your connection.");
    } finally {
      if (mounted) {
        setState(() {
          _login_btn_state = 0;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      Icons.lock_outline,
                      size: 60,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Welcome Back!",
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

              // Email Field
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextFormField(
                    //controller: _emailController,
                    //keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: "Email ID",
                      prefixIcon: const Icon(Icons.email_outlined),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.orange),
                      ),
                    ),
                    validator: (value) {
                      email = value!.trim();

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
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _isObscured = !_isObscured;
                            });
                          },
                          icon: Icon(_isObscured
                              ? Icons.visibility
                              : Icons.visibility_off)),
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

              const SizedBox(height: 10),

              // Forgot Password
              Padding(
                padding: const EdgeInsets.only(right: 20),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => ForgotPasswordPage()));
                    },
                    child: Center(
                      child: const Text(
                        "Forgot Password?",
                        style: TextStyle(
                          color: Colors.orange,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Login Button
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
                    // Navigator.pushReplacement(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => HomeBottomNavigationScreen(),
                    //   ),
                    // );
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: _login_btn_state == 0
                        ? Text(
                            "LOGIN",
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

              // Sign Up Button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: OutlinedButton(
                    onPressed: () {
                      // Navigate to Registration Screen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              RegistrationScreen(), // Replace with your RegistrationScreen
                        ),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.orange),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      "SIGN UP",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.orange,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Terms and Conditions
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 40),
                child: Text(
                  "By logging in, you agree to our Terms & Conditions and Privacy Policy.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
