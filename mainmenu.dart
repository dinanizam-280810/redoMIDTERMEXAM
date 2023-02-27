import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:homestay_raya/views/firstTab.dart';
import 'package:homestay_raya/models/profiletab.dart';
import 'package:homestay_raya/models/user.dart';
import 'package:homestay_raya/views/enterexitroute.dart';
import 'package:homestay_raya/views/mainscreen.dart';

class MainMenuWidget extends StatefulWidget {
  final User user;
  //final Position position;
  const MainMenuWidget({super.key, required this.user, });

  @override
  State<MainMenuWidget> createState() => _MainMenuWidgetState();
}

class _MainMenuWidgetState extends State<MainMenuWidget> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
        width: 250,
        elevation: 10,
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              accountEmail: Text(widget.user.email.toString()),
              accountName: Text(widget.user.name.toString()),
              currentAccountPicture: const CircleAvatar(
                radius: 30.0,
              ),
            ),
            ListTile(
              title: const Text('Buyer'),
              onTap: () {
                Navigator.pop(
                    context);
                    Navigator.push(context,
                    EnterExitRoute(exitPage: mainScreen(user: widget.user,), enterPage: mainScreen(user: widget.user,)));
              },
            ),
            ListTile(
              title: const Text('Seller'),
              onTap: () {
                Navigator.pop(
                    context);
                    Navigator.push(context,
                    EnterExitRoute(exitPage: mainScreen(user: widget.user,), enterPage: homeTab(user: widget.user)));
              },
            ),
             ListTile(
              title: const Text('profile'),
              onTap: () {
                Navigator.pop(
                    context);
                    Navigator.push(context,
                    EnterExitRoute(exitPage: mainScreen(user: widget.user), enterPage: profileTab(user: widget.user)));
              },
            ),
          ],
        ));
  }
}
