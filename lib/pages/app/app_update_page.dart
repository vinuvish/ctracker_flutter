import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../components/z_button_text.dart';
import '../../components/z_card.dart';
import '../../models/app_update.dart';
import '../../models_providers/auth_provider.dart';

class AppUpdatePage extends StatelessWidget {
  final AppUpdate appUpdate;
  const AppUpdatePage({Key key, @required this.appUpdate}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(height: 80, child: Image.asset('assets/images/app_update.png')),
          SizedBox(height: 30),
          Text('New Update Available', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
          SizedBox(height: 20),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 25),
            child: Text('Sorry for the inconvenience but could you please update to the newest version of our app.',
                textAlign: TextAlign.center, style: TextStyle(height: 1.3)),
          ),
          SizedBox(height: 20),
          InkWell(
            onTap: () => _launchURL(),
            child: Container(
              decoration: BoxDecoration(border: Border.all(color: Colors.blue), borderRadius: BorderRadius.circular(5)),
              margin: EdgeInsets.symmetric(horizontal: 16),
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  if (Platform.isAndroid)
                    Row(
                      children: [
                        Container(height: 30, child: Image.asset('assets/images/google_play.png')),
                        Container(margin: EdgeInsets.symmetric(horizontal: 16), child: Text('Download From Google Play')),
                      ],
                    ),
                  if (Platform.isIOS)
                    Row(
                      children: [
                        Container(height: 30, child: Image.asset('assets/images/app_store.png')),
                        Container(margin: EdgeInsets.symmetric(horizontal: 16), child: Text('Download From App Store'))
                      ],
                    ),
                ],
              ),
            ),
          ),
          if (AppUpdate.getAppNewFeatures(appUpdate).isNotEmpty)
            Column(
              children: [
                SizedBox(height: 20),
                for (var item in AppUpdate.getAppNewFeatures(appUpdate))
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 30, vertical: 5),
                    child: Text(item, textAlign: TextAlign.center, style: TextStyle(height: 1.3)),
                  ),
              ],
            ),
        ],
      ),
    );
  }

  _launchURL() async {
    String url = AppUpdate.getLaunchURL(appUpdate);
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}

class ZCardUpdate extends StatelessWidget {
  final EdgeInsets margin;
  final EdgeInsets padding;
  const ZCardUpdate({
    Key key,
    this.margin,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    return ZCard(
      elevation: 4,
      margin: margin ?? EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      padding: padding ?? EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ZCard(
                margin: EdgeInsets.all(0),
                padding: EdgeInsets.all(0),
                child: Icon(AntDesign.closecircleo),
                borderRadius: BorderRadius.circular(50),
                elevation: 0,
                onTap: () => authProvider.isUpdateCloseClicked(),
              )
            ],
          ),
          SizedBox(height: 5),
          Text('Please update to the new version of our app to start using the newest features.', style: TextStyle(height: 1.4, fontSize: 15)),
          SizedBox(height: 3),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ZButtonText(
                  text: 'UPDATE NOW',
                  textStyle: TextStyle(color: Color(0xFF00714F), fontWeight: FontWeight.w900, fontStyle: FontStyle.italic),
                  onTap: () => _launchURL(AppUpdate.getLaunchURL(authProvider.appUpdate))),
            ],
          ),
        ],
      ),
    );
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
