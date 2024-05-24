// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_final_fields, library_private_types_in_public_api, use_build_context_synchronously, avoid_print

import 'package:flutter/material.dart';

import '../welcome/network_handler.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  NetworkHandler networkHandler = NetworkHandler();

  String? _validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'Username is required';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    if (!value.contains('@')) {
      return 'Invalid email address';
    }
    return null;
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

  void updateUsername() async {
    String email = emailController.text;
    String newUsername = usernameController.text;

    try {
      String? token = await networkHandler.getToken(); // Retrieve the token
      if (token != null) {
        await networkHandler.updateUsername(email, newUsername, token);

        // Show a SnackBar to indicate that the username was successfully updated
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Username successfully updated'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        // Handle the case where token is null
        throw Exception('Token is null');
        // ignore: dead_code
        print(token);
      }
    } catch (e) {
      // Show a SnackBar with an error message if updating username fails
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update username: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
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
                  SizedBox(height: 80),
                  Text(
                    'Edit Profile',
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
                            controller: emailController,
                            style: TextStyle(color: Colors.white),
                            decoration:
                                inputDecoration('Email', icon: Icons.email),
                            validator: _validateEmail,
                          ),
                          SizedBox(height: 16.0),
                          TextFormField(
                            controller: usernameController,
                            style: TextStyle(color: Colors.white),
                            decoration:
                                inputDecoration('Username', icon: Icons.person),
                            validator: _validateUsername,
                          ),
                          SizedBox(height: 16.0),
                          ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                updateUsername();
                                // Form is valid, you can proceed with saving the profile
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.black,
                            ),
                            child: Text('Save Profile'),
                          ),
                          SizedBox(height: 20),
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

  // Method to update username
  

