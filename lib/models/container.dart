import 'package:cloud_firestore/cloud_firestore.dart';

import '../app_utils/z_models.dart';

class TrackingContainer {
  String documentId;
  String containerId;
  String userName;
  String userEmail;
  String userId;
  DateTime timestampCreated;
  String timestampCreatedStr;
  List<TrackingDetails> trackingDetails;
  bool isCompleted;
  List<String> locations;

  TrackingContainer(
      {this.documentId,
      this.containerId,
      this.userEmail,
      this.userName,
      this.userId,
      this.timestampCreated,
      this.timestampCreatedStr,
      this.trackingDetails,
      this.locations,
      this.isCompleted = false});

  factory TrackingContainer.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data();
    if (data == null) return null;

    return TrackingContainer(
        documentId: doc.id,
        containerId: ZModelString.toStr(data['containerId']),
        userName: ZModelString.toStr(data['userName']),
        userEmail: ZModelString.toStr(data['userEmail']),
        userId: ZModelString.toStr(data['userId']),
        timestampCreated: ZModelDateTime.toDateTime(data['timestampCreated']),
        timestampCreatedStr:
            ZModelDateTime.toDateTimeStr(data['timestampCreated']),
        isCompleted: ZModelBool.toBool(data['isCompleted']),
        trackingDetails: getOrderProducts(data['trackingDetails'] ?? []) ?? [],
        locations: ZModelLists.toListStrings(data['locations'] ?? []) ?? []);
  }
  static List<TrackingDetails> getOrderProducts(List data) {
    return data.map((list) => TrackingDetails.fromMap(list)).toList();
  }
}

class TrackingDetails {
  String id;
  String location;
  String locationId;
  DateTime timestampCreated;
  String timestampCreatedStr;
  String comment;
  String status;
  String userName;
  String userEmail;
  String userId;
  TrackingDetails(
      {this.id,
      this.location,
      this.locationId,
      this.timestampCreated,
      this.timestampCreatedStr,
      this.comment,
      this.status,
      this.userId,
      this.userName,
      this.userEmail});
  factory TrackingDetails.fromMap(Map<dynamic, dynamic> data) {
    if (data.isEmpty) return null;
    return TrackingDetails(
      id: ZModelString.toStr(data['id']),
      location: ZModelString.toStr(data['location']),
      locationId: ZModelString.toStr(data['locationId']),
      timestampCreated: ZModelDateTime.toDateTime(data['timestampCreated']),
      timestampCreatedStr:
          ZModelDateTime.toDateTimeStr(data['timestampCreated']),
      comment: ZModelString.toStr(data['comment']),
      status: ZModelString.toStr(data['status']),
      userId: ZModelString.toStr(data['userId']),
      userName: ZModelString.toStr(data['userName']),
      userEmail: ZModelString.toStr(data['userEmail']),
    );
  }
}
