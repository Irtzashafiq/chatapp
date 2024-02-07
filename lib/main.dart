// import 'package:chatapp/auth/Login_or_register.dart';
import 'package:chatapp/Themes/dark_theme.dart';
import 'package:chatapp/Themes/light_theme.dart';
import 'package:chatapp/auth/auth.dart';
import 'package:chatapp/firebase/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      home: const AuthPage(),
      builder: (context, child) {
        return Theme(
          data: darkTheme, // Set to your dark theme
          child: child!,
        );
      },
    );
  }
}
