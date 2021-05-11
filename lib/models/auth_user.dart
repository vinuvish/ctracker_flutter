import 'package:cloud_firestore/cloud_firestore.dart';

import '../app_utils/z_models.dart';
import 'address.dart';

class AuthUser {
  String id;
  String email;
  String firstName;
  String lastName;
  String phoneNumber;
  String password;
  bool isActive;
  bool isAdmin;
  bool isNotificationsEnabledMain;
  Address address;
  String submittedDocontainerId;
  DateTime timestampLastLogin;
  String timestampLastLoginStr;
  DateTime timestampCreated;
  String timestampCreatedStr;
  List<String> locations;
  List<String> locationIds;

  AuthUser(
      {this.id,
      this.email,
      this.firstName,
      this.isActive,
      this.isAdmin = false,
      this.lastName,
      this.phoneNumber,
      this.password,
      this.isNotificationsEnabledMain,
      this.address,
      this.submittedDocontainerId,
      this.timestampCreated,
      this.timestampCreatedStr,
      this.timestampLastLogin,
      this.timestampLastLoginStr,
      this.locations,
      this.locationIds});

  String get getUserName => '$firstName $lastName';
  String get getFullName => '$firstName $lastName';

  String get getInitials {
    String fInitial = '';
    String lInitial = '';
    if (firstName.length > 0) fInitial = '${firstName[0].toUpperCase()}';
    if (lastName.length > 0) lInitial = '${lastName[0].toUpperCase()}';
    return '$fInitial$lInitial';
  }

  factory AuthUser.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data();
    if (data == null) return null;
    return AuthUser(
        id: doc.id,
        email: ZModelString.toStr(data['email']),
        firstName: ZModelString.toStr(data['firstName']),
        isActive: ZModelBool.toBool(data['isActive'], defaultVal: true),
        isAdmin: ZModelBool.toBool(data['isAdmin'], defaultVal: true),
        isNotificationsEnabledMain: ZModelBool.toBool(
            data['isNotificationsEnabledMain'],
            defaultVal: true),
        lastName: ZModelString.toStr(data['lastName']),
        phoneNumber: ZModelString.toStr(data['phoneNumber']),
        address: Address.fromMap(data['address']),
        submittedDocontainerId:
            ZModelString.toStr(data['submittedDocontainerId']),
        timestampCreated: ZModelDateTime.toDateTime(data['timestampCreated']),
        timestampCreatedStr:
            ZModelDateTime.toDateTimeStr(data['timestampCreated']),
        timestampLastLogin:
            ZModelDateTime.toDateTime(data['timestampLastLogin']),
        timestampLastLoginStr:
            ZModelDateTime.toDateTimeStr(data['timestampLastLogin']),
        locations: ZModelLists.toListStrings(data['locations']),
        locationIds: ZModelLists.toListStrings(data['locationIds']));
  }
  factory AuthUser.clone(AuthUser authUser) {
    return AuthUser(
        id: authUser.id,
        email: authUser.email,
        firstName: authUser.firstName,
        isActive: authUser.isActive,
        isAdmin: authUser.isAdmin,
        isNotificationsEnabledMain: authUser.isNotificationsEnabledMain,
        lastName: authUser.lastName,
        phoneNumber: authUser.phoneNumber,
        address: authUser.address,
        submittedDocontainerId: authUser.submittedDocontainerId,
        timestampCreated: authUser.timestampCreated,
        timestampCreatedStr: authUser.timestampCreatedStr,
        timestampLastLogin: authUser.timestampLastLogin,
        timestampLastLoginStr: authUser.timestampLastLoginStr,
        locations: authUser.locations);
  }

  toJson() => {
        'id': id,
        'email': email,
        'password': password,
        'firstName': firstName,
        'lastName': lastName,
        'phoneNumber': phoneNumber,
        'isActive': isActive,
        'isAdmin': isAdmin,
        'locations': locations,
        'locationIds': locationIds,
      };
}

class AuthUserRegister {
  String email;
  String firstName;
  String lastName;
  String password;
  String phoneNumber;
  DateTime timestampCreated;

  AuthUserRegister({
    this.email,
    this.firstName,
    this.lastName,
    this.password,
    this.phoneNumber,
    this.timestampCreated,
  });

  toJson() => {
        'email': email.toLowerCase().trim(),
        'firstName': firstName.trim(),
        'phoneNumber': phoneNumber.trim(),
        'isActive': true,
        'isNotificationsEnabledMain': true,
        'lastName': lastName.trim(),
        'timestampCreated': DateTime.now()
      };
}
