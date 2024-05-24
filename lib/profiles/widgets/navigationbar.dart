import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

import '../about us/aboutinfo.dart';
import '../about us/faq_bttom.dart';
import '../complaint/complaint.dart';
import '../main_profile.dart';

class CustomNavigationBar extends StatefulWidget {
  const CustomNavigationBar({super.key});

  @override
  State<CustomNavigationBar> createState() => _CustomNavigationBarState();
}

final screens = [
  ProfileScreen(),
  InformationPage(),
  FAQPage(),
  ComplaintPage()
];
int index = 0;

class _CustomNavigationBarState extends State<CustomNavigationBar> {
  final items = const [
    Icon(
      Icons.home,
      color: Colors.white,
    ),
    Icon(
      Icons.info_sharp,
      color: Colors.white,
    ),
    Icon(
      Icons.message,
      color: Colors.white,
    ),
    Icon(
      Icons.report,
      color: Colors.white,
    )
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF000428), Color(0xFF004e92)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: screens[index],
      ),
      bottomNavigationBar: CurvedNavigationBar(
        items: items,
        index: index,
        onTap: (selectedIndex) {
          setState(() {
            index = selectedIndex;
          });
        },
        height: 70,
        color: Color.fromARGB(
            255, 2, 2, 2), // Set the main color of the navigation bar
        buttonBackgroundColor: const Color(
            0xFF004e92), // Set the background color of the selected item
        backgroundColor: Colors
            .transparent, // Keep this transparent to see the gradient behind
        animationDuration: const Duration(milliseconds: 300),
      ),
    );
  }
}
