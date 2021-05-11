import 'package:ctracker/components/z_card.dart';
import 'package:ctracker/models/auth_user.dart';
import 'package:ctracker/models_providers/admin_provider.dart';
import 'package:ctracker/pages/admin/admin_user_add_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class AdminUserDashPage extends StatefulWidget {
  @override
  _AdminUserDashPageState createState() => _AdminUserDashPageState();
}

class _AdminUserDashPageState extends State<AdminUserDashPage> {
  @override
  Widget build(BuildContext context) {
    final adminProvide = Provider.of<AdminProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'User Dashboard',
          textScaleFactor: 1.0,
        ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () => Get.to(AdminUserAddPage(), fullscreenDialog: true),
          tooltip: 'Increment',
          child: Icon(Icons.add)),
      body: ListView(
        children: [
          for (AuthUser user in adminProvide.streamUsers)
            ZCard(
              onTap: () => Get.to(
                  AdminUserAddPage(
                    authUser: AuthUser.clone(user),
                  ),
                  fullscreenDialog: true),
              child: Column(
                children: [
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        user.getFullName,
                        textScaleFactor: 1.0,
                      ),
                      Text(
                        user.isAdmin ? 'Admin' : 'User',
                        textScaleFactor: 1.0,
                        style: TextStyle(
                            color: Theme.of(context).buttonColor,
                            fontWeight: FontWeight.w900),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        user.email,
                        textScaleFactor: 1.0,
                      ),
                      Text(
                        user.isActive ? 'Active' : 'Blocked',
                        textScaleFactor: 1.0,
                        style: TextStyle(
                            color: Theme.of(context).buttonColor,
                            fontWeight: FontWeight.w900),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                ],
              ),
            )
        ],
      ),
    );
  }
}
