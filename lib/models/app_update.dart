import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:package_info/package_info.dart';

import '../app_utils/z_models.dart';

class AppUpdate {
  List<String> appNewFeaturesAdminAndroid;
  List<String> appNewFeaturesAdminIOS;
  List<String> appNewFeaturesMainAndroid;
  List<String> appNewFeaturesMainIOS;
  List<String> appDisabledReasonsAdminAndroid;
  List<String> appDisabledReasonsAdminIOS;
  List<String> appDisabledReasonsMainAndroid;
  List<String> appDisabledReasonsMainIOS;
  String appLinkAdminAndroid;
  String appLinkAdminIOS;
  String appLinkMainAndroid;
  String appLinkMainIOS;
  bool isAndroid;
  bool isAppDisabledAdminAndroid;
  bool isAppDisabledAdminIOS;
  bool isAppDisabledMainAndroid;
  bool isAppDisabledMainIOS;
  bool isIOS;
  bool isMainApp;
  bool isUpdateCloseClicked;
  num appBuildNumberLocal;
  num appBuildNumberServerAdminAndroid;
  num appBuildNumberServerAdminAndroidMin;
  num appBuildNumberServerAdminIOS;
  num appBuildNumberServerAdminIOSMin;
  num appBuildNumberServerMainAndroid;
  num appBuildNumberServerMainAndroidMin;
  num appBuildNumberServerMainIOS;
  num appBuildNumberServerMainIOSMin;

  AppUpdate({
    this.appBuildNumberLocal,
    this.appBuildNumberServerAdminAndroid,
    this.appBuildNumberServerAdminAndroidMin,
    this.appBuildNumberServerAdminIOS,
    this.appBuildNumberServerAdminIOSMin,
    this.appBuildNumberServerMainAndroid,
    this.appBuildNumberServerMainAndroidMin,
    this.appBuildNumberServerMainIOS,
    this.appBuildNumberServerMainIOSMin,
    this.appLinkAdminAndroid,
    this.appLinkAdminIOS,
    this.appLinkMainAndroid,
    this.appLinkMainIOS,
    this.isIOS,
    this.isMainApp,
    this.isUpdateCloseClicked = false,
    this.appNewFeaturesAdminAndroid,
    this.appNewFeaturesAdminIOS,
    this.appNewFeaturesMainAndroid,
    this.appNewFeaturesMainIOS,
    this.isAndroid,
    this.isAppDisabledAdminAndroid,
    this.isAppDisabledAdminIOS,
    this.isAppDisabledMainAndroid,
    this.isAppDisabledMainIOS,
    this.appDisabledReasonsAdminAndroid,
    this.appDisabledReasonsAdminIOS,
    this.appDisabledReasonsMainAndroid,
    this.appDisabledReasonsMainIOS,
  });

  static Future<AppUpdate> fromFirestore(DocumentSnapshot doc) async {
    Map data = doc.data();

    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    num appBuildNumberLocal = int.tryParse(packageInfo.buildNumber) ?? 0;
    bool isMainApp = false;
    bool isIOS = Platform.isIOS ? true : false;
    bool isAndroid = Platform.isAndroid ? true : false;

    // print(ModelParserLists.toExtListStrings(data['appNewFeaturesAdminIOS']));

    return AppUpdate(
      appBuildNumberLocal: appBuildNumberLocal,
      appBuildNumberServerAdminAndroid: ZModelNumber.toNum(data['appBuildNumberServerAdminAndroid']),
      appBuildNumberServerAdminAndroidMin: ZModelNumber.toNum(data['appBuildNumberServerAdminAndroidMin']),
      appBuildNumberServerAdminIOS: ZModelNumber.toNum(data['appBuildNumberServerAdminIOS']),
      appBuildNumberServerAdminIOSMin: ZModelNumber.toNum(data['appBuildNumberServerAdminIOSMin']),
      appBuildNumberServerMainAndroid: ZModelNumber.toNum(data['appBuildNumberServerMainAndroid']),
      appBuildNumberServerMainAndroidMin: ZModelNumber.toNum(data['appBuildNumberServerMainAndroidMin']),
      appBuildNumberServerMainIOS: ZModelNumber.toNum(data['appBuildNumberServerMainIOS']),
      appBuildNumberServerMainIOSMin: ZModelNumber.toNum(data['appBuildNumberServerMainIOSMin']),
      appLinkAdminAndroid: ZModelString.toStr(data['appLinkAdminAndroid']),
      appLinkAdminIOS: ZModelString.toStr(data['appLinkAdminIOS']),
      appLinkMainAndroid: ZModelString.toStr(data['appLinkMainAndroid']),
      appLinkMainIOS: ZModelString.toStr(data['appLinkMainIOS']),
      appNewFeaturesAdminAndroid: ZModelLists.toListStrings(data['appNewFeaturesAdminAndroid']),
      appNewFeaturesAdminIOS: ZModelLists.toListStrings(data['appNewFeaturesAdminIOS']),
      appNewFeaturesMainAndroid: ZModelLists.toListStrings(data['appNewFeaturesMainAndroid']),
      appNewFeaturesMainIOS: ZModelLists.toListStrings(data['appNewFeaturesMainIOS']),
      isAndroid: isAndroid,
      isAppDisabledAdminAndroid: ZModelBool.toBool(data['isAppDisabledAdminAndroid'], defaultVal: false),
      isAppDisabledAdminIOS: ZModelBool.toBool(data['isAppDisabledAdminIOS'], defaultVal: false),
      isAppDisabledMainAndroid: ZModelBool.toBool(data['isAppDisabledMainAndroid'], defaultVal: false),
      isAppDisabledMainIOS: ZModelBool.toBool(data['isAppDisabledMainIOS'], defaultVal: false),
      appDisabledReasonsAdminAndroid: ZModelLists.toListStrings(data['appDisabledReasonsAdminAndroid']),
      appDisabledReasonsAdminIOS: ZModelLists.toListStrings(data['appDisabledReasonsAdminAndroid']),
      appDisabledReasonsMainAndroid: ZModelLists.toListStrings(data['appDisabledReasonsMainAndroid']),
      appDisabledReasonsMainIOS: ZModelLists.toListStrings(data['appDisabledReasonsMainIOS']),
      isIOS: isIOS,
      isMainApp: isMainApp,
      isUpdateCloseClicked: false,
    );
  }

  static bool showAppUpdateScreen(AppUpdate x) {
    if (x.isMainApp) {
      if (x.isAndroid && x.appBuildNumberLocal < x.appBuildNumberServerMainAndroidMin) return true;
      if (x.isIOS && x.appBuildNumberLocal < x.appBuildNumberServerMainIOSMin) return true;
    }

    if (!x.isMainApp) {
      if (x.isAndroid && x.appBuildNumberLocal < x.appBuildNumberServerAdminAndroidMin) return true;
      if (x.isIOS && x.appBuildNumberLocal < x.appBuildNumberServerAdminIOSMin) return true;
    }

    return false;
  }

  static List<String> getAppNewFeatures(AppUpdate x) {
    if (x.isMainApp) {
      if (x.isAndroid) return x.appNewFeaturesMainAndroid;
      if (x.isIOS) return x.appNewFeaturesMainIOS;
    }

    if (!x.isMainApp) {
      if (x.isAndroid) return x.appNewFeaturesAdminAndroid;
      if (x.isIOS) return x.appNewFeaturesAdminIOS;
    }

    return [];
  }

  static bool showDisabledScreen(AppUpdate x) {
    if (x.isMainApp) {
      if (x.isAndroid && x.isAppDisabledMainAndroid) return true;
      if (x.isIOS && x.isAppDisabledMainIOS) return true;
    }

    if (!x.isMainApp) {
      if (x.isAndroid && x.isAppDisabledAdminAndroid) return true;
      if (x.isIOS && x.isAppDisabledAdminIOS) return true;
    }

    return false;
  }

  static List<String> getDisabledReasons(AppUpdate x) {
    if (x.isMainApp) {
      if (x.isAndroid && x.isAppDisabledMainAndroid) return x.appDisabledReasonsMainAndroid;
      if (x.isIOS && x.isAppDisabledMainIOS) return x.appDisabledReasonsMainIOS;
    }

    if (!x.isMainApp) {
      if (x.isAndroid && x.isAppDisabledAdminAndroid) return x.appDisabledReasonsAdminAndroid;
      if (x.isIOS && x.isAppDisabledAdminIOS) return x.appDisabledReasonsAdminIOS;
    }

    return [];
  }

  static bool showAppUpdateCard(AppUpdate x) {
    if (x.isUpdateCloseClicked) return false;

    if (x.isMainApp) {
      if (x.isAndroid && x.appBuildNumberLocal < x.appBuildNumberServerMainAndroid) return true;
      if (x.isIOS && x.appBuildNumberLocal < x.appBuildNumberServerMainIOS) return true;
    }

    if (!x.isMainApp) {
      if (x.isAndroid && x.appBuildNumberLocal < x.appBuildNumberServerAdminAndroid) return true;
      if (x.isIOS && x.appBuildNumberLocal < x.appBuildNumberServerAdminIOS) return true;
    }

    return false;
  }

  static String getLaunchURL(AppUpdate x) {
    if (x.isMainApp) {
      if (x.isAndroid) return x.appLinkMainAndroid;
      if (x.isIOS) return x.appLinkMainIOS;
    }

    if (!x.isMainApp) {
      if (x.isAndroid) return x.appLinkAdminAndroid;
      if (x.isIOS) return x.appLinkAdminIOS;
    }

    return '';
  }
}
