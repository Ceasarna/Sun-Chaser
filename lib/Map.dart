import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_applicationdemo/BottomNavPage.dart';
import 'package:flutter_applicationdemo/ListViewPage.dart';
import 'package:flutter_applicationdemo/WeatherData.dart';
import 'package:flutter_applicationdemo/WebScraper.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import 'login/User.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:http/http.dart' as http;
import 'package:http/retry.dart';
import 'package:intl/number_symbols.dart';
import 'package:location/location.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:flutter_applicationdemo/login/User.dart';
import 'SettingsPage.dart';
import 'WeatherData.dart';
import 'venuePage.dart';
import 'Venue.dart';
import 'globals.dart' as globals;

import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'globals.dart' as globals;

import 'HomePage.dart';
import 'SettingsPage.dart';
import 'Venue.dart';
import 'globals.dart' as globals;
import 'FeedbackPage.dart';
import 'login/CreateAccountPage.dart';
import 'login/signInPage.dart';

class Map extends StatefulWidget {
  @override
  State<Map> createState() => MapState();
}

const kGoogleApiKey = "AIzaSyAUmhd6Xxud8SwgDxJ4LlYlcntm01FGoSk";

final homeSacffoldKey = GlobalKey<ScaffoldState>();

class MapState extends State<Map> {
  bool _bottomSheetIsOpen = false;

/*  Future getMerkerData() async {
    var url = Uri.parse(
        'https://openstreetgs.stockholm.se/geoservice/api/b8e20fd7-5654-465e-8976-35b4de902b41/wfs?service=wfs&version=1.1.0&request=GetFeature&typeNames=od_gis:Markupplatelse&srsName=EPSG:4326&outputFormat=json');
    var response = await http.get(url);
    print('Response status: ${response.statusCode}');
    // print('Response body: ${response.body.toString()}');
    var jsonData = jsonDecode(response.body);
  }*/

  final Completer<GoogleMapController> _controller = Completer();
  bool? _barFilterValue = true;
  bool? _restaurantFilterValue = true;
  bool? _cafeFilterValue = true;
  dynamic _priceFilterValue = 3;
  LocationData? _currentPosition;

  final TextEditingController _searchController = TextEditingController();

  static const CameraPosition _stockholmCity = CameraPosition(
    target: LatLng(59.325027, 18.068516),
    zoom: 14.4746,
  );

  List<Marker> markersList = [];

  @override
  void initState() {
    initialize();
    //_getUserLocation();
    super.initState();
  }

  initialize() {
    List<Venue> allVenues = globals.VENUES;
    for (var venue in allVenues) {
      Marker marker = Marker(
        markerId: MarkerId(venue.venueID.toString()),
        position: venue.position,
        /*infoWindow: InfoWindow(
            title: venue.venueName,
            snippet: venue.venueAddress,
          ),*/
        // onTap: () => createBottomSheet(venue.venueName),
        onTap: () => createBottomDrawer(venue),
        icon: venue.drawIconColor(),
      );
      markersList.add(marker);
    }
  }

  void createBottomSheet(String venueName) async {
    var webScraper = WebScraper();
    await webScraper.getWebsiteData(venueName);
    Scaffold.of(context).showBottomSheet<void>(((context) {
      return Container(
        height: 420,
        color: Colors.white,
        child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                /*const Text('BottomSheet'),
                        ElevatedButton(
                          child: const Text('Close BottomSheet'),
                          onPressed: () {Navigator.pop(context);})*/
                Container(
                  child: Text(webScraper.openingHoursThisWeek.length.toString()),
                ),
              ],
            )),
      );
    }));
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
  final screens = [
    Map(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Sun chasers"),
        key: homeSacffoldKey,
        //leading: IconButton(icon: Icon(Icons.search), onPressed:() {},),
        /*actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
        ],*/
        /*title: TextFormField(
          controller: _searchController,
          textCapitalization: TextCapitalization.words,
          decoration: const InputDecoration(hintText: 'Find your place'),
          onChanged: (value) {
            print(value);
          },
        ),*/
        actions: <Widget>[createFilterMenuButton()],
        backgroundColor: const Color.fromARGB(255, 190, 146, 160),
      ),
      /*body: Stack(
        backgroundColor: const Color.fromARGB(255, 190, 146, 160),
      ),
      body: Stack(
      drawer : Drawer(
        child: Container(
          child: globals.LOGGED_IN_USER.userID == 0 ? buildDrawerSignedOut(context) : buildDrawerSignedIn(context),
        ),
      ),*/

      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            myLocationEnabled: true,
            initialCameraPosition: _stockholmCity,
            markers: markersList.map((e) => e).toSet(),
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
            onTap: (LatLng) {
              closeBottomSheetIfOpen();
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
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const SettingsPage()));
          },
          backgroundColor: Colors.purple,
          child: const Icon(Icons.filter_alt),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
    );
  }

  PopupMenuButton<dynamic> createFilterMenuButton() {
    return PopupMenuButton(
        icon: Icon(Icons.filter_list),
        iconSize: 40,
        itemBuilder: (context) => [
          const PopupMenuItem(
            child: Text(
              "Filters",
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            padding: EdgeInsets.only(left: 60),
          ),
          createCheckBoxes(),
          createPriceSlider(),
          PopupMenuItem(
              child: ButtonBar(
                alignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: null,
                    // TODO: Fixa så att kartan filtreras när man klickar på 'Apply Filters'
                    child: Text(
                      "Apply Filters",
                      style: TextStyle(color: Colors.black),
                    ),
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            globals.BUTTONCOLOR)),
                  ),
                ],
              ))
        ]);
  }

  // Creates the checkboxes for the filter menu
  PopupMenuItem<dynamic> createCheckBoxes() {
    return PopupMenuItem(
        child: Padding(
            padding: const EdgeInsets.all(8),
            child: Expanded(
              child: Column(
                children: [
                  Divider(
                    color: Colors.black,
                  ),
                  StatefulBuilder(
                      builder: (BuildContext context, StateSetter setState) {
                        return CheckboxListTile(
                            value: _barFilterValue,
                            onChanged: (bool? newValue) {
                              setState(() {
                                _barFilterValue = newValue;
                              });
                            },
                            title: const Icon(
                              Icons.sports_bar,
                              color: Colors.orange,
                            ));
                      }),
                  StatefulBuilder(
                      builder: (BuildContext context, StateSetter setState) {
                        return CheckboxListTile(
                          value: _restaurantFilterValue,
                          onChanged: (bool? newValue) {
                            setState(() {
                              _restaurantFilterValue = newValue;
                            });
                          },
                          title: Icon(
                            Icons.restaurant,
                            color: Colors.blueGrey[200],
                          ),
                        );
                      }),
                  //Cafe checkbox
                  StatefulBuilder(
                      builder: (BuildContext context, StateSetter setState) {
                        return CheckboxListTile(
                            value: _cafeFilterValue,
                            onChanged: (bool? newValue) {
                              setState(() => _cafeFilterValue = newValue);
                            },
                            title: Icon(
                              Icons.coffee,
                              color: Colors.brown[400],
                            ));
                      }),
                ],

                /*floatingActionButton: Padding(
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
                  floatingActionButtonLocation: FloatingActionButtonLocation
                      .endTop,*/
              ),
            )));
  }

  PopupMenuItem<dynamic> createPriceSlider() {
    return PopupMenuItem(
      child: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return SfSlider(
                value: _priceFilterValue,
                onChanged: (dynamic newValue) {
                  setState((() => _priceFilterValue = newValue));
                },
                min: 1,
                max: 3,
                showTicks: true,
                interval: 1,
                activeColor: Colors.blue,
                showLabels: true,
                stepSize: 1.0,
                labelFormatterCallback: (dynamic value, String formattedText) {
                  switch (value) {
                    case 1:
                      return '\$';
                    case 2:
                      return '\$\$';
                    case 3:
                      return '\$\$\$';
                  }
                  return value.toString();
                });
          }),
    );
  }

  Future<void> _gotoLocation(double lat, double lng) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(lat, lng), zoom: 15)));
  }

  Widget _boxes(double lat, double lng, String resturantName) {
    return GestureDetector(
      onTap: () {
        _gotoLocation(lat, lng);
      },
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
                      child:
                      const Image(image: AssetImage('assets/images/bild.png')),
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
          )),
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

  createBottomDrawer(Venue venue) async {
    // Position? position = await Geolocator.getLastKnownPosition();
    // double bar = Geolocator.bearingBetween(position != null? position.latitude : 0, position != null? position.longitude : 0, venue.position.latitude, venue.position.longitude);
    _bottomSheetIsOpen = true;
    Scaffold.of(context).showBottomSheet<void>(((context) {
      return InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => VenuePage(venue)),
          );
        },
        child: Container(
          height: 250,
          color: const Color(0xFFF5F5F5),
          child: Center(
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  margin: const EdgeInsets.all(8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    // mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      columnCoveringNameAndAddress(venue),
                      columnCoveringRating(),
                    ],
                  ),
                ),
                columnHandlingCloseButton(context),
                Container(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Text('Weather: \t\t'),
                          globals.forecast.getCurrentWeatherIcon(),
                        ],
                      ),
                      Row(
                        children: [
                          Text('– ' +
                              globals.forecast.getCurrentWeatherStatus()),
                        ],
                      ),
                      Row(
                        children: [
                          const Text('Distance:'),
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      );
    }));
  }

  Column columnHandlingCloseButton(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                  child: const Text('Close'),
                  onPressed: () {
                    Navigator.pop(context);
                    _bottomSheetIsOpen = false;
                  }),
              ElevatedButton(
                child: const Text('ListView'),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ListViewPage()));
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Column columnCoveringRating() {
    return Column(
      children: [
        Text(
          'Rating',
          style: GoogleFonts.robotoCondensed(
            textStyle: const TextStyle(
              color: Colors.black87,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Column columnCoveringNameAndAddress(Venue venue) {
    return Column(
      children: [
        Text(
          venue.venueName,
          style: GoogleFonts.roboto(
              textStyle: const TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              )),
        ),
        Text(
          venue.venueAddress + ' ' + venue.venueStreetNo,
          style: GoogleFonts.roboto(
              textStyle: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w300,
                fontSize: 18,
              )),
        )
      ],
    );
  }

  closeBottomSheetIfOpen() {
    print(_bottomSheetIsOpen);
    if (_bottomSheetIsOpen) {
      Navigator.pop(context);
    }
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

Widget buildDrawerSignedIn(BuildContext context) {
  return Drawer(
    child: ListView(
      padding: EdgeInsets.zero,
      children: [
        DrawerHeader(
          decoration:
          const BoxDecoration(color: Color.fromARGB(255, 190, 146, 160)),
          child: Column(
            children: const <Widget>[
              Text(
                'Sun Chaser',
                style: TextStyle(fontSize: 32),
              ),
              SizedBox(height: 30),
              Icon(Icons.account_box_rounded),
            ],
          ),
        ),
        ListTile(
          leading: Icon(Icons.logout),
          title: Text('Sign out'),
          onTap: () {
            globals.LOGGED_IN_USER = User(0, "", "");
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => BottomNavPage()), //Replace Container() with call to Map-page.
            );
          },
        ),
        ListTile(
          leading: Icon(Icons.thumb_up_alt),
          title: Text('Give feedback'),
          onTap: () {
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
          onTap: () {
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

Widget buildDrawerSignedOut(BuildContext context) {
  return Drawer(
    child: ListView(
      padding: EdgeInsets.zero,
      children: [
        DrawerHeader(
          decoration:
          const BoxDecoration(color: Color.fromARGB(255, 190, 146, 160)),
          child: Column(
            children: const <Widget>[
              Text(
                'Sun Chaser',
                style: TextStyle(fontSize: 32),
              ),
              SizedBox(height: 30),
            ],
          ),
        ),
        ListTile(
          leading: Icon(Icons.account_box_rounded),
          title: Text('Create account'),
          onTap: () {
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
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SignInPage(),
              ),
            );
          },
        ),
        ListTile(
          leading: Icon(Icons.thumb_up_alt),
          title: Text('Give feedback'),
          onTap: () {
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
          onTap: () {
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