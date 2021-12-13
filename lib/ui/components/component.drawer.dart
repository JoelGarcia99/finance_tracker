import 'package:finance_tracker/router/routes.dart';
import 'package:flutter/material.dart';

class LateralBar extends StatelessWidget {

  final RouteNames route;

  const LateralBar({ Key? key, required this.route }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Drawer(
      child: ListView(
        children: const [
          ListTile(
            leading: Icon(Icons.home_outlined),
            title: Text("Home"),
          )
        ],
      ),
    );
  }
}