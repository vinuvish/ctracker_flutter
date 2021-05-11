import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationService {
  static void init() async {
    final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
    await _firebaseMessaging.requestNotificationPermissions(const IosNotificationSettings(sound: true, badge: true, alert: true, provisional: true));

    _firebaseMessaging.onIosSettingsRegistered.listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });

    _firebaseMessaging.configure(
        onMessage: (Map<String, dynamic> message) async {
          print("onMessage: $message");

          String title = '';
          String body = '';

          if (Platform.isAndroid) {
            title = message['notification']['title'] ?? '';
            body = message['notification']['body'] ?? '';
          }

          if (Platform.isIOS) {
            title = message['aps']["alert"]["title"] ?? '';
            body = message["aps"]["alert"]["body"] ?? '';
          }

          Get.snackbar(title, body, backgroundColor: Color(0xFF6c5ce7), colorText: Colors.white);
        },
        onResume: (Map<String, dynamic> message) async {
          print("onResume: $message");
        },
        onLaunch: (Map<String, dynamic> message) async {
          print("onLaunch: $message");
        },
        onBackgroundMessage: Platform.isIOS ? null : myBackgroundMessageHandler);
  }
}

Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) async {
  if (message.containsKey('data')) {
    final dynamic data = message['data'];
  }

  if (message.containsKey('notification')) {
    final dynamic notification = message['notification'];
  }
}
