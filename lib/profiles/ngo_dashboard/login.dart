// ignore_for_file: use_build_context_synchronously, unrelated_type_equality_checks

// import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../welcome/network_handler.dart';
import 'create_account.dart';

// import 'otprequest.dart';
// import 'signup.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _obscurePassword = true;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final storage = FlutterSecureStorage();
  String _errorText = "";
  String? _emailError;
  String? _passwordError;
  bool _isLoading = false;
  bool _isConnected = true;

  Future<void> _checkInternetConnection() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        _isConnected = false;
      });
      _showNoInternetDialog();
    } else {
      setState(() {
        _isConnected = true;
      });
    }
  }

  void _showNoInternetDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("No Internet Connection"),
          content: Text("Please check your internet connection and try again."),
          actions: <Widget>[
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  InputDecoration inputDecoration(String labelText,
      {IconData? icon, IconButton? suffixIcon}) {
    return InputDecoration(
      hintText: labelText,
      hintStyle: TextStyle(color: Colors.white),
      prefixIcon: icon != null
          ? Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.0),
              child: Icon(icon, color: Colors.white, size: 20),
            )
          : null,
      border: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white),
        borderRadius: BorderRadius.circular(8.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white),
        borderRadius: BorderRadius.circular(8.0),
      ),
      filled: true,
      fillColor: Colors.white.withOpacity(0.1),
      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      suffixIcon: suffixIcon,
    );
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    // Add more complex email validation if needed
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    // Add more complex password validation if needed
    return null;
  }

  void _login() async {
    await _checkInternetConnection();

    if (_formKey.currentState!.validate() && _isConnected) {
      setState(() {
        _isLoading = true;
        _errorText = "";
        _emailError = _validateEmail(_emailController.text);
        _passwordError = _validatePassword(_passwordController.text);
      });

      if (_emailError == null && _passwordError == null) {
        Map<String, String> data = {
          "email": _emailController.text,
          "password": _passwordController.text,
        };

        var response = await NetworkHandler().post("/ngo/login", data);

        if (response.statusCode == 200 || response.statusCode == 201) {
          String? username =
              await NetworkHandler().getUserNgoFromEmail(_emailController.text);
          if (username != null) {
            await NetworkHandler().storeUsername(username);
            Navigator.pushReplacementNamed(context, '/navbar');
          } else {
            setState(() {
              _errorText = "Failed to fetch username";
              _isLoading = false;
            });
          }
        } else {
          setState(() {
            _errorText = "Either email or password is incorrect";
            _isLoading = false;
          });
        }
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final viewInsets = MediaQuery.of(context).viewInsets;
    final isKeyboardVisible = viewInsets.bottom != 0;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF000428), Color(0xFF004e92)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.only(
              left: 30,
              right: 30,
              bottom: isKeyboardVisible ? viewInsets.bottom : 0,
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: 600,
                minHeight: MediaQuery.of(context).size.height,
              ),
              child: IntrinsicHeight(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Spacer(flex: isKeyboardVisible ? 1 : 2),
                    Container(
                      padding: EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Image.asset(
                        'assets/images/logo.png',
                        width: screenWidth * 0.1,
                        height: screenWidth * 0.1,
                      ),
                    ),
                    SizedBox(height: 30),
                    Text(
                      'Login to your account',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            style: TextStyle(color: Colors.white),
                            decoration: inputDecoration(
                              'Email',
                              icon: Icons.email,
                            ),
                            validator: (value) => _validateEmail(value),
                          ),
                          if (_emailError != null)
                            Padding(
                              padding: EdgeInsets.only(top: 8.0),
                              child: Text(
                                _emailError!,
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          SizedBox(height: 20),
                          TextFormField(
                            controller: _passwordController,
                            obscureText: _obscurePassword,
                            style: TextStyle(color: Colors.white),
                            decoration: inputDecoration(
                              'Password',
                              icon: Icons.lock,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
                              ),
                            ),
                            validator: (value) => _validatePassword(value),
                          ),
                          if (_passwordError != null)
                            Padding(
                              padding: EdgeInsets.only(top: 8.0),
                              child: Text(
                                _passwordError!,
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          SizedBox(height: 20),
                          _isLoading
                              ? CircularProgressIndicator()
                              : ElevatedButton(
                                  onPressed: _login,
                                  child: Container(
                                    width: double.infinity,
                                    padding:
                                        EdgeInsets.symmetric(vertical: 15.0),
                                    child: Center(
                                      child: Text(
                                        'Login',
                                        style: TextStyle(fontSize: 18),
                                      ),
                                    ),
                                  ),
                                ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Don't have an account?",
                                style: TextStyle(color: Colors.white),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => account(),
                                    ),
                                  );
                                },
                                child: Text(
                                  'Signup',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                          TextButton(
                            onPressed: () {
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //     builder: (context) => RequestOtpScreen(),
                              //   ),
                              // );
                            },
                            child: Text(
                              'Forget Password?',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            _errorText,
                            style: TextStyle(color: Colors.red),
                          ),
                        ],
                      ),
                    ),
                    Spacer(flex: isKeyboardVisible ? 1 : 2),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
