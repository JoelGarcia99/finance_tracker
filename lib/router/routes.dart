import 'package:finance_tracker/auth/screen/screen.register.dart';
import 'package:finance_tracker/home/screens/screen.home.dart';
import 'package:flutter/material.dart';

enum RouteNames {
  home, register
}

Map<String, Widget Function(BuildContext)> generateRoutes() => {
  RouteNames.home.toString(): (context) => const HomeScreen(),
  RouteNames.register.toString(): (context) => RegisterScreen()
};