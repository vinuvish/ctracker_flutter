import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../app_utils/z_get_utils.dart';
import '../../components/z_button_outlined.dart';
import '../../components/z_button_text.dart';
import '../../models_providers/auth_provider.dart';
import 'signin_page.dart';

class AccountNotVerifiedPage extends StatefulWidget {
  AccountNotVerifiedPage({Key key}) : super(key: key);

  @override
  _AccountNotVerifiedPageState createState() => _AccountNotVerifiedPageState();
}

class _AccountNotVerifiedPageState extends State<AccountNotVerifiedPage> {
  @override
  void initState() {
    sendEmailVerificationInit();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
      appBar: AppBar(actions: [
        Row(
          children: [
            ZButtonText(
              text: 'Go to Sign In',
              textStyle: TextStyle(color: Colors.blue, fontWeight: FontWeight.w700, fontSize: 16),
              onTap: () => Get.offAll(SignInPage()),
            ),
          ],
        ),
      ]),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset('assets/images/acc_not_verified.png', width: MediaQuery.of(context).size.width * 0.5),
            SizedBox(height: 15),
            Text('Email not verified ', textAlign: TextAlign.center, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, letterSpacing: 0.3)),
            SizedBox(height: 20),
            ZButtonOutlined(text: 'Check Verification', onTap: () => checkEmailVerification(authProvider)),
            SizedBox(height: 40),
            ZButtonText(text: 'Resend Verification', onTap: sendEmailVerification),
            SizedBox(height: 60)
          ],
        ),
      ),
    );
  }

  void sendEmailVerificationInit() {
    if (!FirebaseAuth.instance.currentUser.emailVerified) {
      FirebaseAuth.instance.currentUser.sendEmailVerification();
    }
  }

  void sendEmailVerification() {
    if (!FirebaseAuth.instance.currentUser.emailVerified) {
      FirebaseAuth.instance.currentUser.sendEmailVerification();
      ZGetUtils.showSnackbarSuccess(message: 'Verification email sent!');
    }
  }

  void checkEmailVerification(AuthProvider authProvider) {
    FirebaseAuth.instance.currentUser.reload();
    FirebaseAuth.instance.currentUser.reload();
    if (FirebaseAuth.instance.currentUser.emailVerified) {
      authProvider.init();
    } else {
      ZGetUtils.showSnackbarError(message: 'Email not verified');
    }
  }
}
