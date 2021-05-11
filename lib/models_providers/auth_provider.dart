import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

import '../models/app_update.dart';
import '../models/auth_user.dart';
import '../models_services/auth_service.dart';
import '../pages/app/acc_disabled_page.dart';
import '../pages/app/acc_not_verified_page.dart';
import '../pages/app/app_home_page.dart';
import '../pages/app/signin_page.dart';
import '../pages/app/terms_confition_page.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  AuthUser _authUser;
  AuthUser get authUser => _authUser;

  AppUpdate _appUpdate = AppUpdate();
  AppUpdate get appUpdate => _appUpdate;

  bool isHomePagePushAllowed = true;

  void isUpdateCloseClicked() {
    _appUpdate.isUpdateCloseClicked = true;
    notifyListeners();
  }

  Future init() async {
    // _appUpdate = await AuthService.getUpdate();

    // if (AppUpdate.showDisabledScreen(_appUpdate)) return Get.offAll(AppMaintenancePage(appUpdate: _appUpdate));

    // if (AppUpdate.showAppUpdateScreen(_appUpdate)) return Get.offAll(AppUpdatePage(appUpdate: _appUpdate));

    _authUser = await AuthService.getAuthUser();

    if (_authUser == null) return Get.offAll(SignInPage());

    if (_authUser != null) {
      Stream<AuthUser> streamAuthUser = AuthService.streamAuthUser();
      streamAuthUser.listen((res) async {
        _authUser = res;
        print(_authUser.id);
        notifyListeners();

        if (_authUser == null) {
          isHomePagePushAllowed = true;
          return Get.offAll(SignInPage());
        }

        if (!_authUser.isActive) {
          isHomePagePushAllowed = true;
          return Get.offAll(AccountDisabledPage());
        }

        if (!FirebaseAuth.instance.currentUser.emailVerified) {
          isHomePagePushAllowed = true;
          return Get.offAll(AccountNotVerifiedPage());
        }

        if (await checkTeamConditons() == false) {
          isHomePagePushAllowed = true;
          return Get.offAll(TermsAndConditionsPage());
        }

        if (isHomePagePushAllowed) {
          isHomePagePushAllowed = false;
          Get.offAll(AppHomePage());
          await AuthService.updateAppVersionLastLogin();
        }
      });

      FirebaseAuth.instance.authStateChanges().listen((res) async {
        if (res == null && Get.currentRoute != '/SignInPage') {
          isHomePagePushAllowed = true;
          Get.offAll(SignInPage());
          return;
        }
      });
    }

    notifyListeners();
    return _authUser;
  }

  Future<AuthUser> signInUserEmailAndPassword(
      String email, String password) async {
    AuthUser authUser;
    try {
      User _user = await AuthService.signInUserEmailAndPassword(
          email: email, password: password);
      if (_user != null) authUser = await init();
      return authUser;
    } catch (e) {
      return null;
    }
  }

  Future<bool> signOut() async {
    bool res = await AuthService.signOut();
    return res;
  }

  Future updateNotificationStatus(bool status) async {
    await AuthService.updateNotificationStatus(status);
  }

  Future<bool> checkTeamConditons() async {
    final settings = await Hive.openBox('settings');
    bool isTermsAndConditionsAccepted =
        settings.get('isTermsAndConditionsAccepted') ?? false;
    return isTermsAndConditionsAccepted;
  }

  Future<void> acceptTermsAndConditons() async {
    final settings = await Hive.openBox('settings');
    settings.put('isTermsAndConditionsAccepted', true);
    init();
  }
}
