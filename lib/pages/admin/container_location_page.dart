import 'package:ctracker/components/z_card.dart';
import 'package:ctracker/models/location.dart';
import 'package:ctracker/models_providers/admin_provider.dart';
import 'package:ctracker/pages/admin/container_location_add_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class ContainerLocationPage extends StatefulWidget {
  ContainerLocationPage({Key key}) : super(key: key);

  @override
  _ContainerLocationPageState createState() => _ContainerLocationPageState();
}

class _ContainerLocationPageState extends State<ContainerLocationPage> {
  @override
  Widget build(BuildContext context) {
    final mainProvider = Provider.of<AdminProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Locations', textScaleFactor: 1.0),
      ),
      body: ListView(
        children: [
          for (Location location in mainProvider.streamLocation)
            ZCard(
              onTap: () => Get.to(
                  ContainerLocationAddPage(
                    location: location,
                  ),
                  fullscreenDialog: true),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    '${location.name}',
                    style: TextStyle(
                        fontWeight: FontWeight.w900,
                        color: Theme.of(context).buttonColor),
                    textScaleFactor: 1.0,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    'Created : ${location.timestampCreatedStr}',
                    textScaleFactor: 1.0,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            )
        ],
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () =>
              Get.to(ContainerLocationAddPage(), fullscreenDialog: true),
          tooltip: 'Increment',
          child: Icon(Icons.add)),
    );
  }
}
