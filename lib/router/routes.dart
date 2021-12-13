import 'package:finance_tracker/areas/screen.area.dart';
import 'package:finance_tracker/auth/screen/screen.register.dart';
import 'package:finance_tracker/home/screens/screen.home.dart';
import 'package:finance_tracker/settings/screen.settings.dart';
import 'package:flutter/material.dart';

enum RouteNames {
  home, register, settings, area
}

Map<String, Widget Function(BuildContext)> generateRoutes() => {
  RouteNames.home.toString(): (context) => const HomeScreen(),
  RouteNames.register.toString(): (context) => RegisterScreen(),
  RouteNames.settings.toString(): (_) => SettingsScreen(),
  RouteNames.area.toString(): (_)=>const AreaScreen()
};