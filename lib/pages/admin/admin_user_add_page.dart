import 'package:ctracker/app_utils/z_validators.dart';
import 'package:ctracker/components/z_button_raised.dart';
import 'package:ctracker/components/z_button_text.dart';
import 'package:ctracker/components/z_form_field_bottomsheet_multi.dart';

import 'package:ctracker/components/z_form_field.dart';
import 'package:ctracker/models/auth_user.dart';
import 'package:ctracker/models_providers/admin_provider.dart';
import 'package:ctracker/pages/admin/admin_user_reset_password_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class AdminUserAddPage extends StatefulWidget {
  final AuthUser authUser;
  AdminUserAddPage({Key key, this.authUser}) : super(key: key);

  @override
  _AdminUserAddPageState createState() => _AdminUserAddPageState();
}

class _AdminUserAddPageState extends State<AdminUserAddPage> {
  AuthUser authUser;
  var uuid = Uuid();
  var password;
  List<String> selectedItems;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  void initState() {
    password = uuid.v1().toString().substring(0, 6);
    if (widget.authUser != null) {
      authUser = widget.authUser;
      selectedItems = widget.authUser.locations;
    } else {
      authUser = new AuthUser();
      selectedItems = [];
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final adminProvider = Provider.of<AdminProvider>(context);
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            widget.authUser == null ? 'Add User' : 'Update User',
            textScaleFactor: 1.0,
          ),
          actions: [
            if (widget.authUser != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ZButtonText(
                      text: 'Reset Password',
                      textStyle: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic),
                      onTap: () => Get.to(
                          AdminUserResetPasswordPage(
                            authUser: widget.authUser,
                          ),
                          fullscreenDialog: true))
                ],
              )
          ],
        ),
        body: ListView(
          children: [
            Form(
              key: formKey,
              child: Column(
                children: [
                  ZTextFormField(
                      labelText: 'First Name',
                      initialValue: authUser.firstName ?? '',
                      onSaved: (value) {
                        authUser.firstName = value.trim();
                      },
                      onValueChanged: (value) {
                        authUser.firstName = value.trim();
                      }),
                  ZTextFormField(
                      labelText: 'Last Name',
                      initialValue: authUser.lastName ?? '',
                      onSaved: (value) {
                        authUser.lastName = value.trim();
                      },
                      onValueChanged: (value) {
                        authUser.lastName = value.trim();
                      }),
                  ZTextFormField(
                      labelText: 'Email',
                      validator: (value) => ZValidators.email(value),
                      initialValue: authUser.email ?? '',
                      onSaved: (value) {
                        authUser.email = value.trim();
                      },
                      onValueChanged: (value) {
                        authUser.email = value.trim();
                      }),
                  ZTextFormField(
                      labelText: 'Phone Number',
                      keyboardType: TextInputType.number,
                      initialValue: authUser.phoneNumber ?? '',
                      onSaved: (value) {
                        authUser.phoneNumber = value.trim();
                      },
                      onValueChanged: (value) {
                        authUser.phoneNumber = value.trim();
                      }),
                  if (widget.authUser == null)
                    ZTextFormField(
                        labelText: 'Password',
                        keyboardType: TextInputType.visiblePassword,
                        initialValue: password,
                        onSaved: (value) {
                          authUser.password = value ?? password;
                        },
                        onValueChanged: (value) {
                          authUser.password = value.trim();
                        }),
                  ZFormFieldBottomSheetMulti(
                    items: adminProvider.streamLocationNames,
                    labelText: 'Select Locations',
                    selectedItems: selectedItems,
                    onChanged: (v) {
                      selectedItems = v;

                      setState(() {});
                    },
                    onSaved: (value) {
                      authUser.locations = value;
                    },
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      children: <Widget>[
                        Text("Activate"),
                        Spacer(),
                        Switch(
                          activeColor: Theme.of(context).buttonColor,
                          value: authUser.isActive ?? false,
                          onChanged: (val) {
                            authUser.isActive = val;
                            setState(() {});
                          },
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      children: <Widget>[
                        Text("Admin"),
                        Spacer(),
                        Switch(
                          activeColor: Theme.of(context).buttonColor,
                          value: authUser.isAdmin ?? false,
                          onChanged: (val) {
                            authUser.isAdmin = val;
                            setState(() {});
                          },
                        )
                      ],
                    ),
                  ),
                  ZButtonRaised(
                      onTap: () async {
                        if (formKey.currentState.validate()) {
                          formKey.currentState.save();
                          bool res;
                          if (widget.authUser == null) {
                            res = await adminProvider.httpsUserCreateRequest(
                                authUser: authUser);
                          } else {
                            res = await adminProvider.httpsUserUpdateRequest(
                                authUser: authUser);
                          }
                          if (res) {
                            await Future.delayed(Duration(seconds: 3));
                            Get.back();
                          }
                        }
                      },
                      text: widget.authUser != null ? 'Update' : 'Create')
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
