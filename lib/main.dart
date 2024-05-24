// ignore_for_file: avoid_unnecessary_containers, prefer_const_constructors, sort_child_properties_last

import 'package:first_app/profiles/welcome/loginpage.dart';
import 'package:first_app/profiles/welcome/welcome.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_wrapper.dart';
import 'package:responsive_framework/utils/scroll_behavior.dart';
import 'profiles/main_profile.dart';
import 'profiles/widgets/NavigationBar.dart';

void main() => runApp(MaterialApp(
      title: 'Mehfooz Aashiyana',
      debugShowCheckedModeBanner: false,
      // home:ProfileScreen(),
      builder: (context, widget) => ResponsiveWrapper.builder(
        ClampingScrollWrapper.builder(context, widget!),
        defaultScale: true,
        breakpoints: [
          ResponsiveBreakpoint.resize(350, name: MOBILE),
          ResponsiveBreakpoint.resize(600, name: TABLET),
          ResponsiveBreakpoint.resize(800, name: DESKTOP),
          ResponsiveBreakpoint.resize(1200, name: '4K'),
        ],
      ),

      initialRoute: '/',
      routes: {
        '/': (context) => Welcome(),
        '/profile': (context) => ProfileScreen(),
        '/login': (context) => LoginPage(),
        '/navbar': (context) => CustomNavigationBar()
      },
    ));
