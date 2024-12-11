import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebasetesting/firebase_options.dart';
import 'package:firebasetesting/screens/loginscreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isDarkMode = false;

  void toggleTheme() {
    setState(() {
      isDarkMode = !isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Toko Buku Online',
      theme: isDarkMode ? ThemeData.dark() : ThemeData.light(),
      home: LoginScreen(toggleTheme: toggleTheme, isDarkMode: isDarkMode),
    );
  }
}