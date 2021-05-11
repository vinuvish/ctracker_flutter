import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/z_button_raised.dart';
import '../../components/z_form_field.dart';
import '../../models_providers/auth_provider.dart';
import '../../models_providers/theme_provider.dart';

class ProfileInfoPage extends StatefulWidget {
  ProfileInfoPage({Key key}) : super(key: key);

  @override
  _ProfileInfoPageState createState() => _ProfileInfoPageState();
}

class _ProfileInfoPageState extends State<ProfileInfoPage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Update Info')),
      body: Form(
        key: formKey,
        child: ListView(
          children: [
            SizedBox(height: 10),
            ZTextFormField(
              initialValue: authProvider.authUser.firstName,
              labelText: 'First Name',
              onValueChanged: (value) {},
              onSaved: (val) {
                authProvider.authUser.firstName = val;
              },
            ),
            ZTextFormField(
              initialValue: authProvider.authUser.lastName,
              labelText: 'Last Name',
              onValueChanged: (value) {},
              onSaved: (val) {
                authProvider.authUser.lastName = val;
              },
            ),
            ZTextFormField(
              initialValue: authProvider.authUser.phoneNumber,
              labelText: 'Phone number',
              onValueChanged: (value) {},
              onSaved: (val) {
                authProvider.authUser.phoneNumber = val;
              },
            ),
            SizedBox(height: 10),
            ZButtonRaised(
                text: 'Submit',
                isLoading: isLoading,
                onTap: () async {
                  if (formKey.currentState.validate()) {
                    formKey.currentState.save();
                    setState(() => isLoading = true);
                  }
                }),
          ],
        ),
      ),
    );
  }
}
