// ignore_for_file: camel_case_types, sized_box_for_whitespace, use_build_context_synchronously

import 'package:flutter/material.dart';
import '../welcome/network_handler.dart';
import 'login.dart';

class account extends StatefulWidget {
  const account({Key? key}) : super(key: key);

  @override
  State<account> createState() => _accountState();
}

class _accountState extends State<account> {
  bool vis = true;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  NetworkHandler networkHandler = NetworkHandler();
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController licenceController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isEmailTaken = false;
  String errorText = "";
  bool validate = false;
  bool circular = false;

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
              child: Form(
                key: _formKey,
                child: Center(
                  child: Container(
                    width: 500,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(height: 5),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          padding: EdgeInsets.all(10),
                          child: Image.asset('./assets/images/logo.png',
                              width: 100, height: 100),
                        ),
                        SizedBox(height: 30),
                        Text(
                          'Register to your account',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          controller: usernameController,
                          style: TextStyle(color: Colors.white),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Full Name can't be empty";
                            }
                            return null;
                          },
                          decoration:
                              inputDecoration('Full Name', icon: Icons.person),
                        ),
                        SizedBox(height: 10),
                        TextFormField(
                          controller: emailController,
                          style: TextStyle(color: Colors.white),
                          decoration:
                              inputDecoration('Email', icon: Icons.email),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Email can't be empty";
                            }
                            return null;
                          },
                        ),
                        if (isEmailTaken)
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              'This email is already registered.',
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        SizedBox(height: 10),
                        TextFormField(
                          controller: addressController,
                          style: TextStyle(color: Colors.white),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Address can't be empty";
                            }
                            return null;
                          },
                          decoration:
                              inputDecoration('Phone', icon: Icons.home),
                        ),
                        SizedBox(height: 10),
                        TextFormField(
                          controller: phoneController,
                          style: TextStyle(color: Colors.white),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Phone number can't be empty";
                            }
                            return null;
                          },
                          decoration: inputDecoration('Phone Number',
                              icon: Icons.phone),
                        ),
                        SizedBox(height: 10),
                        TextFormField(
                          controller: licenceController,
                          style: TextStyle(color: Colors.white),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "licence can't be empty";
                            }
                            return null;
                          },
                          decoration:
                              inputDecoration('licence', icon: Icons.key),
                        ),
                        SizedBox(height: 10),
                        TextFormField(
                          controller: passwordController,
                          style: TextStyle(color: Colors.white),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Password can't be empty";
                            }
                            if (value.length < 6) {
                              return "Password length must be greater than 6";
                            }
                            return null;
                          },
                          obscureText: vis,
                          decoration: inputDecoration(
                            'Password',
                            icon: Icons.lock,
                            suffixIcon: IconButton(
                              icon: Icon(
                                vis ? Icons.visibility_off : Icons.visibility,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                setState(() {
                                  vis = !vis;
                                });
                              },
                            ),
                          ),
                        ),
                        SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () async {
                            setState(() {
                              circular = true;
                            });
                            await checkemail();
                            if (_formKey.currentState!.validate() && validate) {
                              if (!isEmailTaken) {
                                Map<String, String> data = {
                                  "username": usernameController.text,
                                  "email": emailController.text,
                                  "address": addressController.text,
                                  "phoneNumber": phoneController.text,
                                  "licence": licenceController.text,
                                  "password": passwordController.text,
                                };

                                var response = await networkHandler.register(
                                    "/ngo/register", data);
                                if (response.statusCode == 200 ||
                                    response.statusCode == 201) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const Login(),
                                    ),
                                  );
                                } else {
                                  setState(() {
                                    circular = false;
                                  });
                                  showSnackBar(context, "Email Already Taken.");
                                }
                              } else {
                                setState(() {
                                  circular = false;
                                });
                                showSnackBar(context, errorText);
                              }
                            } else {
                              setState(() {
                                circular = false;
                              });
                              showSnackBar(context, errorText);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                          ),
                          child: circular
                              ? CircularProgressIndicator()
                              : Padding(
                                  padding: EdgeInsets.symmetric(vertical: 10.0),
                                  child: Text(
                                    'Signup',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
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

  checkemail() async {
    if (emailController.text.isEmpty) {
      setState(() {
        validate = false;
        errorText = "Email can't be empty";
      });
      showSnackBar(context, errorText);
    } else {
      var response = await networkHandler.checkEmail(emailController.text);
      if (response.statusCode == 409) {
        setState(() {
          validate = false;
          errorText = "Email already taken";
          isEmailTaken = true;
        });
        showSnackBar(context, errorText);
      } else if (response.statusCode == 200) {
        setState(() {
          validate = true;
          isEmailTaken = false;
        });
      } else {
        setState(() {
          validate = false;
          errorText = "Error checking email";
        });
        showSnackBar(context, errorText);
      }
    }
  }
}

// void main() {
//   runApp(MaterialApp(
//     home: account(),
//   ));
// }
