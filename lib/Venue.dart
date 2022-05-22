import 'package:google_maps_flutter/google_maps_flutter.dart';

class Venue {
  late String venueName;
  late int venueID;
  late VenueType typeOfVenue;
  late LatLng position;
  late InfoWindow infoWindow;
  bool inShade = false;


  Venue(this.venueName,
      this.venueID, this.typeOfVenue, this.position);
}

enum VenueType{
  cafe, restaurant, bar
}