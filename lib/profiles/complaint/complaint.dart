// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, library_private_types_in_public_api, prefer_const_declarations, use_build_context_synchronously, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;

class ComplaintPage extends StatefulWidget {
  @override
  _ComplaintPageState createState() => _ComplaintPageState();
}

class _ComplaintPageState extends State<ComplaintPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  File? _selectedImage;

  final _formKey = GlobalKey<FormState>();

  Future<void> _pickImage() async {
    final imagePicker = ImagePicker();
    final pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  void _removeImage() {
    setState(() {
      _selectedImage = null;
    });
  }

  Future<void> _uploadImage() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    try {
      final url = 'http://192.168.18.73:5000/form/complaints/';
      final request = http.MultipartRequest('POST', Uri.parse(url));
      request.files.add(http.MultipartFile(
        'image',
        _selectedImage!.readAsBytes().asStream(),
        _selectedImage!.lengthSync(),
        filename: 'image.jpg',
      ));
      request.fields.addAll({
        'name': nameController.text,
        'email': emailController.text,
        'phoneNumber': phoneController.text,
        'address': addressController.text,
      });

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      // Handle the response as needed
      debugPrint('Response Code: ${response.statusCode}');
      debugPrint('Response Body: $responseBody');

      if (response.statusCode == 201) {
        // Display success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Complaint registered successfully!'),
            duration: Duration(seconds: 2),
          ),
        );

        // Reset input fields
        nameController.clear();
        emailController.clear();
        phoneController.clear();
        addressController.clear();
        setState(() {
          _selectedImage = null;
        });
      } else {
        // Display error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text('An error occurred while registering your complaint.'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      debugPrint('Error uploading image and sending data: $e');
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
                    'Register your Complaint',
                    style: TextStyle(color: Colors.white, fontSize: 26),
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
                            controller: nameController,
                            style: TextStyle(color: Colors.white),
                            decoration: inputDecoration('Full Name',
                                icon: Icons.person),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter your full name';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 16.0),
                          TextFormField(
                            controller: emailController,
                            style: TextStyle(color: Colors.white),
                            decoration:
                                inputDecoration('Email', icon: Icons.email),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter your email';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 16.0),
                          TextFormField(
                            controller: phoneController,
                            style: TextStyle(color: Colors.white),
                            decoration: inputDecoration('Phone Number',
                                icon: Icons.phone),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter your phone number';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 16.0),
                          TextFormField(
                            controller: addressController,
                            style: TextStyle(color: Colors.white),
                            decoration:
                                inputDecoration('Address', icon: Icons.home),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter your address';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 16.0),
                          ElevatedButton(
                            onPressed: () async {
                              await _pickImage();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(17.0),
                              ),
                            ),
                            child: Text(
                              'Pick Image',
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                          ),
                          SizedBox(height: 16.0),
                          if (_selectedImage != null)
                            Column(
                              children: [
                                Image.file(_selectedImage!,
                                    height: 200, width: 200),
                                SizedBox(height: 16.0),
                                ElevatedButton(
                                  onPressed: _removeImage,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    foregroundColor: Colors.black,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(17.0),
                                    ),
                                  ),
                                  child: Text(
                                    'Remove Image',
                                    style: TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          SizedBox(height: 16.0),
                          ElevatedButton(
                            onPressed: () async {
                              await _uploadImage();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(17.0),
                              ),
                            ),
                            child: Text(
                              'Submit Complaint',
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                          ),
                          SizedBox(height: 20), // Space at the bottom
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
