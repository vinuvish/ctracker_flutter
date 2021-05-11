import 'package:ctracker/models_providers/user_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../app_utils/z_validators.dart';
import '../../components/z_button_raised.dart';
import '../../components/z_button_text.dart';
import '../../components/z_form_field.dart';
import '../../models/auth_user.dart';
import '../../models_providers/auth_provider.dart';
import '../../models_providers/admin_provider.dart';
import '../../models_providers/theme_provider.dart';
import 'reset_password_page.dart';

class SignInPage extends StatefulWidget {
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  FirebaseAuth auth = FirebaseAuth.instance;

  GlobalKey<ScaffoldState> globalKey = GlobalKey();

  final formKey = GlobalKey<FormState>();

  String userEmail;
  String userPassword;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Scaffold(
        // appBar: AppBar(),
        key: globalKey,
        body: _buildBody(),
      ),
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
    );
  }

  Widget _buildBody() {
    final themeProvider = Provider.of<ThemeProvider>(context);
    String logo = themeProvider.isThemeModeLight
        ? 'assets/images/app_logo_black.png'
        : 'assets/images/app_logo_white.png';
    return Form(
      key: formKey,
      child: ListView(
        shrinkWrap: true,
        padding: EdgeInsets.all(0.0),
        children: <Widget>[
          SizedBox(height: 120),
          Image.asset(logo, fit: BoxFit.contain, height: 60.0),
          SizedBox(height: 10),
          ZTextFormField(
            initialValue: 'codememory101@gmail.com',
            labelText: 'Email',
            keyboardType: TextInputType.emailAddress,
            onValueChanged: (value) {
              userEmail = value.trim().toLowerCase();
            },
            onSaved: (val) {
              userEmail = val.trim();
            },
            validator: (String value) => ZValidators.email(value),
          ),
          ZTextFormField(
            initialValue: '123456',
            labelText: 'Password',
            obscureText: true,
            onValueChanged: (value) {
              userPassword = value;
            },
            onSaved: (val) {
              userPassword = val;
            },
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            alignment: Alignment.centerRight,
            child: ZButtonText(
                text: 'Reset password',
                textStyle: TextStyle(fontWeight: FontWeight.bold),
                onTap: () =>
                    Get.to(ResetPasswordPage(), fullscreenDialog: true)),
          ),
          ZButtonRaised(text: 'Login', onTap: _onSubmit),
          SizedBox(height: 20),
          // Center(child: ZButtonText(text: 'Don\'t have an account? Sign Up', onTap: () => Get.offAll(SignUpPage(), fullscreenDialog: true))),
        ],
      ),
    );
  }

  void _onSubmit() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      AuthUser authUser = await authProvider.signInUserEmailAndPassword(
          userEmail, userPassword);
      if (authUser != null) {
        if (authUser.isAdmin) {
          await Provider.of<AdminProvider>(context, listen: false).initState();
        } else {
          await Provider.of<UserProvider>(context, listen: false).initState();
        }
      }
    }
  }
}
