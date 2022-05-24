import 'dart:convert';

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';
import 'package:geolocator/geolocator.dart';

import 'package:flutter_applicationdemo/login/User.dart';
import 'Venue.dart';
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
    intilize();
    _getUserLocation();
    super.initState();
  }

  void createBottomSheet() {
    Scaffold.of(context).showBottomSheet<void>(
              ((context) {
                return Container(
                  height: 420,
                  color: Colors.white,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: const <Widget>[
                        /*const Text('BottomSheet'),
                        ElevatedButton(
                          child: const Text('Close BottomSheet'),
                          onPressed: () {Navigator.pop(context);})*/
                        Image(image: AssetImage('assets/images/bild.png'))

                      ],
                    )
                    ),
                );
              })
            );
  }

  intilize() {
    List<Venue> venues = globals.VENUES;

    for(Venue venue in venues){
      Marker marker = Marker(
          markerId: MarkerId(venue.toString()),
        onTap: createBottomSheet,
        position: venue.position,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
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

  //final Mode _mode = Mode.fullscreen;

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
            //print(value);
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
      )
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

}
