import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Venue {
  int venueID;
  String venueName;
  String venueAddress;
  String venueStreetNo;
  late LatLng position;
  bool inShade = false;

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


    print(splitArr[0].toString() + ' : ' + splitArr[1].toString());
    print('Coordinates: ' + tempCoordinates);
    print('Parsed: ' + double.parse(splitArr[0]).toString());
    print(LatLng(double.parse(splitArr[1]), double.parse(splitArr[0])));
    print(tempAddress + tempName);
    print(tempPosition.latitude.toString() + " " + splitArr[0]);

    // print('Json-Object:');
    // print(json);

    // print(venues);
    // print(json['name']);
    // print(json['address']);
    // print(json['streetNo']);
    // print(json['coordinates']);

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
        ' ' +
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
}

enum VenueType { cafe, restaurant, bar }
