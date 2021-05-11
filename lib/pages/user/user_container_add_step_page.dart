import 'package:ctracker/models_providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../app_utils/z_models.dart';
import '../../components/z_button_raised.dart';
import '../../components/z_form_field.dart';
import '../../components/z_form_field_bottomsheet.dart';
import '../../models/container.dart';

class UserCTrackerAddStepPage extends StatefulWidget {
  final TrackingContainer trackingContainer;
  UserCTrackerAddStepPage({Key key, this.trackingContainer}) : super(key: key);

  @override
  _UserCTrackerAddStepPageState createState() =>
      _UserCTrackerAddStepPageState();
}

class _UserCTrackerAddStepPageState extends State<UserCTrackerAddStepPage> {
  final formKey = GlobalKey<FormState>();
  TrackingDetails newTrackingDetails = new TrackingDetails();
  TrackingContainer trackingContainer;
  List<String> locationNames;

  @override
  void initState() {
    trackingContainer = widget.trackingContainer;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final userProvide = Provider.of<UserProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add Step—' +
              ZModelStatus.nextStatus(
                  trackingContainer.trackingDetails.last.status),
          textScaleFactor: 1.0,
        ),
      ),
      body: ListView(
        children: [
          SizedBox(height: 10),
          Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Id# : ${widget.trackingContainer.containerId}',
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                          ),
                          textScaleFactor: 1.0,
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Location : ${widget.trackingContainer.trackingDetails.last.location}',
                          textScaleFactor: 1.0,
                          style: TextStyle(
                              fontWeight: FontWeight.w900,
                              color: Theme.of(context).buttonColor),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Date : ${widget.trackingContainer.trackingDetails.last.timestampCreatedStr}',
                          textScaleFactor: 1.0,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(),
                  if (trackingContainer.trackingDetails.last.status
                              .toLowerCase() ==
                          'received' ||
                      trackingContainer.trackingDetails.last.status
                              .toLowerCase() ==
                          'created')
                    ZTextFormFieldBottomSheet(
                      labelText: ZModelStatus.nextStatus(
                              trackingContainer.trackingDetails.last.status) +
                          ' Location',
                      items: List.from(userProvide.streamLocationNames.where(
                          (element) =>
                              trackingContainer.trackingDetails.last.location !=
                              element)),
                      onValueChanged: (String value) {
                        newTrackingDetails.location = value;
                      },
                      onSaved: (String value) {
                        newTrackingDetails.location = value;
                      },
                    ),
                  ZTextFormField(
                    labelText: 'Comment',
                    maxLines: 3,
                    onSaved: (value) {
                      newTrackingDetails.comment = value;
                    },
                    onValueChanged: (value) {
                      newTrackingDetails.comment = value;
                    },
                  ),
                  ZButtonRaised(
                      onTap: () async {
                        if (formKey.currentState.validate()) {
                          formKey.currentState.save();
                          newTrackingDetails.status = ZModelStatus.nextStatus(
                              trackingContainer.trackingDetails.last.status);
                          if (trackingContainer.trackingDetails.last.status
                                  .toLowerCase() ==
                              'transferred') {
                            newTrackingDetails.location = widget
                                .trackingContainer
                                .trackingDetails
                                .last
                                .location;
                          }
                          bool res = await userProvide.addTrackingStep(
                              trackingDetails: newTrackingDetails,
                              trackingContainer: widget.trackingContainer);
                          if (res) Get.back();
                        }
                      },
                      text: 'Add ' +
                          ZModelStatus.nextStatus(
                              trackingContainer.trackingDetails.last.status)),
                  SizedBox(height: 20),
                  if (trackingContainer.trackingDetails.last.status
                          .toLowerCase() ==
                      'received')
                    ZButtonRaised(
                        onTap: () async {
                          newTrackingDetails.status = ZModelStatus.getStatus(4);
                          newTrackingDetails.location =
                              trackingContainer.trackingDetails.last.location;
                          bool res = await userProvide.addTrackingStep(
                              trackingDetails: newTrackingDetails,
                              trackingContainer: widget.trackingContainer);
                          if (res) Get.back();
                        },
                        text: 'Complete'),
                ],
              )),
        ],
      ),
    );
  }
}
