// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:simple_weather_app/aboutPage.dart';

class DrawerMenu extends StatelessWidget {
  const DrawerMenu({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.grey.shade400,
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 0, 0, 0),
            ),
            child: Center(
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          ListTile(
            leading: const Icon(
              Icons.home,
              color: Colors.black,
            ),
            title: const Text(
              'Home',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.info_outline,
              color: Colors.black,
            ),
            title: const Text(
              'About',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const AppInfo()));
            },
          ),
        ],
      ),
    );
  }
}
