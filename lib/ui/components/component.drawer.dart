import 'package:finance_tracker/auth/api/api.auth.dart';
import 'package:finance_tracker/router/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

class LateralBar extends StatelessWidget {

  final RouteNames route;

  const LateralBar({ Key? key, required this.route }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Drawer(
      child: ListView(
        children: [
          Container(
            color: Theme.of(context).colorScheme.primaryVariant,
            child: ListTile(
              leading: const Icon(Icons.menu_outlined),
              title: const Text("Menu"),
              onTap: ()=>Navigator.of(context).pop(),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.settings_outlined),
            title: const Text("Settings"),
            onTap: ()=>Navigator.of(context).pushNamed(RouteNames.settings.toString()),
          ),
          ListTile(
            leading: const Icon(Icons.exit_to_app_outlined),
            title: const Text("Log out"),
            onTap: () async {
              SmartDialog.showLoading(msg: 'Logging out');
              
              try {
                await AuthAPI().signOut();
              }catch(e) {
                SmartDialog.show(widget: Text(e.toString()));
              }finally {
                SmartDialog.dismiss();
              }

              Navigator.of(context).pushReplacementNamed(RouteNames.register.toString());

            }
          ),
        ],
      ),
    );
  }
}