import 'dart:async';
import 'package:flutter/material.dart';
import 'package:frontend_spaceregis/core/constant/constant.dart';
import 'package:frontend_spaceregis/core/routes/app_routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 2), () {
      _checkLogin();
    });
  }

  // verificar si el usuario esta logeado
  void _checkLogin() async {
    Navigator.pushReplacementNamed(context, introScreen);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [Center(child: Image.asset(logoPng, fit: BoxFit.cover))],
      ),
    );
  }
}