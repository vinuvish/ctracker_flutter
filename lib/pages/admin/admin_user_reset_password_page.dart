import 'package:ctracker/components/z_button_raised.dart';
import 'package:ctracker/components/z_form_field.dart';
import 'package:ctracker/models/auth_user.dart';
import 'package:ctracker/models_providers/admin_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class AdminUserResetPasswordPage extends StatefulWidget {
  final AuthUser authUser;
  AdminUserResetPasswordPage({Key key, this.authUser}) : super(key: key);

  @override
  _AdminUserResetPasswordPageState createState() =>
      _AdminUserResetPasswordPageState();
}

class _AdminUserResetPasswordPageState
    extends State<AdminUserResetPasswordPage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  var uuid = Uuid();
  var password;
  @override
  void initState() {
    password = uuid.v1().toString().substring(0, 6);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AdminProvider>(context);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Reset password',
            textScaleFactor: 1.0,
          ),
          actions: [],
        ),
        body: Form(
          key: formKey,
          child: ListView(
            children: <Widget>[
              ZTextFormField(
                  labelText: 'Password',
                  keyboardType: TextInputType.visiblePassword,
                  initialValue: password,
                  onSaved: (value) {
                    widget.authUser.password = value ?? password;
                  },
                  onValueChanged: (value) {
                    widget.authUser.password = value.trim();
                  }),
              ZButtonRaised(
                  text: 'Submit',
                  onTap: () async {
                    if (formKey.currentState.validate()) {
                      formKey.currentState.save();
                      bool res = await authProvider.httpsUserPasswordReset(
                          authUser: widget.authUser);
                      if (res) {
                        await Future.delayed(Duration(seconds: 3));
                        Get.back();
                      }
                    }
                  })
            ],
          ),
        ),
      ),
    );
  }
}
