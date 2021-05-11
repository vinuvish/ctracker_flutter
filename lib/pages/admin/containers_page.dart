import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../components/z_button_raised.dart';
import '../../components/z_card.dart';
import '../../models/container.dart';
import '../../models_providers/admin_provider.dart';
import 'container_details_page.dart';
import 'container_new_page.dart';

class CTrackersPage extends StatefulWidget {
  CTrackersPage({Key key}) : super(key: key);

  @override
  _CTrackersPageState createState() => _CTrackersPageState();
}

class _CTrackersPageState extends State<CTrackersPage>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  @override
  void initState() {
    _tabController = new TabController(length: 2, vsync: this);
    super.initState();
  }

  refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final adminProvider = Provider.of<AdminProvider>(context);

    return Scaffold(
        appBar: AppBar(
          title: Text('cTracker'),
          centerTitle: false,
          actions: [
            if (adminProvider.streamContainer.isNotEmpty)
              ZButtonRaised(
                  onTap: () =>
                      Get.to(CTrackerNewPage(), fullscreenDialog: true),
                  padding: EdgeInsets.symmetric(),
                  width: MediaQuery.of(context).size.width * 0.30,
                  textStyle: TextStyle(color: Colors.white, fontSize: 11.5),
                  text: 'New Container')
          ],
          bottom: TabBar(
            tabs: [Tab(text: 'In Progress'), Tab(text: 'Completed')],
            controller: _tabController,
            indicatorColor: Colors.white,
            indicatorSize: TabBarIndicatorSize.tab,
            indicator:
                BoxDecoration(border: Border(bottom: BorderSide(width: 1.0))),
            labelColor: Theme.of(context).buttonColor,
          ),
          bottomOpacity: 1,
        ),
        floatingActionButton: adminProvider.streamContainer.isEmpty
            ? FloatingActionButton(
                onPressed: () =>
                    Get.to(CTrackerNewPage(), fullscreenDialog: true),
                tooltip: 'Increment',
                child: Icon(Icons.add))
            : Container(),
        body: TabBarView(controller: _tabController, children: [
          _buildTabBody(
              trackingContainer: adminProvider.streamContainerInProgress),
          _buildTabBody(
              trackingContainer: adminProvider.streamContainerCompleted),
        ]));
  }

  Widget _buildTabBody({List<TrackingContainer> trackingContainer}) {
    return ListView(
      children: [
        SizedBox(height: 8),
        for (TrackingContainer container in trackingContainer)
          ZCard(
            margin: EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            elevation: 2,
            onTap: () => Get.to(CtrackerDetailPage(
              trackingContainer: container,
            )),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Id# : ${container.containerId}',
                  style: TextStyle(fontWeight: FontWeight.w600),
                  textScaleFactor: 1.0,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  container.trackingDetails.last.location,
                  textScaleFactor: 1.0,
                  style: TextStyle(
                      fontWeight: FontWeight.w900,
                      color: Theme.of(context).buttonColor),
                ),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
      ],
    );
  }
}
