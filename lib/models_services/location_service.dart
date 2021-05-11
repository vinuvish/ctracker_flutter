import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ctracker/app_utils/z_get_utils.dart';
import 'package:ctracker/models/location.dart';
import 'package:flutter/foundation.dart';

class LocationService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /* --------------------------- NOTE Stream Location --------------------------- */
  static Future<Stream<List<Location>>> streamLocation() async {
    var ref = _firestore
        .collection('locations')
        .orderBy('timestampCreated', descending: true)
        .snapshots()
        .asBroadcastStream();

    return ref.map(
        (list) => list.docs.map((doc) => Location.fromFirestore(doc)).toList());
  }

  static Future<bool> addLocation({@required Location location}) async {
    try {
      ZGetUtils.showLoadingOverlay();
      await _firestore.collection('locations').doc(location.documentId).set(
          {'name': location.name, 'timestampCreated': DateTime.now()},
          SetOptions(merge: true));
      ZGetUtils.closeLoadingOverlay();
      return true;
    } catch (e) {
      ZGetUtils.showSnackbarError(message: e);
      return false;
    }
  }
}
