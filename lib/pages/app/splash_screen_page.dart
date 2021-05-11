import 'package:ctracker/models/auth_user.dart';
import 'package:ctracker/models_providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:provider/provider.dart';

import '../../models_providers/auth_provider.dart';
import '../../models_providers/admin_provider.dart';

class SplashScreenPage extends StatefulWidget {
  @override
  _SplashScreenPageState createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {
  @override
  void initState() {
    Future.delayed(Duration(milliseconds: 1000)).then((value) async {
      AuthUser authUser =
          await Provider.of<AuthProvider>(context, listen: false).init();
      if (authUser.isAdmin) {
        await Provider.of<AdminProvider>(context, listen: false).initState();
      } else {
        await Provider.of<UserProvider>(context, listen: false).initState();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Center(
                child: LoadingBouncingGrid.circle(
              backgroundColor: Theme.of(context).accentColor,
            ))
          ],
        ),
      ),
    );
  }
}
