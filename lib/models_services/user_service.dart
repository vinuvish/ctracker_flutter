import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ctracker/app_utils/config.dart';
import 'package:ctracker/app_utils/z_get_utils.dart';
import 'package:ctracker/models/base_response.dart';
import '../models/auth_user.dart';
import 'package:http/http.dart' as http;

class UserService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /* --------------------------- NOTE Stream user --------------------------- */
  static Future<Stream<List<AuthUser>>> streamAllUsers() async {
    var ref = _firestore
        .collection('users')
        .orderBy('timestampCreated', descending: true)
        .snapshots()
        .asBroadcastStream();
    return ref.map(
        (list) => list.docs.map((doc) => AuthUser.fromFirestore(doc)).toList());
  }

  static Future<bool> httpsUserCreateRequest({AuthUser authuser}) async {
    try {
      ZGetUtils.showLoadingOverlay();
      final http.Response response = await http.post(
          '${Config.BASE_URL}/httpsAdminUserCreate/api/v1/adminUserCreate',
          headers: <String, String>{
            'Accept': 'application/json',
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: json.encode(authuser.toJson()));

      if (response.statusCode == 200) {
        ZGetUtils.closeLoadingOverlay();
        ZGetUtils.showSnackbarSuccess(message: 'User Created successfully');
        return true;
      } else {
        ZGetUtils.closeLoadingOverlay();
        ZGetUtils.showSnackbarError(
            message: BaseResponse.fromJson(json.decode(response.body)).message);
        return false;
      }
    } catch (e) {
      ZGetUtils.closeLoadingOverlay();
      print(e);

      return false;
    }
  }

  static Future<bool> httpsUserUpdateRequest({AuthUser authuser}) async {
    try {
      ZGetUtils.showLoadingOverlay();
      final http.Response response = await http.post(
          '${Config.BASE_URL}/httpsAdminUserUpdate/api/v1/adminUserUpdate',
          headers: <String, String>{
            'Accept': 'application/json',
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: json.encode(authuser.toJson()));
      if (response.statusCode == 200) {
        ZGetUtils.closeLoadingOverlay();
        ZGetUtils.showSnackbarSuccess(message: 'User Update successfully');
        return true;
      } else {
        ZGetUtils.closeLoadingOverlay();
        ZGetUtils.showSnackbarError(
            message: BaseResponse.fromJson(json.decode(response.body)).message);
        return false;
      }
    } catch (e) {
      ZGetUtils.closeLoadingOverlay();
      print(e);
      return false;
    }
  }

  static Future<bool> httpsUserPasswordReset({AuthUser authuser}) async {
    try {
      ZGetUtils.showLoadingOverlay();
      final http.Response response = await http.post(
          '${Config.BASE_URL}/httpsAdminResetPassword/api/v1/adminResetPassword',
          headers: <String, String>{
            'Accept': 'application/json',
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: json.encode(authuser.toJson()));
      if (response.statusCode == 200) {
        ZGetUtils.closeLoadingOverlay();
        ZGetUtils.showSnackbarSuccess(message: 'Password Reset successfully');
        return true;
      } else {
        ZGetUtils.closeLoadingOverlay();
        ZGetUtils.showSnackbarError(
            message: BaseResponse.fromJson(json.decode(response.body)).message);
        return false;
      }
    } catch (e) {
      ZGetUtils.closeLoadingOverlay();
      print(e);
      return false;
    }
  }
}
