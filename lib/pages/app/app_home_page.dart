import 'dart:io';

import 'package:ctracker/models_providers/auth_provider.dart';
import 'package:ctracker/pages/admin/admin_dashboard_page.dart';
import 'package:ctracker/pages/user/user_containers_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';

import '../../models_providers/navbar_provider.dart';
import '../../models_providers/theme_provider.dart';
import '../admin/containers_page.dart';
import 'profile_page.dart';

class AppHomePage extends StatefulWidget {
  _AppHomePageState createState() => _AppHomePageState();
}

class _AppHomePageState extends State<AppHomePage> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final appProvider = Provider.of<NavbarProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      body: authProvider.authUser.isAdmin
          ? adminPages.elementAt(appProvider.selectedPageIndex)
          : userPages.elementAt(appProvider.selectedPageIndex),
      bottomNavigationBar: ZBottomNavbar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        selectedColor: themeProvider.brightness == Brightness.light
            ? Colors.black87
            : Colors.white,
        deselectedColor: themeProvider.brightness == Brightness.light
            ? Colors.black54
            : Colors.white54,
        selectedIndex: appProvider.selectedPageIndex,
        items: [
          if (authProvider.authUser.isAdmin)
            ...adminBottomNavbarItems
          else
            ...userBottomNavbarItems
        ],
        onIndexChange: (value) {
          appProvider.selectedPageIndex = value;
        },
      ),
    );
  }

/* ----------------------------- NOTE UserPages ----------------------------- */
  List<Widget> userPages = [
    UserCTrackersPage(),
    ProfilePage(),
  ];

  List<ZBottomNavbarItem> userBottomNavbarItems = [
    ZBottomNavbarItem(text: 'Home', icon: AntDesign.home),
    ZBottomNavbarItem(text: 'Profile', icon: AntDesign.user),
  ];
  /* ----------------------------- NOTE AdminPages ----------------------------- */
  List<Widget> adminPages = [
    CTrackersPage(),
    AdminDashBoardPage(),
    ProfilePage(),
  ];
  List<ZBottomNavbarItem> adminBottomNavbarItems = [
    ZBottomNavbarItem(text: 'Home', icon: AntDesign.home),
    ZBottomNavbarItem(text: 'Dashboard', icon: AntDesign.database),
    ZBottomNavbarItem(text: 'Profile', icon: AntDesign.user),
  ];
}

/* ----------------------------- NOTE COMPONENT ----------------------------- */
class ZBottomNavbar extends StatefulWidget {
  final List<ZBottomNavbarItem> items;
  final ValueChanged<int> onIndexChange;
  final EdgeInsetsGeometry padding;
  final selectedIndex;
  final backgroundColor;
  final splashColor;
  final Color selectedColor;
  final Color deselectedColor;

  ZBottomNavbar({
    @required this.items,
    this.onIndexChange,
    this.padding,
    this.splashColor,
    this.selectedIndex,
    this.backgroundColor,
    this.deselectedColor = Colors.black54,
    this.selectedColor = Colors.red,
  });
  _ZBottomNavbarState createState() => _ZBottomNavbarState();
}

class _ZBottomNavbarState extends State<ZBottomNavbar> {
  int currentIndex;

  @override
  void initState() {
    currentIndex = widget.selectedIndex;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Divider(height: 0, thickness: .85),
        Container(
          padding: widget.padding ?? Platform.isIOS
              ? EdgeInsets.fromLTRB(0.0, 2.0, 0.0, 18.0)
              : EdgeInsets.fromLTRB(8.0, 2.0, 8.0, 2.0),
          color: widget.backgroundColor ??
              Theme.of(context).scaffoldBackgroundColor,
          child: Material(
            color: Colors.transparent,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: widget.items.map((item) {
                int index = widget.items.indexOf(item);
                return Expanded(
                  child: InkWell(
                    splashColor: widget.splashColor ?? Colors.black12,
                    borderRadius: BorderRadius.circular(50.0),
                    onLongPress: () {},
                    onTap: () {
                      widget.onIndexChange(index);
                      setState(() => currentIndex = index);
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Icon(item.icon,
                              size: 25.0,
                              color: index == widget.selectedIndex
                                  ? widget.selectedColor
                                  : widget.deselectedColor),
                          SizedBox(height: 3.0),
                          Text(item.text,
                              style: TextStyle(
                                  fontSize: 9.0,
                                  color: index == widget.selectedIndex
                                      ? widget.selectedColor
                                      : widget.deselectedColor))
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}

class ZBottomNavbarItem {
  final String text;
  final IconData icon;

  ZBottomNavbarItem({this.icon, this.text});
}
