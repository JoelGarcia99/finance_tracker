import 'package:finance_tracker/cache/cache.preferences.dart';
import 'package:finance_tracker/router/routes.dart';
import 'package:finance_tracker/ui/theme.custom.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

import 'assembler/assembler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CachePreferences().init();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    
    if(CachePreferences().user != null) {
      Wrapper().currentUserSink = CachePreferences().user!;
    }

    return MaterialApp(
      title: 'Finance tracker',
      theme: CustomDarkTheme().theme,
      initialRoute: Wrapper().currentUser != null?
        RouteNames.home.toString()
        :RouteNames.register.toString(),
      routes: generateRoutes(),
      navigatorObservers: [FlutterSmartDialog.observer],
      builder: FlutterSmartDialog.init(),
    );
  }
}
