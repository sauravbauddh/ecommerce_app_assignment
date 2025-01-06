import 'package:ecomm_assignment/screens/onboarding/models/user_preferences.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class DrawerWidget extends StatelessWidget {
  final Function onHomePressed;
  final Function onOrdersPressed;
  final Function onSettingsPressed;
  final Function onLogoutPressed;
  final Function onThemeChanged;
  final Function onLanguageChanged;
  final String userName;

  const DrawerWidget({
    super.key,
    required this.onHomePressed,
    required this.onOrdersPressed,
    required this.onSettingsPressed,
    required this.onLogoutPressed,
    required this.onThemeChanged,
    required this.onLanguageChanged,
    required this.userName,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, size: 40),
                ),
                SizedBox(height: 10),
                Text(
                  tr('hello_user', args: [userName]),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text(tr('home')),
            onTap: () => onHomePressed(),
          ),
          ListTile(
            leading: Icon(Icons.shopping_bag),
            title: Text(tr('orders')),
            onTap: () => onOrdersPressed(),
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text(tr('settings')),
            onTap: () => onSettingsPressed(),
          ),
          ListTile(
            leading: Icon(Icons.sunny),
            title: Text(tr('change_theme')),
            onTap: () => onThemeChanged(),
          ),
          ListTile(
            leading: Icon(Icons.language),
            title: Text(tr('change_language')),
            onTap: () => onLanguageChanged(),
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text(tr('logout')),
            onTap: () => onLogoutPressed(),
          ),
        ],
      ),
    );
  }
}