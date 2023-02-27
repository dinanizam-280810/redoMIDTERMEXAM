import 'package:flutter/material.dart';
import 'package:homestay_raya/views/splashpage.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(brightness: Brightness.light),
      title: 'HomestayRaya',
      home: const SplashPage(),
    );
  }
}
