import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../app_utils/z_get_utils.dart';
import '../../components/z_button_raised.dart';
import '../../models_providers/auth_provider.dart';
import 'signin_page.dart';

class TermsAndConditionsPage extends StatefulWidget {
  TermsAndConditionsPage({Key key}) : super(key: key);

  @override
  _TermsAndConditionsPageState createState() => _TermsAndConditionsPageState();
}

class _TermsAndConditionsPageState extends State<TermsAndConditionsPage> {
  String terms =
      'WHEREAS, Driver is a person seeking to provide transportation and/or delivery services bymeans that include, but are not limited to, being employed by ground transportation serviceproviders, receiving offers to provide transportation services from transportation aggregatorservices, requests from travel agents, requests from digital platforms that refer persons seekingfor-hire transportation (“Riders”) to Driver for the purpose of providing transportation and/ordelivery services and/or to provide transportation as may be requested from time to time by thirdparty providers under agreement with Ground Standards or  to  certain Ground Standard’saffiliates ("Third-Party Affiliates").';
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
      appBar: AppBar(title: Text('Terms & Conditions'), actions: []),
      body: ListView(
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Text(terms, style: TextStyle(), textAlign: TextAlign.justify),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Text(terms, style: TextStyle(), textAlign: TextAlign.justify),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Text(terms, style: TextStyle(), textAlign: TextAlign.justify),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Text(terms, style: TextStyle(), textAlign: TextAlign.justify),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Text(terms, style: TextStyle(), textAlign: TextAlign.justify),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Text(terms, style: TextStyle(), textAlign: TextAlign.justify),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ZButtonRaised(
                onTap: () => Get.offAll(SignInPage()),
                text: 'Reject',
                backgroundColor: Colors.red,
                width: Get.mediaQuery.size.width * .4,
              ),
              ZButtonRaised(
                onTap: () => authProvider.acceptTermsAndConditons(),
                text: 'Accept',
                width: Get.mediaQuery.size.width * .4,
              ),
            ],
          )
        ],
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
