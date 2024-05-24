// ignore_for_file: use_build_context_synchronously, avoid_print

import 'dart:developer';

import 'package:flutter/material.dart';
import 'network_handler.dart';
import 'otpverify.dart';

class RequestOtpScreen extends StatefulWidget {
  const RequestOtpScreen({super.key});

  @override
  State<RequestOtpScreen> createState() => _RequestOtpScreenState();
}

class _RequestOtpScreenState extends State<RequestOtpScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _networkHandler = NetworkHandler();

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return "Email can't be empty";
    }
    return null;
  }

  void requestOtp() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      final response = await _networkHandler.requestOtp(
        _emailController.text,
      );

      log(response.toString());

      navigateTo(response);
    } catch (error) {
      log('Error: $error');
      final snackBar = SnackBar(content: Text('An error occurred: $error'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  void navigateTo(response) {
    final snackBar = SnackBar(content: Text(response['message']));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);

    if (response['status'] ?? false) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => VerifyOtpScreen(email: _emailController.text),
        ),
      );
    } else {
      print('Error: ${response['message']}');
    }
  }

  InputDecoration inputDecoration(String labelText, {IconData? icon}) {
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
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: const [Color(0xFF000428), Color(0xFF004e92)],
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
                    'Request OTP',
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
                            controller: _emailController,
                            style: TextStyle(color: Colors.white),
                            decoration:
                                inputDecoration('Email', icon: Icons.email),
                            validator: _validateEmail,
                          ),
                          SizedBox(height: 25.0),
                          ElevatedButton(
                            onPressed: requestOtp,
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
                                'Request OTP',
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
