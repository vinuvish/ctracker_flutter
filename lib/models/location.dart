import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ctracker/app_utils/z_models.dart';

class Location {
  String documentId;
  String name;
  DateTime timestampCreated;
  String timestampCreatedStr;

  Location(
      {this.documentId,
      this.name,
      this.timestampCreated,
      this.timestampCreatedStr});

  factory Location.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data();
    if (data == null) return null;
    return Location(
        documentId: doc.id,
        name: data['name'],
        timestampCreated: ZModelDateTime.toDateTime(data['timestampCreated']),
        timestampCreatedStr:
            ZModelDateTime.toDateTimeStr(data['timestampCreated']));
  }
}
