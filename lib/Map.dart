import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_applicationdemo/Form.dart';
import 'package:flutter_applicationdemo/HomePage.dart';
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
//import 'package:google_maps_webservice/places.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';
import 'package:geolocator/geolocator.dart';
import 'FeedbackPage.dart';
import 'SettingsPage.dart';
import 'globals.dart' as globals;
import 'login/CreateAccountPage.dart';
import 'login/signInPage.dart';
import 'login/user.dart';


class Map extends StatefulWidget {
  @override
  State<Map> createState() => MapState();
}

const kGoogleApiKey = "AIzaSyAUmhd6Xxud8SwgDxJ4LlYlcntm01FGoSk";

final homeSacffoldKey = GlobalKey<ScaffoldState>();

List<_Marker> markers = [];


class MapState extends State<Map> {

  Future getMerkerData() async {
    var url = Uri.parse('https://openstreetgs.stockholm.se/geoservice/api/b8e20fd7-5654-465e-8976-35b4de902b41/wfs?service=wfs&version=1.1.0&request=GetFeature&typeNames=od_gis:Markupplatelse&srsName=EPSG:4326&outputFormat=json');
    var response = await http.get(url);

    print('Response status: ${response.statusCode}');
   // print('Response body: ${response.body.toString()}');
    var jsonData = jsonDecode(response.body);

   /* print(jsonData['features'][0]);

    print(jsonData['features'][1]['properties']['Plats_1']);

    print(jsonData['features'][0]['properties']['Gatunr_1']);

    print(jsonData['features'][0]['properties']['Kategorityp']);

    /*String data = jsonData['features'][0]['properties']['Kategorityp'];
    print(data.contains('Tillfälliga bostäder'));*/
    

    print(jsonData['features'][1]['geometry']['coordinates']);*/

    //print(jsonData['features'][0]['properties']['MAIN_ATTRIBUTE_VALUE']);
  
   // List<_Marker> markers = [];

    for(var m in jsonData['features']) {
      String data = m['properties']['Kategorityp'];
      String typ = m['properties']['MAIN_ATTRIBUTE_VALUE'];
      if(m['properties']['Kategorityp'] == "1.400I, Uteservering A-läge") {
        print(m['properties']['Kategorityp']);
        _Marker marker = _Marker(m['properties']['Plats_1'],m['properties']['Gatunr_1'],m['geometry']['coordinates']);
        markers.add(marker);
      }

      print(markers.length);
      
      int count = 0;
      for (var mar in markers) {
        print(mar.Plats_1);
        print(mar.Gatunr_1);
        print(mar.coordinates[1]);
        print(mar.coordinates[0]);
        count++;
        print(count);
        if (count == 100) {
          break;
        }
      }

      //print(m['properties']['Kategorityp']);
    } 
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
    Marker marker_1;
    //for(var marker in markers) {
      marker_1 = Marker(
        markerId: const MarkerId('id_1'),
        onTap: createBottomSheet,
        position: const LatLng(59.320671571444514, 18.055854162299937),
        infoWindow: const InfoWindow(
          title: 'Münchenbryggeriet Beer Garden',        
          snippet: 'Uteservering',
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueGreen,
        ),
        );

      Marker marker_2 = Marker(
        markerId: const MarkerId('id_2'),
        onTap: createBottomSheet,
        position: const LatLng(59.33115735285231, 18.074432570090742),
        infoWindow: const InfoWindow(
          title: 'Le Hibou',
          snippet: 'Uteservering',
        )
        );

      Marker marker_3 = Marker(
        markerId: const MarkerId('id_3'),
        onTap: createBottomSheet,
        position: const LatLng(59.3315552932853, 18.092751076985277),
        infoWindow: const InfoWindow(
          title: 'Strandbryggan',
          snippet: 'Uteservering',
        )
        );

      Marker marker_4 = Marker(
        markerId: const MarkerId('id_4'),
        onTap: createBottomSheet,
        position: const LatLng(59.33632582609118, 18.072980646196587),
        infoWindow: const InfoWindow(
          title: 'Stureplan 1',
          snippet: 'Uteservering',
        )
        );

      Marker marker_5 = Marker(
        markerId: const MarkerId('id_5'),
        onTap: createBottomSheet,
        position: const LatLng(59.3240158318325, 18.070690101341437),
        infoWindow: const InfoWindow(
          title: 'Bågspännaren Bar & Cafe',
          snippet: 'Uteservering',
        )
        );

      Marker marker_6 = Marker(
        markerId: const MarkerId('id_6'),
        onTap: createBottomSheet,
        position: const LatLng(59.31905195030728, 18.075349015415547),
        infoWindow: const InfoWindow(
          title: 'Mosebacketerrassen',
          snippet: 'Uteservering',
        )
        );

      Marker marker_7 = Marker(
        markerId: const MarkerId('id_7'),
        onTap: createBottomSheet,
        position: const LatLng(59.31583756143469, 18.072591381467536),
        infoWindow: const InfoWindow(
          title: 'Snaps Bar & Bistro',
          snippet: 'Uteservering',
        )
        );
      
      Marker marker_8 = Marker(
        markerId: const MarkerId('id_8'),
        onTap: createBottomSheet,
        position: const LatLng(59.315129508641505, 18.074243159987006),
        infoWindow: const InfoWindow(
          title: 'Kvarnen',
          snippet: 'Uteservering',
        )
        );
      
      Marker marker_9 = Marker(
        markerId: const MarkerId('id_9'),
        onTap: createBottomSheet,
        position: const LatLng(59.31533181094423, 18.070972638518455),
        infoWindow: const InfoWindow(
          title: 'Neverland Pub & Restaurang',
          snippet: 'Uteservering',
        )
        );

      Marker marker_10 = Marker(
        markerId: const MarkerId('id_10'),
        onTap: createBottomSheet,
        position: const LatLng(59.31578389646754, 18.071146819010995),
        infoWindow: const InfoWindow(
          title: 'Baras Imperium',
          snippet: 'Uteservering',
        )
        );

      Marker marker_11 = Marker(
        markerId: const MarkerId('id_11'),
        onTap: createBottomSheet,
        position: const LatLng(59.31549103673382, 18.035425964557245),
        infoWindow: const InfoWindow(
          title: 'YUC Tanto',
          snippet: 'Uteservering',
        )
        );

      Marker marker_12 = Marker(
        markerId: const MarkerId('id_12'),
        onTap: createBottomSheet,
        position: const LatLng(59.314826329005506, 18.03317611771755),
        infoWindow: const InfoWindow(
          title: 'Loopen',
          snippet: 'Uteservering',
        )
        );
    
      markersList.add(marker_1);
      markersList.add(marker_2);
      markersList.add(marker_3);
      markersList.add(marker_4);
      markersList.add(marker_5);
      markersList.add(marker_6);
      markersList.add(marker_7);
      markersList.add(marker_8);
      markersList.add(marker_9);
      markersList.add(marker_10);
      markersList.add(marker_11);
      markersList.add(marker_12);
   // }
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
        centerTitle: true,
        title: const Text("Sun chasers"),
        key: homeSacffoldKey,
        backgroundColor: const Color.fromARGB(255, 190, 146, 160),
      ),
      drawer : Drawer(
        child: Container(
          child: globals.LOGGED_IN_USER.userID == 0 ? buildDrawerSignedOut(context) : buildDrawerSignedIn(context),
        ),
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
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 20.0),
              height: 250.0,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: <Widget>[
                  SizedBox(width: 10.0),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: _boxes(59.320671571444514 , 18.055854162299937, 'Münchenbryggeriet Beer Garden') ,
                    ),
                  SizedBox(width: 10.0),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: _boxes(59.33115735285231, 18.074432570090742, 'Le Hibou') ,
                    ),
                  SizedBox(width: 10.0),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: _boxes(59.3315552932853, 18.092751076985277, 'Strandbryggan') ,
                    ),
                  SizedBox(width: 10.0),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: _boxes(59.33632582609118, 18.072980646196587, 'Stureplan 1') ,
                    ),
                  SizedBox(width: 10.0),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: _boxes(59.3240158318325, 18.070690101341437, 'Bågspännaren Bar & Cafe') ,
                    ),
                ],
              ),
            ),
          )
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
            backgroundColor: Colors.blueAccent,
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
        bearing: 192.8334901395799,
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

Widget buildDrawerSignedIn(BuildContext context){
  return Drawer(
    child: ListView(
      padding: EdgeInsets.zero,
      children: [
        DrawerHeader(
          decoration: const BoxDecoration(color: Color.fromARGB(255, 190, 146, 160)),
          child: Column(children: const <Widget>[
            Text('Sun Chaser',
              style :TextStyle(fontSize: 32),
            ),

            SizedBox(height: 30),
            Icon(Icons.account_box_rounded),

          ],

          ),

        ),

        ListTile(
          leading: Icon(Icons.logout),
          title: Text('Sign out'),
          onTap:(){
            globals.LOGGED_IN_USER = user(0, "", "");
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomePage()), //Replace Container() with call to Map-page.
            );
          },
        ),
        ListTile(
          leading: Icon(Icons.thumb_up_alt),
          title: Text('Give feedback'),
          onTap:(){
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FormForFeedback(),
              ),
            );
          },

        ),
        ListTile(
          leading: Icon(Icons.settings),
          title: Text('Settings'),
          onTap:(){
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SettingsPage(),
              ),
            );
          },
        ),

      ],
    ),
  );
}

Widget buildDrawerSignedOut(BuildContext context){
  return Drawer(
    child: ListView(
      padding: EdgeInsets.zero,
      children: [
        DrawerHeader(
          decoration: const BoxDecoration(color: Color.fromARGB(255, 190, 146, 160)),
          child: Column(children: const <Widget>[
            Text('Sun Chaser',
              style :TextStyle(fontSize: 32),
            ),

            SizedBox(height: 30),
          ],
          ),
        ),

        ListTile(
          leading: Icon(Icons.account_box_rounded),
          title: Text('Create account'),
          onTap:(){
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CreateAccountPage(),
              ),
            );
          },
  ),
        ListTile(
          leading: Icon(Icons.login),
          title: Text('Sign in'),
          onTap:(){
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SignInPage(),
              ),
            );
          },),
        ListTile(
          leading: Icon(Icons.thumb_up_alt),
          title: Text('Give feedback'),
          onTap:(){
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FormForFeedback(),
              ),
            );
          },
        ),
        ListTile(
          leading: Icon(Icons.settings),
          title: Text('Settings'),
          onTap:(){
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SettingsPage(),
              ),
            );
          },
        ),
      ],
    ),
  );
}


class _Marker {

  var Plats_1;
  var Gatunr_1;
  var coordinates;

  _Marker(this.Plats_1, this.Gatunr_1, this.coordinates);

}