
import 'dart:math';

import 'package:flutter_applicationdemo/ListViewPage.dart';
import 'package:flutter_applicationdemo/Venue.dart';
import 'package:flutter_applicationdemo/globals.dart' as globals;
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:test/test.dart';

void main() {
  test('Test ListViewPage can access venues', () {
    // ListViewPage listViewPage = const ListViewPage();
    ListViewPageState listViewPage = ListViewPageState();
    globals.VENUES.add(Venue(00, 'Aira', 'Biskopsudden', '9', const LatLng(59.354823, 19.29485)));

    expect(globals.VENUES.first, listViewPage.allVenues.first);
  });
}