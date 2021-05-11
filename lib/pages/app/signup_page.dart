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
import '../../models_providers/theme_provider.dart';
import '../../models_services/auth_service.dart';
import 'signin_page.dart';

class SignUpPage extends StatefulWidget {
  SignUpPage({Key key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  AuthUserRegister authUserRegister = AuthUserRegister();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);
    String logo = themeProvider.isThemeModeLight ? 'assets/images/app_logo_black.png' : 'assets/images/app_logo_white.png';

    return Scaffold(
      appBar: AppBar(title: Text('Sign Up')),
      body: Form(
        key: formKey,
        child: ListView(
          children: [
            SizedBox(height: 30),
            Image.asset(logo, fit: BoxFit.contain, height: 60.0),
            SizedBox(height: 10),
            ZTextFormField(
              initialValue: '',
              labelText: 'First Name',
              onValueChanged: (value) {},
              onSaved: (val) {
                authUserRegister.firstName = val;
              },
            ),
            ZTextFormField(
              initialValue: '',
              labelText: 'Last Name',
              onValueChanged: (value) {},
              onSaved: (val) {
                authUserRegister.lastName = val;
              },
            ),
            ZTextFormField(
              initialValue: '',
              labelText: 'Phone number',
              onValueChanged: (value) {},
              onSaved: (val) {
                authUserRegister.phoneNumber = val;
              },
            ),
            ZTextFormField(
              initialValue: '',
              labelText: 'Email',
              validator: (String value) => ZValidators.email(value),
              onValueChanged: (value) {},
              onSaved: (val) {
                authUserRegister.email = val;
              },
            ),
            ZTextFormField(
              initialValue: '',
              labelText: 'Password',
              obscureText: true,
              onValueChanged: (value) {},
              onSaved: (val) {
                authUserRegister.password = val;
              },
            ),
            SizedBox(height: 10),
            ZButtonRaised(
                text: 'Sign Up',
                isLoading: isLoading,
                onTap: () async {
                  if (formKey.currentState.validate()) {
                    formKey.currentState.save();
                    setState(() => isLoading = true);

                    User user = await AuthService.createUserWithEmailAndPassword(authUserRegister);
                    setState(() => isLoading = false);

                    if (user != null) authProvider.init();
                  }
                }),
            SizedBox(height: 10),
            Center(child: ZButtonText(text: 'Already have an account? Sign in', onTap: () => Get.offAll(SignInPage(), fullscreenDialog: true))),
          ],
        ),
      ),
    );
  }
}
