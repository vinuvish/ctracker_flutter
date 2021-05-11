import 'dart:io';

import 'package:ctracker/models_providers/admin_provider.dart';
import 'package:ctracker/models_providers/navbar_provider.dart';
import 'package:ctracker/models_providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../models_providers/auth_provider.dart';
import '../../models_providers/theme_provider.dart';
import '../../models_services/auth_service.dart';
import 'profile_address_page.dart';
import 'profile_info_page.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({Key key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);
    final navBarProvider = Provider.of<NavbarProvider>(context);
    final adminProvider = Provider.of<AdminProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);

    String allowNotification =
        authProvider.authUser.isNotificationsEnabledMain ? 'Yes' : 'No';
    return Scaffold(
      appBar: AppBar(title: Text('Profile')),
      body: ListView(
        children: <Widget>[
          ListTile(
            leading: Text('Update Personal Info'),
            trailing: Icon(Icons.arrow_forward_ios, size: 18),
            onTap: () => Get.to(ProfileInfoPage()),
          ),
          ListTile(
              leading: Text('My Address'),
              trailing: Icon(Icons.arrow_forward_ios, size: 18),
              onTap: () => Get.to(ProfileAddressPage(
                  address: authProvider.authUser.address.copyWith()))),
          ListTile(
            leading: Text('Show notifications'),
            trailing: Text(allowNotification),
            onTap: () => _showGetDialogNotification(authProvider),
          ),
          ListTile(
            leading: Text('Change Theme'),
            trailing: Icon(Icons.arrow_forward_ios, size: 18),
            onTap: () => _showGetDialogTheme(themeProvider),
          ),
          ListTile(
            leading: Text('Sign Out', style: TextStyle(color: Colors.red)),
            trailing: Icon(Icons.arrow_forward_ios, size: 18),
            onTap: () async {
              AuthService.signOut();
              if (authProvider.authUser.isAdmin) {
                adminProvider.clearAllStates();
                adminProvider.clearStreams();
              } else {
                userProvider.clearAllStates();
                userProvider.clearStreams();
              }
              await Future.delayed(Duration(seconds: 2));
              navBarProvider.selectedPageIndex = 0;
            },
          ),
        ],
      ),
    );
  }

  void _showGetDialogTheme(ThemeProvider themeProvider) {
    Get.bottomSheet(Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          GestureDetector(
            onTap: () {
              themeProvider.themeMode = ThemeMode.light;
              Navigator.pop(context);
            },
            child: Container(
              color: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Row(
                children: [
                  Text('Light Theme', style: TextStyle(color: Colors.black)),
                  Spacer(),
                  Icon(FontAwesome.sun_o, color: Colors.black),
                ],
              ),
            ),
          ),
          Divider(height: 0),
          GestureDetector(
            onTap: () {
              themeProvider.themeMode = ThemeMode.dark;
              Navigator.pop(context);
            },
            child: Container(
                color: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                child: Row(children: [
                  Text(
                    'Dart Theme',
                    style: TextStyle(color: Colors.black),
                  ),
                  Spacer(),
                  Icon(FontAwesome5.moon, color: Colors.black)
                ])),
          ),
          Divider(height: 0),
          GestureDetector(
            onTap: () {
              themeProvider.themeMode = ThemeMode.system;
              Navigator.pop(context);
            },
            child: Container(
                color: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                child: Row(children: [
                  Text(
                    'System Theme',
                    style: TextStyle(color: Colors.black),
                  ),
                  Spacer(),
                  Icon(AntDesign.setting, color: Colors.black)
                ])),
          ),
          if (Platform.isIOS) SizedBox(height: 10)
        ],
      ),
    ));
  }

  void _showGetDialogNotification(AuthProvider authProvider) {
    Get.bottomSheet(Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          GestureDetector(
            onTap: () {
              AuthService.updateNotificationStatus(true);
              Navigator.pop(context);
            },
            child: Container(
              color: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Row(
                children: [
                  Text('Show notifications',
                      style: TextStyle(color: Colors.black)),
                  Spacer(),
                  Icon(Ionicons.ios_notifications, color: Colors.black),
                ],
              ),
            ),
          ),
          Divider(height: 0),
          GestureDetector(
            onTap: () {
              AuthService.updateNotificationStatus(false);
              Navigator.pop(context);
            },
            child: Container(
                color: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                child: Row(children: [
                  Text('Don\'t show notifications',
                      style: TextStyle(color: Colors.black)),
                  Spacer(),
                  Icon(MaterialIcons.notifications_off, color: Colors.black)
                ])),
          ),
          if (Platform.isIOS) SizedBox(height: 10)
        ],
      ),
    ));
  }
}
