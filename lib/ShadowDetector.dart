
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart';
import 'dart:async';
import 'globals.dart' as globals;
import 'Venue.dart';

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
        //print(response);
        //print(responseAsString);
        //print(responseAsString[responseAsString.length - 2]);
        if(responseAsString[responseAsString.length - 2] == 1) {
          venue.inShade = true;
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
    //print(response);
    //print(responseAsString);
    //print(responseAsString[responseAsString.length - 2]);
    if(responseAsString[responseAsString.length - 2] == 1) {
      venue.inShade = true;
    }
    else {
      venue.inShade = false;
    }
  }
}