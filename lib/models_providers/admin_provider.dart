import 'dart:async';

import 'package:ctracker/models/location.dart';
import 'package:ctracker/models_services/location_service.dart';
import 'package:ctracker/models_services/user_service.dart';
import 'package:flutter/widgets.dart';

import '../models/auth_user.dart';
import '../models/container.dart';
import '../models_services/auth_service.dart';
import '../models_services/container_service.dart';

class AdminProvider with ChangeNotifier {
  StreamSubscription<AuthUser> _streamSubscriptionUser;

  AuthUser _authUser = AuthUser();
  AuthUser get authUser => _authUser;
/* -------------------------------- NOTE Init ------------------------------- */
  Future initState() async {
    Stream<AuthUser> streamAuthUser = AuthService.streamAuthUser();
    _streamSubscriptionUser = streamAuthUser.listen((r) {
      _authUser = r;
      streamFetchLocation();
      streamFetchTrackingContainers();
      streamFetchAllUsers();
      notifyListeners();
    });
  }

  /* ------------------------------ NOTE Containers ----------------------------- */
  StreamSubscription<List<TrackingContainer>> _streamSubscriptionContainer;
  List<TrackingContainer> _streamContainer = [];
  List<TrackingContainer> get streamContainer => _streamContainer;

  List<TrackingContainer> _streamContainerInProgress = [];
  List<TrackingContainer> get streamContainerInProgress =>
      _streamContainerInProgress;
  List<TrackingContainer> _streamContainerCompleted = [];
  List<TrackingContainer> get streamContainerCompleted =>
      _streamContainerCompleted;

  Future streamFetchTrackingContainers() async {
    _streamContainer = [];
    _streamContainerInProgress = [];
    _streamContainerCompleted = [];

    var res =
        await ContainerService.streamTrackingContainers(authUser: authUser);

    _streamSubscriptionContainer = res.listen((r) {
      _streamContainer = r;
      _streamContainerInProgress = [];
      _streamContainerCompleted = [];

      for (int i = 0; i < _streamContainer.length; i++) {
        for (int j = 0; j < _streamContainer[i].trackingDetails.length; j++) {
          _streamContainer[i].trackingDetails[j].location = streamLocation
              .firstWhere(
                  (element) =>
                      element.documentId ==
                      _streamContainer[i].trackingDetails[j].locationId,
                  orElse: () => null)
              .name;
        }
      }

      _streamContainer.forEach((element) {
        if (element.isCompleted) {
          _streamContainerCompleted.add(element);
        } else {
          _streamContainerInProgress.add(element);
        }
      });
      notifyListeners();
    });
  }

  Future<bool> addContainer({@required TrackingDetails trackingDetails}) async {
    trackingDetails.locationId = streamLocation
        .firstWhere((element) => element.name == trackingDetails.location)
        .documentId;
    bool res = await ContainerService.addContainer(
        trackingDetails: trackingDetails, authUser: authUser);

    return res;
  }

  Future<bool> addTrackingStep(
      {@required TrackingContainer trackingContainer,
      @required TrackingDetails trackingDetails}) async {
    trackingDetails.locationId = streamLocation
        .firstWhere((element) => element.name == trackingDetails.location)
        .documentId;
    if (trackingDetails.status == 'Completed') {
      trackingContainer.isCompleted = true;
    }
    bool res = await ContainerService.addTrackingStep(
        trackingDetails: trackingDetails,
        trackingContainer: trackingContainer,
        authUser: authUser);

    return res;
  }

  /* ------------------------------ NOTE Location ----------------------------- */

  StreamSubscription<List<Location>> _streamSubscriptionLocation;
  List<Location> _streamLocation = [];
  List<Location> get streamLocation => _streamLocation;

  List<String> _streamLocationNames = [];
  List<String> get streamLocationNames => _streamLocationNames;

  Future streamFetchLocation() async {
    var res = await LocationService.streamLocation();

    _streamSubscriptionLocation = res.listen((r) {
      _streamLocationNames = [];
      _streamLocation = r;
      _streamLocation.forEach((element) {
        _streamLocationNames.add(element.name);
      });
      notifyListeners();
    });
  }

  Future<bool> addLocation({Location location}) async {
    bool res = await LocationService.addLocation(location: location);
    return res;
  }

  /* ------------------------------ NOTE Users ----------------------------- */
  StreamSubscription<List<AuthUser>> _streamSubscriptionUsers;
  List<AuthUser> _streamUsers = [];
  List<AuthUser> get streamUsers => _streamUsers;
  Future streamFetchAllUsers() async {
    var ref = await UserService.streamAllUsers();
    _streamSubscriptionUsers = ref.listen((r) {
      _streamUsers = r;
      for (int i = 0; i < _streamUsers.length; i++) {
        List<String> loc = [];
        _streamUsers[i].locationIds.forEach((element) {
          Location userLocation = streamLocation.firstWhere(
              (streamLoc) => streamLoc.documentId == element,
              orElse: () => null);
          if (userLocation != null) {
            loc.add(userLocation?.name);
          }
        });
        _streamUsers[i].locations = loc;
      }
      notifyListeners();
    });
  }

  Future<bool> httpsUserCreateRequest({AuthUser authUser}) async {
    List<String> locationID = [];
    authUser.locations.forEach((loc) {
      locationID.add(streamLocation
          .firstWhere((element) => element.name == loc)
          .documentId);
    });
    authUser.locationIds = locationID;
    bool res = await UserService.httpsUserCreateRequest(authuser: authUser);
    return res;
  }

  Future<bool> httpsUserUpdateRequest({AuthUser authUser}) async {
    List<String> locationID = [];
    authUser.locations.forEach((loc) {
      locationID.add(streamLocation
          .firstWhere((element) => element.name == loc)
          .documentId);
    });
    authUser.locationIds = locationID;
    bool res = await UserService.httpsUserUpdateRequest(authuser: authUser);
    return res;
  }

  Future<bool> httpsUserPasswordReset({AuthUser authUser}) async {
    bool res = await UserService.httpsUserPasswordReset(authuser: authUser);

    return res;
  }

  /* ------------------------------ NOTE State ----------------------------- */

  void clearStreams() {
    _streamSubscriptionUser?.cancel();
    _streamSubscriptionContainer?.cancel();
    _streamSubscriptionLocation?.cancel();
    _streamSubscriptionUsers?.cancel();
  }

  void clearAllStates() {
    _authUser = null;
    _streamContainer = [];
    _streamContainerInProgress = [];
    _streamContainerCompleted = [];
    _streamLocation = [];
    _streamLocationNames = [];
    _streamUsers = [];
  }
}
