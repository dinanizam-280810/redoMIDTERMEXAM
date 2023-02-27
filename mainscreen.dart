import 'package:flutter/material.dart';
import 'package:homestay_raya/models/user.dart';
import 'package:homestay_raya/views/mainmenu.dart';

class mainScreen extends StatefulWidget {
  final User user;
  const mainScreen({super.key, required this.user});

  @override
  State<mainScreen> createState() => _mainScreenState();
}

class _mainScreenState extends State<mainScreen> {
  @override
  void dispose() {
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(title:const Text("Buyer")),
      body: const Center(child: Text("Buyer")),
      drawer: MainMenuWidget(user:widget.user),
      
      ));
  
  }
}
