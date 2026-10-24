import 'package:flutter/material.dart';
import 'package:vegetablesapp/login_page.dart';
import 'package:vegetablesapp/ui/colors.dart';

void main() {
  runApp(const VegetablesApp());
}

class VegetablesApp extends StatelessWidget {
  const VegetablesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vegetables App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Poppins',
        scaffoldBackgroundColor: background,
        primaryColor: primary,
        colorScheme: ColorScheme.fromSeed(seedColor: primary),
      ),
      home: const LoginPage(),
    );
  }
}
