import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../app_utils/z_models.dart';
import '../../components/z_button_raised.dart';
import '../../components/z_form_field.dart';
import '../../components/z_form_field_bottomsheet.dart';
import '../../components/z_form_field_calendar.dart';
import '../../models/container.dart';
import '../../models_providers/admin_provider.dart';

class CTrackerNewPage extends StatefulWidget {
  CTrackerNewPage({Key key}) : super(key: key);

  @override
  _CTrackerNewPageState createState() => _CTrackerNewPageState();
}

class _CTrackerNewPageState extends State<CTrackerNewPage> {
  final formKey = GlobalKey<FormState>();
  TrackingDetails trackingDetails = new TrackingDetails();
  @override
  Widget build(BuildContext context) {
    final userProvide = Provider.of<AdminProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('New Container'),
        actions: [],
      ),
      body: ListView(
        children: [
          SizedBox(height: 10),
          Form(
              key: formKey,
              child: Column(
                children: [
                  ZTextFormField(
                    labelText: 'Id Number',
                    onSaved: (value) {
                      trackingDetails.id = value;
                    },
                    onValueChanged: (value) {
                      trackingDetails.id = value;
                    },
                  ),
                  ZTextFormFieldBottomSheet(
                    labelText: 'Starting Location',
                    items: userProvide.streamLocationNames,
                    onValueChanged: (String value) {
                      trackingDetails.location = value;
                    },
                    onSaved: (String value) {
                      trackingDetails.location = value;
                    },
                  ),
                  ZTextFormFieldCalendar(
                    labelText: 'Entry Date',
                    onValueChanged: (value) {
                      trackingDetails.timestampCreated = value;
                    },
                    onSaved: (value) {
                      trackingDetails.timestampCreated = value;
                    },
                  ),
                  ZTextFormField(
                    labelText: 'Comment',
                    maxLines: 3,
                    onSaved: (value) {
                      trackingDetails.comment = value;
                    },
                    onValueChanged: (value) {
                      trackingDetails.comment = value;
                    },
                  ),
                  ZButtonRaised(
                      onTap: () async {
                        if (formKey.currentState.validate()) {
                          formKey.currentState.save();
                          trackingDetails.status = ZModelStatus.getStatus(1);
                          bool res = await userProvide.addContainer(
                              trackingDetails: trackingDetails);
                          if (res) Get.back();
                        }
                      },
                      text: 'Add Container'),
                ],
              )),
        ],
      ),
    );
  }
}
