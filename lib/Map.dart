import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_applicationdemo/WebScraper.dart';
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';
import 'package:geolocator/geolocator.dart';

import 'package:flutter_applicationdemo/login/User.dart';
import 'SettingsPage.dart';
import 'Venue.dart';
import 'globals.dart' as globals;


import 'globals.dart' as globals;


class Map extends StatefulWidget {
  @override
  State<Map> createState() => MapState();
}

const kGoogleApiKey = "AIzaSyAUmhd6Xxud8SwgDxJ4LlYlcntm01FGoSk";

final homeSacffoldKey = GlobalKey<ScaffoldState>();


class MapState extends State<Map> {

  Future getMerkerData() async {
    var url = Uri.parse('https://openstreetgs.stockholm.se/geoservice/api/b8e20fd7-5654-465e-8976-35b4de902b41/wfs?service=wfs&version=1.1.0&request=GetFeature&typeNames=od_gis:Markupplatelse&srsName=EPSG:4326&outputFormat=json');
    var response = await http.get(url);

    print('Response status: ${response.statusCode}');
   // print('Response body: ${response.body.toString()}');
    var jsonData = jsonDecode(response.body);



  }

  final Completer<GoogleMapController> _controller = Completer();

  LocationData? _currentPosition;

  final TextEditingController _searchController =  TextEditingController();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(59.325027,18.068516),
    zoom: 14.4746,
  );

  List<Marker> markersList = [];

  @override
  void initState() {
    initialize();
    //_getUserLocation();
    super.initState();
  }

  void createBottomSheet(String venueName) async {
    var webScraper = WebScraper();
    await webScraper.getWebsiteData(venueName);
    Scaffold.of(context).showBottomSheet<void>(
              ((context) {
                return Container(
                  height: 420,
                  color: Colors.white,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children:  <Widget>[
                        /*const Text('BottomSheet'),
                        ElevatedButton(
                          child: const Text('Close BottomSheet'),
                          onPressed: () {Navigator.pop(context);})*/
                        Container(
                          child: Text(webScraper.openingHoursThisWeek.length.toString()),
                        ),

                      ],
                    )
                    ),
                );
              })
            );
  }

  initialize() {
    List<Venue> allVenues = globals.VENUES;
    for(var venue in allVenues) {
      Marker marker = Marker(
          markerId: MarkerId(venue.venueID.toString()),
          position: venue.position,
          onTap: () => createBottomSheet(venue.venueName),
          icon: venue.drawIconColor(),
          );
      markersList.add(marker);
    }
  }


  Future<LocationData> _getLocationPermission() async {
    Location location = Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return Future.error('Service not enable');
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return Future.error('Permission Denied');
      }
    }

    _locationData = await location.getLocation();

    return _locationData;
  }

  _getUserLocation() async {
    _currentPosition = await _getLocationPermission();
    _goToCurrentPosition(
        LatLng(_currentPosition!.latitude!, _currentPosition!.longitude!));
  }

  late GoogleMapController googleMapController;

  final Mode _mode = Mode.fullscreen;

  int currentIndex = 0;
  final screens =[
    Map(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        key: homeSacffoldKey,
        //leading: IconButton(icon: Icon(Icons.search), onPressed:() {},),
        actions: <Widget>[
          IconButton(icon: const Icon(Icons.search), onPressed:() {
          },),
        ],
        title: TextFormField(
          controller: _searchController,
          textCapitalization: TextCapitalization.words,
          decoration: const InputDecoration(hintText: 'Find your place'),
          onChanged: (value) {
            print(value);
          },
        ),
        backgroundColor: const Color.fromARGB(255, 190, 146, 160),
      ),
      body: Stack (
        children: [
          GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: _kGooglePlex,
            markers: markersList.map((e) => e).toSet(),
            onMapCreated: (GoogleMapController controller) {
           _controller.complete(controller);
           },
          ),
         // ElevatedButton(onPressed: () {} //_handelPressButton
        //  ,child: const Text("Search Placses"))
        ],
      ),

        floatingActionButton: Padding(
          padding: const EdgeInsets.only(top: 100.0),
          child: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                builder: (context) => const SettingsPage()));
          },
            backgroundColor: Colors.purple,
            child: const Icon(Icons.filter_alt),
            ),
          ),
            floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
            );
          }


  Future<void> _gotoLocation(double lat, double lng) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(lat,lng), zoom: 15)));
  }

  Widget _boxes(double lat, double lng, String resturantName) {
    return GestureDetector(
      onTap: () { _gotoLocation(lat, lng);},
      child: Container(
        child: FittedBox(
          child: Material(
            color: Colors.white,
            elevation: 14.0,
            borderRadius: BorderRadius.circular(24.0),
            shadowColor: Color(0x802196F3),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  width: 250,
                  height: 200,
                  child: ClipRRect(
                    borderRadius: new BorderRadius.circular(24.0),
                    child: const Image(
                      image: AssetImage('assets/images/bild.png')
                    ),
                    ),
                ),
                Container(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(resturantName),
                    ),
                )
              ],
              ),
            ),
        )
        ),
    );
  }

  Future<void> _goToCurrentPosition(LatLng latlng) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        bearing: 0,
        target: LatLng(latlng.latitude, latlng.longitude),
        //tilt: 59.440717697143555,
        zoom: 14.4746)));
  }

 /* Future<void> _handelPressButton() async {

    Prediction? p = await PlacesAutocomplete.show(
                          context: context,
                          apiKey: kGoogleApiKey,
                          mode: _mode, // Mode.fullscreen
                          language: "en",
                          strictbounds: false,
                          decoration: InputDecoration(
                            hintText:'serach',
                            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide(color: Colors.white))
                          ),
                          types: [""],
                          components: [Component(Component.country, "se")]);
    if (p != null) {
      displayPrediction(p,homeSacffoldKey.currentState);
    }

  }

  Future<void> displayPrediction(Prediction p, ScaffoldState? currentState) async {
    GoogleMapsPlaces places = GoogleMapsPlaces(
      apiKey: kGoogleApiKey,
      apiHeaders: await const GoogleApiHeaders().getHeaders()
    );

    PlacesDetailsResponse detail = await places.getDetailsByPlaceId(p.placeId!);

    final lat = detail.result.geometry!.location.lat;
    final lng = detail.result.geometry!.location.lng;

    markersList.clear();
    markersList.add(Marker(markerId: const MarkerId("0"), position: LatLng(lat, lng), infoWindow: InfoWindow(title: detail.result.name)));

    setState(() {});

    googleMapController.animateCamera(CameraUpdate.newLatLngZoom(LatLng(lat,lng), 14.0));
  }*/
}

