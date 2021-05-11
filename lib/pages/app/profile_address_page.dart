import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../app_utils/z_validators.dart';
import '../../components/z_button_raised.dart';
import '../../components/z_form_field.dart';
import '../../models/address.dart';
import '../../models_providers/auth_provider.dart';
import '../../models_providers/theme_provider.dart';
import '../../models_services/auth_service.dart';

class ProfileAddressPage extends StatefulWidget {
  final Address address;
  ProfileAddressPage({Key key, @required this.address}) : super(key: key);

  @override
  _ProfileAddressPageState createState() => _ProfileAddressPageState();
}

class _ProfileAddressPageState extends State<ProfileAddressPage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Update Address')),
      body: Form(
        key: formKey,
        child: ListView(
          children: [
            SizedBox(height: 10),
            ZTextFormField(
              initialValue: widget.address.country,
              labelText: 'Country',
              onValueChanged: (value) {},
              validator: ZValidators.none,
              onSaved: (val) {
                widget.address.country = val;
              },
            ),
            ZTextFormField(
              initialValue: widget.address.address1,
              labelText: 'Address line 1',
              onValueChanged: (value) {},
              onSaved: (val) {
                widget.address.address1 = val;
              },
            ),
            ZTextFormField(
              initialValue: widget.address.address2,
              labelText: 'Address line 2',
              onValueChanged: (value) {},
              onSaved: (val) {
                widget.address.address2 = val;
              },
            ),
            ZTextFormField(
              initialValue: widget.address.city,
              labelText: 'City',
              onValueChanged: (value) {},
              onSaved: (val) {
                widget.address.city = val;
              },
            ),
            ZTextFormField(
              initialValue: widget.address.state,
              labelText: 'State',
              onValueChanged: (value) {},
              onSaved: (val) {
                widget.address.state = val;
              },
            ),
            ZTextFormField(
              initialValue: widget.address.zip,
              labelText: 'ZIP',
              onValueChanged: (value) {},
              onSaved: (val) {
                widget.address.zip = val;
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
                    AuthService.updateAddress(address: widget.address, authUser: authProvider.authUser);
                    Get.back();
                  }
                }),
          ],
        ),
      ),
    );
  }
}
