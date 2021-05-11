import 'package:ctracker/components/z_button_raised.dart';
import 'package:ctracker/components/z_form_field.dart';
import 'package:ctracker/models/location.dart';
import 'package:ctracker/models_providers/admin_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class ContainerLocationAddPage extends StatefulWidget {
  final Location location;
  ContainerLocationAddPage({Key key, this.location}) : super(key: key);

  @override
  _ContainerLocationAddPageState createState() =>
      _ContainerLocationAddPageState();
}

class _ContainerLocationAddPageState extends State<ContainerLocationAddPage> {
  Location location;
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    if (widget.location != null) {
      location = widget.location;
    } else {
      location = new Location();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final mainProvider = Provider.of<AdminProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add Location',
          textScaleFactor: 1.0,
        ),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          Form(
              key: formKey,
              child: Column(
                children: [
                  ZTextFormField(
                    labelText: 'Name',
                    textCapitalization: TextCapitalization.words,
                    initialValue: location.name ?? '',
                    onSaved: (value) {
                      location.name = value;
                    },
                    onValueChanged: (value) {
                      location.name = value;
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ZButtonRaised(
                      onTap: () async {
                        if (formKey.currentState.validate()) {
                          formKey.currentState.save();
                          bool res = await mainProvider.addLocation(
                              location: location);
                          if (res) {
                            Get.back();
                          }
                        }
                      },
                      text: widget.location != null ? 'Update' : 'Add')
                ],
              ))
        ],
      ),
    );
  }
}
