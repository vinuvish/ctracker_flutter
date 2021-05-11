import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';

import '../app_utils/z_get_utils.dart';
import '../models/auth_user.dart';
import '../models/container.dart';

class ContainerService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /* --------------------------- NOTE Stream Containers --------------------------- */
  static Future<Stream<List<TrackingContainer>>> streamTrackingContainers(
      {AuthUser authUser}) async {
    var ref = _firestore
        .collection('containers')
        .orderBy('timestampCreated', descending: true)
        .snapshots()
        .asBroadcastStream();

    return ref.map((list) =>
        list.docs.map((doc) => TrackingContainer.fromFirestore(doc)).toList());
  }

  static Future<bool> addContainer(
      {@required TrackingDetails trackingDetails,
      @required AuthUser authUser}) async {
    try {
      ZGetUtils.showLoadingOverlay();
      await _firestore.collection('containers').add({
        'containerId': trackingDetails.id,
        'userName': authUser.getFullName,
        'userEmail': authUser.email,
        'userId': authUser.id,
        'timestampCreated': DateTime.now(),
        'locations': FieldValue.arrayUnion([trackingDetails.location]),
        'trackingDetails': FieldValue.arrayUnion(convertTrackingDetails(
            trackingDetails: trackingDetails, authUser: authUser)),
      });
      ZGetUtils.closeLoadingOverlay();
      return true;
    } catch (e) {
      ZGetUtils.closeLoadingOverlay();
      ZGetUtils.showSnackbarError(message: e);
      return false;
    }
  }

  static Future<bool> addTrackingStep(
      {@required TrackingDetails trackingDetails,
      @required TrackingContainer trackingContainer,
      @required AuthUser authUser}) async {
    ZGetUtils.closeLoadingOverlay();
    try {
      await _firestore
          .collection('containers')
          .doc(trackingContainer.documentId)
          .set({
        'isCompleted': trackingContainer.isCompleted,
        'trackingDetails': FieldValue.arrayUnion(convertTrackingDetails(
            trackingDetails: trackingDetails, authUser: authUser)),
      }, SetOptions(merge: true));
      ZGetUtils.closeLoadingOverlay();
      return true;
    } catch (e) {
      ZGetUtils.closeLoadingOverlay();
      ZGetUtils.showSnackbarError(message: e);
      return false;
    }
  }

  static convertTrackingDetails(
      {TrackingDetails trackingDetails, @required AuthUser authUser}) {
    List<Map<String, dynamic>> trackingDetailsMap = [];
    trackingDetailsMap = [
      {
        'locationId': trackingDetails.locationId,
        'timestampCreated': trackingDetails.timestampCreated ?? DateTime.now(),
        'comment': trackingDetails.comment,
        'status': trackingDetails.status,
        'userName': authUser.getFullName,
        'userEmail': authUser.email,
        'userId': authUser.id,
      }
    ];
    return trackingDetailsMap;
  }
}
