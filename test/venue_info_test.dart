import 'package:flutter_applicationdemo/venue.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_applicationdemo/venue_info.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

main() {
  group('On successful connection', () {
    late VenueInfo venueInfo;
    test('Call async function', ()  async {
      Venue testVenue = Venue(1, 'mälarpaviljongen', 'bla', 'bla', LatLng(59.327942, 18.034170));
      VenueInfo vi = VenueInfo();
      venueInfo = vi;
      await venueInfo.getVenueInfo(testVenue);
    });
    test('_priceClass is not null', () {
      expect(venueInfo.getPriceClass(), isNotNull);
    });
    test('_rating is not null', () {
      expect(venueInfo.getRating(), isNotNull);
    });
    test('_totalRatings is not null', () {
      expect(venueInfo.getTotalRatings(), isNotNull);
    });
    test('_openHoursToday is not null', () {
      expect(venueInfo.getOpeningHours(), isNotNull);
    });
    test('_popularity is not null', () {
      expect(venueInfo.getPopularity(), isNotNull);
    });
    test('_photo is not null', () {
      expect(venueInfo.getPhotoURL(), isNotNull);
    });
    test('_openNow is not null', () {
      expect(venueInfo.getOpenStatus(), isNotNull);
    });
  });

  group('On unsuccessful connection', () {
    late VenueInfo venueInfo;
    test('Call constructor', ()  async {
      Venue testVenue = Venue(1, '', 'bla', 'bla', LatLng(0, 0));
      VenueInfo vi = VenueInfo();
      venueInfo = vi;
      await venueInfo.getVenueInfo(testVenue);
    });
    test('_priceClass is default', () {
      expect(venueInfo.getPriceClass(), 'N/A');
    });
    test('_rating is default', () {
      expect(venueInfo.getRating(), 'N/A');
    });
    test('_totalRatings is default', () {
      expect(venueInfo.getTotalRatings(), 'N/A');
    });
    test('_openHoursToday is default', () {
      expect(venueInfo.getOpeningHours(), 'N/A');
    });
    test('_popularity is default', () {
      expect(venueInfo.getPopularity(), 'N/A');
    });
    test('_photo is default', () {
      expect(venueInfo.getPhotoURL(),  'https://www.bing.com/th?id=OIP.ZSXrQuieNC-hoPC4kIv_vgAAAA&w=212&h=212&c=8&rs=1&qlt=90&o=6&dpr=1.35&pid=3.1&rm=2');
    });
    test('_openNow is default', () {
      expect(venueInfo.getOpenStatus(), 'Closed');
    });
  });
}