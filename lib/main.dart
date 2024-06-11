import 'package:chat_app/components/forms/pretty_counter.dart';
import 'package:chat_app/services/auth/authgate.dart';
import 'package:chat_app/configs/app_routes.dart';
import 'package:chat_app/firebase_options.dart';
import 'package:chat_app/styles/theme_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Hive.initFlutter();
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: Provider.of<ThemeProvider>(context).themeData,
      debugShowCheckedModeBanner: true,
      home: const AuthGate(),
      routes: AppRoutes.map, //LoginOrRegisterPage(),
    );

    // probar cosas:
    /*
    return MaterialApp(
      home: prettyCounter(),
    );
    */
    //return prettyCounter();
  }
}
