import 'dart:async';
import 'package:flutter/material.dart';
import 'package:homestay_raya/views/register.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    Timer(
        const Duration(seconds: 5),
        () => Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (content) => const RegisterPage())));
  }

  @override
  Widget build(BuildContext context) {
    return Stack(alignment: Alignment.center, children: [
      Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/homestay2.jpeg'),
                  fit: BoxFit.cover))),
      Padding(
        padding: const EdgeInsets.fromLTRB(0, 50, 0, 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text(
              "HOMESTAY RAYA",
              style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            CircularProgressIndicator(),
            Text(
              "Version 4.0 ",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            )
          ],
        ),
      )
    ]);
  }
}
