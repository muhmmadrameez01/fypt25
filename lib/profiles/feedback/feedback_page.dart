// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_final_fields, library_private_types_in_public_api, use_key_in_widget_constructors, use_build_context_synchronously

import 'package:flutter/material.dart';
import '../welcome/network_handler.dart';

class FeedbackPage extends StatefulWidget {
  @override
  _FeedbackPageState createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController subjectController = TextEditingController();
  TextEditingController feedbackController = TextEditingController();
  NetworkHandler networkHandler = NetworkHandler();
  bool circular = false;

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
        borderRadius: BorderRadius.circular(12.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white),
        borderRadius: BorderRadius.circular(12.0),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white.withOpacity(0.8)),
        borderRadius: BorderRadius.circular(12.0),
      ),
      filled: true,
      fillColor: Colors.white.withOpacity(0.1),
      contentPadding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
      alignLabelWithHint: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  SizedBox(height: 20),
                  Text(
                    'User Feedback',
                    style: TextStyle(color: Colors.white, fontSize: 40),
                  ),
                  SizedBox(height: 40),
                  Icon(
                    Icons.feedback,
                    size: 80.0,
                    color: Colors.white,
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
                            decoration: inputDecoration('Your Name',
                                icon: Icons.person),
                          ),
                          SizedBox(height: 16.0),
                          TextFormField(
                            controller: subjectController,
                            style: TextStyle(color: Colors.white),
                            decoration: inputDecoration('Contact Information',
                                icon: Icons.contact_mail),
                          ),
                          SizedBox(height: 16.0),
                          TextFormField(
                            controller: feedbackController,
                            style: TextStyle(color: Colors.white),
                            maxLines: 5,
                            decoration: inputDecoration('Your Feedback'),
                          ),
                          SizedBox(height: 32.0),
                          ElevatedButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                setState(() {
                                  circular = true;
                                });
                                Map<String, String> data = {
                                  "name": nameController.text,
                                  "subject": subjectController.text,
                                  "feedback": feedbackController.text,
                                };
                                var response =
                                    await networkHandler.submitFeedback(data);
                                if (response.statusCode == 201) {
                                  showSnackBar(context,
                                      "Feedback submitted successfully!");
                                } else {
                                  showSnackBar(context,
                                      "Error submitting feedback. Please try again.");
                                }
                                setState(() {
                                  circular = false;
                                });
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 16.0),
                              child: circular
                                  ? CircularProgressIndicator()
                                  : Text(
                                      'Submit Feedback',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                            ),
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

  void showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
