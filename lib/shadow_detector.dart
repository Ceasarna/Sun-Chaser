
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart';
import 'dart:async';
import 'venue.dart';

class ShadowDetector {

  List<Venue> venuesInShade = [];

  ShadowDetector() {

  }
  //Called like "new ShadowDetector.fromShadowDetector(List of venues here);"
  ShadowDetector.fromShadowDetector(venues) {
    evaluateShadowsForAllVenues(venues);
  }

  Future evaluateShadowsForAllVenues (List<Venue> venues) async {
    final dateInMilliseconds = DateTime.now().millisecondsSinceEpoch.toString() + 't';
    for(var venue in venues) {
        LatLng pos = venue.position;
        final lat = pos.latitude.toString();
        final lng = pos.longitude.toString();
        final response = await get(Uri.parse('https://node.sacalerts.com/og-image/loc@$lat,$lng,14.82137z,$dateInMilliseconds'));
        var responseAsString = response.body.toString();
        if(responseAsString[responseAsString.length - 2] == 1) {
          venue.inShade = true;
        }else{
          venue.inShade = false;
        }
        venuesInShade.add(venue);
    }
  }

  List<Venue> get listWithVenuesInShade => venuesInShade; //Get all venues with their shadow status updated.

  Future evaluateShadowsForOneVenue (Venue venue) async {
    LatLng pos= venue.position;
    final lat = pos.latitude.toString();
    final lng = pos.longitude.toString();
    final dateInMilliseconds = DateTime.now().millisecondsSinceEpoch.toString() + 't';
    final response = await get(Uri.parse('https://node.sacalerts.com/og-image/loc@$lat,$lng,14.82137z,$dateInMilliseconds'));
    var responseAsString = response.body.toString();
    if(responseAsString[responseAsString.length - 2] == 1) {
      venue.inShade = true;
    }
    else {
      venue.inShade = false;
    }
  }

  Future evaluateShadowsForOneOutdoorSeatingArea (OutdoorSeatingArea osa) async {
    final nw = osa.northPoint.toString() + "," + osa.westPoint.toString();
    final sw = osa.southPoint.toString() + "," + osa.westPoint.toString();
    final se = osa.southPoint.toString() + "," + osa.eastPoint.toString();
    final ne = osa.northPoint.toString() + "," + osa.eastPoint.toString();
    List<String> points = [nw, sw, se, ne];
    osa.shadowPercent = 0;

    final dateInMilliseconds = DateTime.now().millisecondsSinceEpoch.toString() + 't';
    for(var point in points){
      final response = await get(Uri.parse('https://node.sacalerts.com/og-image/loc@$point,14.82137z,$dateInMilliseconds'));
      var responseAsString = response.body.toString();
      if(responseAsString[responseAsString.length - 2] == 1) {
        osa.shadowPercent += 25;
      }
    }



  }
}