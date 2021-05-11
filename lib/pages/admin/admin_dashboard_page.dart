import 'package:ctracker/components/z_tile_button.dart';
import 'package:ctracker/pages/admin/admin_user_das_page.dart';
import 'package:ctracker/pages/admin/container_location_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdminDashBoardPage extends StatefulWidget {
  @override
  _AdminDashBoardPageState createState() => _AdminDashBoardPageState();
}

class _AdminDashBoardPageState extends State<AdminDashBoardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Admin Dashboard',
          textScaleFactor: 1.0,
        ),
      ),
      body: ListView(
        children: [
          ZTileButton(
            icon: Icons.location_city_outlined,
            name: 'Location',
            leadingIcon: Icons.arrow_right,
            onTap: () =>
                Get.to(ContainerLocationPage(), fullscreenDialog: false),
          ),
          ZTileButton(
            icon: Icons.supervised_user_circle,
            name: 'Users',
            leadingIcon: Icons.arrow_right,
            onTap: () => Get.to(AdminUserDashPage(), fullscreenDialog: false),
          ),
        ],
      ),
    );
  }
}
