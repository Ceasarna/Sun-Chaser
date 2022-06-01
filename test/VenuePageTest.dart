import 'package:flutter_applicationdemo/Venue.dart';
import 'package:flutter_applicationdemo/WeatherData.dart';
import 'package:flutter_applicationdemo/venuePage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:test/test.dart';



void main() {
  test('Venue Page Has Access to Venue Instance', () {
    Venue venue = Venue(00, 'Aira', 'Biskopsudden', '9', const LatLng(59.354823, 19.29485));
    VenuePage venuePage = VenuePage(venue);

    expect('Aira', venuePage.venue.venueName);
    expect('Biskopsudden', venuePage.venue.venueAddress);
    expect('9', venuePage.venue.venueStreetNo);

  });
}