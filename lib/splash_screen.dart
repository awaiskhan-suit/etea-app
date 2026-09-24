import 'dart:async';
import 'package:flutter/material.dart';
import 'main.dart'; // for MyHomePage

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // after 5 seconds move to home
    Timer(const Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const MyHomePage(title: 'ETEA APP'),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFF0D47A1), // dark blue background
      body: Center(
        child: Text(
          "ETEA APP",
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 28,
            color: Colors.deepOrangeAccent,
          ),
        ),
      ),
    );
  }
}
