// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api, use_build_context_synchronously

import 'dart:developer';
import 'package:flutter/material.dart';
import 'loginpage.dart';
import 'network_handler.dart';

class VerifyOtpScreen extends StatefulWidget {
  final String email;

  const VerifyOtpScreen({required this.email});

  @override
  _VerifyOtpScreenState createState() => _VerifyOtpScreenState();
}

class _VerifyOtpScreenState extends State<VerifyOtpScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _otpController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _verifyPasswordController =
      TextEditingController();

  final NetworkHandler _networkHandler = NetworkHandler();

  bool _isNewPasswordVisible = false;
  bool _isVerifyPasswordVisible = false;

  String? _validateOtp(String? value) {
    if (value == null || value.isEmpty) {
      return "OTP can't be empty";
    }
    return null;
  }

  String? _validateNewPassword(String? value) {
    if (value == null || value.isEmpty) {
      return "New password can't be empty";
    }
    return null;
  }

  String? _validateVerifyPassword(String? value) {
    if (value == null || value.isEmpty) {
      return "Verify password can't be empty";
    }
    if (value != _newPasswordController.text) {
      return "Passwords do not match";
    }
    return null;
  }

  void verifyOtp() async {
    if (_formKey.currentState!.validate()) {
      try {
        final response = await _networkHandler.verifyOtp(
          widget.email,
          _otpController.text,
          _newPasswordController.text,
        );
        log(response.toString());

        final snackBar = SnackBar(content: Text(response['message']));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);

        if (response['status'] ?? true) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => LoginPage(),
            ),
          );
        } else {
          log('Error: ${response['message']}');
        }
      } catch (error) {
        log('Error: $error');
        final snackBar = SnackBar(content: Text('An error occurred: $error'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }
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
      suffixIcon: suffixIcon,
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
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
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  SizedBox(height: 60),
                  Text(
                    'Verify OTP',
                    style: TextStyle(color: Colors.white, fontSize: 40),
                  ),
                  SizedBox(height: 40),
                  Container(
                    constraints: BoxConstraints(maxWidth: 500),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          TextFormField(
                            controller: _otpController,
                            style: TextStyle(color: Colors.white),
                            decoration:
                                inputDecoration('OTP', icon: Icons.security),
                            validator: _validateOtp,
                          ),
                          SizedBox(height: 16.0),
                          TextFormField(
                            controller: _newPasswordController,
                            obscureText: !_isNewPasswordVisible,
                            style: TextStyle(color: Colors.white),
                            decoration: inputDecoration(
                              'New Password',
                              icon: Icons.lock_outline,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _isNewPasswordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isNewPasswordVisible =
                                        !_isNewPasswordVisible;
                                  });
                                },
                              ),
                            ),
                            validator: _validateNewPassword,
                          ),
                          SizedBox(height: 16.0),
                          TextFormField(
                            controller: _verifyPasswordController,
                            obscureText: !_isVerifyPasswordVisible,
                            style: TextStyle(color: Colors.white),
                            decoration: inputDecoration(
                              'Verify Password',
                              icon: Icons.lock,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _isVerifyPasswordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isVerifyPasswordVisible =
                                        !_isVerifyPasswordVisible;
                                  });
                                },
                              ),
                            ),
                            validator: _validateVerifyPassword,
                          ),
                          SizedBox(height: 25.0),
                          ElevatedButton(
                            onPressed: verifyOtp,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 10.0),
                              child: Text(
                                'Verify OTP and Reset Password',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          SizedBox(height: 60),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
