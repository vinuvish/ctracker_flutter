import 'dart:async';

import 'package:ctracker/models/auth_user.dart';
import 'package:ctracker/models/container.dart';
import 'package:ctracker/models/location.dart';
import 'package:ctracker/models_services/auth_service.dart';
import 'package:ctracker/models_services/container_service.dart';
import 'package:ctracker/models_services/location_service.dart';
import 'package:flutter/cupertino.dart';

class UserProvider with ChangeNotifier {
  StreamSubscription<AuthUser> _streamSubscriptionUser;

  AuthUser _authUser = AuthUser();
  AuthUser get authUser => _authUser;
/* -------------------------------- NOTE Init ------------------------------- */
  Future initState() async {
    Stream<AuthUser> streamAuthUser = AuthService.streamAuthUser();
    _streamSubscriptionUser = streamAuthUser.listen((r) {
      _authUser = r;
      streamFetchTrackingContainers();
      streamFetchLocation();
      getUserPermissionLocation();
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

  getUserPermissionLocation() {
    List<String> loc = [];
    _authUser.locationIds.forEach((element) {
      Location userLocation = streamLocation.firstWhere(
          (streamLoc) => streamLoc.documentId == element,
          orElse: () => null);
      if (userLocation != null) {
        loc.add(userLocation?.name);
      }
    });
    _authUser.locations = loc;
    print(_authUser.locations);
  }

  Future<bool> addTrackingStep(
      {@required TrackingContainer trackingContainer,
      @required TrackingDetails trackingDetails}) async {
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
  /* ------------------------------ NOTE State ----------------------------- */

  void clearStreams() {
    _streamSubscriptionUser?.cancel();
    _streamSubscriptionContainer?.cancel();
    _streamSubscriptionLocation?.cancel();
  }

  void clearAllStates() {
    _authUser = null;
    _streamContainer = [];
    _streamContainerInProgress = [];
    _streamContainerCompleted = [];
    _streamLocation = [];
  }
}
