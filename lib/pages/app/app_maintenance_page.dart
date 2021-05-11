import 'package:ctracker/pages/app/splash_screen_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../components/z_button_outlined.dart';
import '../../models/app_update.dart';

class AppMaintenancePage extends StatelessWidget {
  final AppUpdate appUpdate;

  const AppMaintenancePage({Key key, @required this.appUpdate})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text('App Under Maintenance',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
          SizedBox(height: 10),
          Container(
              height: Get.height * .25,
              child: Image.asset('assets/images/maintenance.png')),
          if (AppUpdate.getDisabledReasons(appUpdate).isNotEmpty)
            Column(
              children: [
                SizedBox(height: 20),
                for (var item in AppUpdate.getDisabledReasons(appUpdate))
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    child: Text(item),
                  ),
              ],
            ),
          if (AppUpdate.getDisabledReasons(appUpdate).isEmpty)
            Column(
              children: [
                SizedBox(height: 20),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  child: Text('Pardon us while we improve the app experience'),
                ),
              ],
            ),
          ZButtonOutlined(
            text: 'Check Update',
            height: 38,
            width: 200,
            onTap: () => Get.to(SplashScreenPage()),
          ),
          Row()
        ],
      ),
    );
  }
}
