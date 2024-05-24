// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../ngo_dashboard/login.dart';
import '../widgets/NavigationBar.dart';
import 'loginpage.dart';

class Welcome extends StatelessWidget {
  const Welcome({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox.expand(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF000428),
                  Color(0xFF004e92),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isMobile = constraints.maxWidth < 600;
                final buttonWidth =
                    isMobile ? double.infinity : constraints.maxWidth * 0.5;

                return Container(
                  constraints:
                      BoxConstraints(maxWidth: 600), // Limit content width
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Image.asset(
                          'assets/images/logo.png',
                          width: MediaQuery.of(context).size.width *
                              0.2, // Adjust image width
                          height: MediaQuery.of(context).size.width *
                              0.2, // Adjust image height
                        ),
                      ),
                      SizedBox(height: 20), // Reduced spacing
                      Text(
                        'Mehfooz Aashiyana',
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: 40), // Reduced spacing
                      SizedBox(
                        width: buttonWidth,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginPage()),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromARGB(255, 255, 255, 255),
                            padding: EdgeInsets.symmetric(
                              vertical: 18.0, // Reduced padding
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  25), // Adjusted border radius
                            ),
                          ),
                          child: Text(
                            'USER SIGN IN',
                            style: TextStyle(
                              color: const Color.fromRGBO(13, 71, 161, 1),
                              fontSize: 18, // Reduced font size
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10), // Reduced spacing
                      SizedBox(
                        width: buttonWidth,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => Login()),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromARGB(255, 255, 255, 255),
                            padding: EdgeInsets.symmetric(
                              vertical: 18.0, // Reduced padding
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  25), // Adjusted border radius
                            ),
                          ),
                          child: Text(
                            'NGO SIGN IN',
                            style: TextStyle(
                              color: const Color.fromRGBO(13, 71, 161, 1),
                              fontSize: 18, // Reduced font size
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10), // Reduced spacing
                      SizedBox(
                        width: buttonWidth,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CustomNavigationBar(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(
                              vertical: 18.0, // Reduced padding
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  25), // Adjusted border radius
                            ),
                          ),
                          child: Text(
                            'GUEST MODE',
                            style: TextStyle(
                              color: const Color.fromRGBO(13, 71, 161, 1),
                              fontSize: 18, // Reduced font size
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
