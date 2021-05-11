import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:package_info/package_info.dart';

import '../app_utils/z_get_utils.dart';
import '../app_utils/z_validators.dart';
import '../models/address.dart';
import '../models/app_update.dart';
import '../models/auth_user.dart';

class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseMessaging _firestoreMessaging = FirebaseMessaging();
/* --------------------------- NOTE Get App Update --------------------------- */

  static Future<AppUpdate> getUpdate() async {
    DocumentSnapshot document = await FirebaseFirestore.instance
        .collection('appControl')
        .doc('appControl')
        .get();
    return AppUpdate.fromFirestore(document);
  }

  static Future<AuthUser> getAuthUser() async {
    User fbUser = FirebaseAuth.instance.currentUser;
    if (fbUser == null) return null;

    var doc = await _firestore.collection('users').doc(fbUser.uid).get();
    return AuthUser.fromFirestore(doc);
  }

  /* ---------------------------- NOTE Stream User ---------------------------- */
  static Stream<AuthUser> streamAuthUser() {
    User user = FirebaseAuth.instance.currentUser;

    if (user == null) return null;

    var ref = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .snapshots();
    return ref.map((snap) => AuthUser.fromFirestore(snap));
  }

  /* ------------------------ NOTE Sign in with Email ------------------------ */
  static Future<User> signInUserEmailAndPassword(
      {String email, String password}) async {
    try {
      ZGetUtils.showLoadingOverlay();
      UserCredential authResult = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User user = authResult.user;
      ZGetUtils.closeLoadingOverlay();

      return user;
    } catch (e) {
      ZGetUtils.closeLoadingOverlay();

      ZGetUtils.showSnackbarError(
          message: ZValidators.getMessageFromErrorCode(e));
      throw (e);
    }
  }

  /* ------------------------ NOTE Sign in with Email ------------------------ */
  static Future<User> createUserWithEmailAndPassword(
      AuthUserRegister authUserRegister) async {
    try {
      UserCredential authResult = await _auth.createUserWithEmailAndPassword(
          email: authUserRegister.email, password: authUserRegister.password);
      User user = authResult.user;
      FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .set({...authUserRegister.toJson()}, SetOptions(merge: true));
      return user;
    } catch (e) {
      ZGetUtils.showSnackbarError(
          message: ZValidators.getMessageFromErrorCode(e));
      return null;
    }
  }

  /* --------------------- NOTE Reset Password With email --------------------- */
  static Future<bool> resetPassword({String email}) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      ZGetUtils.showSnackbarSuccess(
          message: 'Email sent to $email, please check your inbox',
          duration: Duration(seconds: 5));
      return true;
    } catch (e) {
      ZGetUtils.showSnackbarError(
          message: ZValidators.getMessageFromErrorCode(e));
      return null;
    }
  }

  /* --------------------- NOTE Update Notification Status -------------------- */
  static Future<void> updateNotificationStatus(bool status) async {
    User user = FirebaseAuth.instance.currentUser;
    await _firestore
        .collection('users')
        .doc(user.uid)
        .update({'isNotificationsEnabledMain': status});
  }

/* --------------------- NOTE Update Appversion Login & dev token --------------------- */
  static Future<void> updateAppVersionLastLogin() async {
    String currentDevToken = await _firestoreMessaging.getToken();
    User fbUser = FirebaseAuth.instance.currentUser;

    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String appVersion = packageInfo.version;
    num appBuildNumber = int.tryParse(packageInfo.buildNumber) ?? 0;

    if (fbUser != null) {
      await _firestore.collection('users').doc(fbUser.uid).update({
        'appBuildNumberMain': appBuildNumber,
        'appVersionMain': appVersion,
        'devTokensMain': FieldValue.arrayUnion([currentDevToken]),
        'timestampLastLogin': DateTime.now(),
      });
    }
  }

/* --------------------- NOTE Update Appversion Login & dev token --------------------- */
  static Future<void> updateAddress(
      {Address address, AuthUser authUser}) async {
    await _firestore
        .collection('users')
        .doc(authUser.id)
        .update({'address': address.toMap()});
  }

  /* ------------------------------ NOTE Sign Out ----------------------------- */
  static signOut() async {
    ZGetUtils.showLoadingOverlay();
    User fbUser = FirebaseAuth.instance.currentUser;
    String currentDevToken = await _firestoreMessaging.getToken();

    await _firestore.collection('users').doc(fbUser.uid).update({
      'devTokensMain': FieldValue.arrayRemove([currentDevToken])
    });
    await _auth.signOut();
    ZGetUtils.closeLoadingOverlay();
  }
}
