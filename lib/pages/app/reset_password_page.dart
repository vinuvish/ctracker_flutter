import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../app_utils/z_validators.dart';
import '../../components/z_button_raised.dart';
import '../../components/z_button_text.dart';
import '../../components/z_form_field.dart';
import '../../models_providers/theme_provider.dart';
import '../../models_services/auth_service.dart';
import 'signin_page.dart';

class ResetPasswordPage extends StatefulWidget {
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  FirebaseAuth auth = FirebaseAuth.instance;

  GlobalKey<ScaffoldState> globalKey = GlobalKey();

  final formKey = GlobalKey<FormState>();
  bool isLoading = false;

  String userEmail;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Scaffold(
        appBar: AppBar(title: Text('Reset Password')),
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
    String logo = themeProvider.isThemeModeLight ? 'assets/images/app_logo_black.png' : 'assets/images/app_logo_white.png';
    return Form(
      key: formKey,
      child: ListView(
        shrinkWrap: true,
        padding: EdgeInsets.all(0.0),
        children: <Widget>[
          SizedBox(height: 30),
          Image.asset(logo, fit: BoxFit.contain, height: 60.0),
          SizedBox(height: 10),
          ZTextFormField(
            initialValue: '',
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
          SizedBox(height: 20),
          ZButtonRaised(
            isLoading: isLoading,
            text: 'Submit',
            onTap: _onForgetPassword,
          ),
          SizedBox(height: 20),
          Center(child: ZButtonText(text: 'Return to sign in page', textStyle: TextStyle(fontWeight: FontWeight.bold), onTap: () => Get.offAll(SignInPage()))),
        ],
      ),
    );
  }

  void _onForgetPassword() {
    if (formKey.currentState.validate()) {
      setState(() => isLoading = true);

      formKey.currentState.save();
      AuthService.resetPassword(email: userEmail);

      setState(() => isLoading = false);
    }
  }
}
