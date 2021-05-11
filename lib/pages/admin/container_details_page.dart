import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../components/z_card.dart';
import '../../models/container.dart';
import 'container_add_step_page.dart';

class CtrackerDetailPage extends StatefulWidget {
  final TrackingContainer trackingContainer;
  CtrackerDetailPage({Key key, this.trackingContainer}) : super(key: key);

  @override
  _CtrackerDetailPageState createState() => _CtrackerDetailPageState();
}

class _CtrackerDetailPageState extends State<CtrackerDetailPage> {
  List<TrackingDetails> details;

  @override
  void initState() {
    details = widget.trackingContainer.trackingDetails;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Container Details', textScaleFactor: 1.0),
        centerTitle: true,
        actions: [],
      ),
      floatingActionButton: !widget.trackingContainer.isCompleted
          ? FloatingActionButton(
              onPressed: () => Get.to(
                  CTrackerAddStepPage(
                      trackingContainer: widget.trackingContainer),
                  fullscreenDialog: true),
              tooltip: 'Increment',
              child: Icon(Icons.add))
          : null,
      body: ListView(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                  padding: EdgeInsets.all(15.0),
                  child: Text('Id# : ${widget.trackingContainer.containerId}',
                      style:
                          TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
                      textScaleFactor: 1.0)),
            ],
          ),
          for (int i = 0; i < details.length; i++)
            Column(
              children: [
                ZCard(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                        '${details[i].location}',
                        style: TextStyle(
                            fontWeight: FontWeight.w900,
                            color: details[i].status == 'Transferred'
                                ? Colors.amber
                                : details[i].status == 'Received'
                                    ? Colors.blue
                                    : details[i].status == 'Completed'
                                        ? Colors.blueGrey
                                        : Theme.of(context).buttonColor),
                        textScaleFactor: 1.0,
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                        '${details[i].status} : ${details[i].timestampCreatedStr}',
                        textScaleFactor: 1.0,
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: details[i].status == 'Transferred'
                                ? Colors.amber
                                : details[i].status == 'Received'
                                    ? Colors.blue
                                    : details[i].status == 'Completed'
                                        ? Colors.blueGrey
                                        : Colors.black),
                      ),
                      SizedBox(height: 8),
                      Text(
                        details[i].userName,
                        textScaleFactor: 1.0,
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: details[i].status == 'Transferred'
                                ? Colors.amber
                                : details[i].status == 'Received'
                                    ? Colors.blue
                                    : details[i].status == 'Completed'
                                        ? Colors.blueGrey
                                        : Colors.black),
                      ),
                      Divider(),
                      Text(
                        details[i].comment,
                        textScaleFactor: 1.0,
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: details[i].status == 'Transferred'
                                ? Colors.amber
                                : details[i].status == 'Received'
                                    ? Colors.blue
                                    : details[i].status == 'Completed'
                                        ? Colors.blueGrey
                                        : Colors.black),
                      ),
                    ],
                  ),
                ),
                if (i < details.length - 1)
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(width: 50),
                        Container(
                            padding: EdgeInsets.all(5),
                            child: Icon(Icons.arrow_downward),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.grey[300])),
                        SizedBox(width: 5),
                        Text(
                          details[i + 1]
                                  .timestampCreated
                                  .difference(details[i].timestampCreated)
                                  .inDays
                                  .toString() +
                              ' days',
                          textScaleFactor: 1.0,
                          style: TextStyle(
                              fontWeight: FontWeight.w900,
                              color: Theme.of(context).buttonColor),
                        ),
                      ],
                    ),
                  )
              ],
            ),
          SizedBox(height: 100),
        ],
      ),
    );
  }
}
