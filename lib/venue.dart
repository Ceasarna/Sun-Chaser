import 'package:flutter/material.dart';
import 'package:flutter_applicationdemo/shadow_detector.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_applicationdemo/globals.dart' as globals;

import 'mysql.dart';

class Venue {
  int venueID;
  String venueName;
  String venueAddress;
  String venueStreetNo;
  late LatLng position;
  bool inShade = false;
  bool isShownOnMap = false;
  DateTime? lastUpdated;
  OutdoorSeatingArea? outdoorSeatingArea;

  Venue(this.venueID, this.venueName, this.venueAddress, this.venueStreetNo,
      this.position);

  factory Venue.fromJson(Map<String, dynamic> json, id) {
    var tempId = id;
    var tempName = json['name'];
    var tempAddress = json['address'];
    var tempStreetNo = json['streetNo'];
    var tempCoordinates = json['coordinates'];

    var splitArr = [];
    splitArr = tempCoordinates.toString().split(';');
    LatLng tempPosition = LatLng(double.parse(splitArr[1]), double.parse(splitArr[0]));


    if (tempName != null &&
        tempAddress != null &&
        tempStreetNo != null &&
        tempCoordinates != null) {
      return Venue(tempId, tempName, tempAddress, tempStreetNo, tempPosition);
    } else {
      return Venue(0, 'name', 'address', 'streetNo', const LatLng(0, 0));
    }
  }

  BitmapDescriptor drawIconColor() {
    if(outdoorSeatingArea != null){
      return outdoorSeatingArea!.getMarker();
    }
    if (lastUpdated == null || lastUpdated!.difference(DateTime.now()).inMinutes > 30) {
      ShadowDetector SD = ShadowDetector();
      SD.evaluateShadowsForOneVenue(this);
      lastUpdated = DateTime.now();
    }

    if (inShade) {
      return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure);
    } else {
      return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow);
    }
  }

  Widget getVenue(BuildContext context) {
    return Text(venueName);
  }

  Widget getAddress(BuildContext context) {
    return Text(venueAddress + ' ' + venueStreetNo);
  }

  Widget getCoordinates(BuildContext context) {
    return Text(position.toString());
  }

  LatLng getPositionAsLatLng(BuildContext context) {
    return position;
  }

  void assignSeatingArea(OutdoorSeatingArea outdoorSeatingArea){
    this.outdoorSeatingArea = outdoorSeatingArea;
  }

  Widget getIcon(BuildContext context) {
    if (venueName.toLowerCase().contains('estau')) {
      return const Icon(Icons.restaurant);
    } else if (venueName.toLowerCase().contains('kaf')) {
      return const Icon(Icons.local_cafe);
    } else if (venueName.toLowerCase().contains('pizz')) {
      return const Icon(Icons.local_pizza);
    } else {
      return const Icon(Icons.food_bank);
    }
  }

  @override
  String toString() {
    return 'ID: ' +
        venueID.toString() +
        ', ' +
        'name: ' +
        venueName +
        ', ' +
        'address: ' +
        venueAddress +
        ' ' +
        venueStreetNo +
        ', ' +
        'coordinates: ' +
        position.toString();
  }

  void likeVenue() {
    globals.LOGGED_IN_USER.likedVenuesList.add(this);
    var db = mysql();
    db.getConnection().then((conn) {
      String sql =
          "INSERT INTO maen0574.userFavorites (user_id, venue_id) VALUES (${globals.LOGGED_IN_USER.userID}, $venueID);";
      conn.query(sql);
    });
  }
  void unlikeVenue(){
    globals.LOGGED_IN_USER.likedVenuesList.remove(this);
    var db = mysql();
    db.getConnection().then((conn) {
      String sql =
          "DELETE FROM maen0574.userFavorites WHERE user_id = '${globals.LOGGED_IN_USER.userID}' and venue_id = $venueID;";
      conn.query(sql);
    });
  }
}

class OutdoorSeatingArea {
  double northPoint;
  double eastPoint;
  double westPoint;
  double southPoint;
  bool shadowIsCalculated = false;
  late int shadowPercent;


  OutdoorSeatingArea({
    required this.northPoint, required this.eastPoint, required this.westPoint, required this.southPoint
  });

  int calculateShadow(){
    if(!shadowIsCalculated){
      ShadowDetector SD = ShadowDetector();
      SD.evaluateShadowsForOneOutdoorSeatingArea(this);
      shadowIsCalculated = true;
    }
    return shadowPercent;
  }

  BitmapDescriptor getMarker() {
    calculateShadow();
    if(shadowPercent < 26){
      return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen);
    }else if(shadowPercent < 51){
      return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure);
    }else if(shadowPercent < 76){
      return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange);
    }
    return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed);
  }
}

enum VenueType { cafe, restaurant, bar }
