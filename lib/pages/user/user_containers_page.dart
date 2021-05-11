import 'package:ctracker/models_providers/user_provider.dart';
import 'package:ctracker/pages/user/user_container_details_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../components/z_card.dart';
import '../../models/container.dart';

class UserCTrackersPage extends StatefulWidget {
  UserCTrackersPage({Key key}) : super(key: key);

  @override
  _UserCTrackersPageState createState() => _UserCTrackersPageState();
}

class _UserCTrackersPageState extends State<UserCTrackersPage>
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
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
        appBar: AppBar(
          title: Text('cTracker'),
          centerTitle: false,
          actions: [],
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
        body: TabBarView(controller: _tabController, children: [
          _buildTabBody(
              trackingContainer: userProvider.streamContainerInProgress),
          _buildTabBody(
              trackingContainer: userProvider.streamContainerCompleted),
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
            onTap: () => Get.to(UserCtrackerDetailPage(
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
