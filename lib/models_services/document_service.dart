// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// import '../app_utils/z_get_utils.dart';
// import '../models/app_update.dart';
// import '../models/auth_user.dart';
// import '../models/document.dart';

// class DocumentService {
//   static final FirebaseAuth _auth = FirebaseAuth.instance;
//   static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

// /* --------------------------- NOTE Get App Update --------------------------- */

//   static Future<AppUpdate> getUpdate() async {
//     DocumentSnapshot document = await FirebaseFirestore.instance.collection('appControl').doc('appControl').get();
//     return AppUpdate.fromFirestore(document);
//   }

//   static Future<DocumentModel> getDocument() async {
//     User fbUser = FirebaseAuth.instance.currentUser;
//     if (fbUser == null) return null;

//     var doc = await _firestore.collection('documents').doc(fbUser.uid).get();
//     return DocumentModel.fromFirestore(doc);
//   }

//   static Future<bool> addDocument({DocumentModel document, AuthUser authUser}) async {
//     User fbUser = FirebaseAuth.instance.currentUser;

//     if (fbUser == null) return null;

//     try {
//       document = await DocumentModel.getUploadDocument(d: document, authUser: authUser);

//       await _firestore.collection('documents').doc(fbUser.uid).set(document.toMap(), SetOptions(merge: true));
//       await _firestore.collection('users').doc(fbUser.uid).update({'documents': document.state});

//       ZGetUtils.showSnackbarSuccess(message: 'Documents updated');
//       return true;
//     } catch (e) {
//       print(e);
//       ZGetUtils.showSnackbarError(message: 'Error updating document');
//       return false;
//     }
//   }
// }
