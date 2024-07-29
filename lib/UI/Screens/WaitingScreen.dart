import 'dart:async';
import 'package:flutter/material.dart';

import 'SignIn.dart';

class WaitingScreen extends StatefulWidget {
  const WaitingScreen({Key? key}) : super(key: key);

  @override
  State<WaitingScreen> createState() => _WaitingScreenState();
}

class _WaitingScreenState extends State<WaitingScreen> {
  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) =>  const SignIn(adresseDepot: '', adressePoubelle: [],)),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Image.asset(
            "lib/UI/Assets/Images/logo_png.png",
            height: 150,
            width: 150,
          ),
        ),
      ),
    );
  }
}
