import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_applicationdemo/BottomNavPage.dart';
import 'package:flutter_applicationdemo/ListViewPage.dart';
import 'package:flutter_applicationdemo/WeatherData.dart';
import 'package:flutter_applicationdemo/WebScraper.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_applicationdemo/HomePage.dart';
import 'dart:async';
import 'login/User.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:http/http.dart' as http;
import 'package:http/retry.dart';
import 'package:intl/number_symbols.dart';
import 'package:location/location.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:flutter_applicationdemo/login/User.dart';
import 'SettingsPage.dart';
import 'venuePage.dart';
import 'Venue.dart';
import 'globals.dart' as globals;

import 'package:syncfusion_flutter_sliders/sliders.dart';

import 'HomePage.dart';
import 'FeedbackPage.dart';
import 'login/CreateAccountPage.dart';
import 'login/signInPage.dart';

class Map extends StatefulWidget {
  @override
  State<Map> createState() => MapState();
}

const kGoogleApiKey = "AIzaSyAUmhd6Xxud8SwgDxJ4LlYlcntm01FGoSk";

final homeSacffoldKey = GlobalKey<ScaffoldState>();

late CameraPosition _currentCameraPosition;

class MapState extends State<Map> {
  bool _bottomSheetIsOpen = false;

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
  List<Marker> closeByMarkersList = [];
  List<Venue> hiddenVenues = [];
  List<Venue> closeByVenues = [];

  @override
  void initState() {
    initialize();
    _getUserLocation();
    super.initState();
  }

  initialize() {
    hiddenVenues.addAll(globals.VENUES);
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
  @override
  Widget build(BuildContext context) {
    _currentCameraPosition = _stockholmCity;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Sun chasers"),
        key: homeSacffoldKey,
        actions: <Widget>[createFilterMenuButton()],
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
            cameraTargetBounds: CameraTargetBounds(LatLngBounds(
                northeast: const LatLng(59.3474696569038, 18.1001602476002147),
                southwest: const LatLng(59.297332547922636, 17.999522500277884))),
            minMaxZoomPreference: MinMaxZoomPreference(12.5, 18.5),
            onCameraMove: (CameraPosition camera){
              _currentCameraPosition = camera;
            },
            onCameraIdle: (){
              (context as Element).reassemble();
              removeMarkersOutOfRange();
              addMarkersInRange();
            },
            mapType: MapType.normal,
            myLocationEnabled: true,
            initialCameraPosition: _stockholmCity,
            compassEnabled: true,
            onMapCreated: (GoogleMapController controller) {
              setAllMarkersAsInvisible();
              addMarkersInRange();
              _controller.complete(controller);
            },
            markers: closeByMarkersList.map((e) => e).toSet(),
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

  final screens = [
    Map(),
  ];

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
        CameraPosition(target: LatLng(lat, lng), zoom: 14.5)));
  }

  Widget _boxes(double lat, double lng, String restaurantName) {
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
                  child: Text(restaurantName),
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
        zoom: 15.4746)));
  }

  void removeMarkersOutOfRange() {
    for(int i = 0; i<closeByMarkersList.length; i++){
      Marker marker = closeByMarkersList[i];
      globals.venueAlreadyAdded(globals.getVenueByID(int.parse(marker.markerId.value))!.venueName);
      if(marker.position.longitude - _currentCameraPosition.target.longitude > 0.02 || marker.position.latitude - _currentCameraPosition.target.latitude > 0.02){
        closeByMarkersList.remove(marker);
        globals.getVenueByID(int.parse(marker.markerId.value))?.isShownOnMap = false;
        i--;
      }
    }
  }

  void addMarkersInRange() {
    for(int i = 0; i< globals.VENUES.length; i++){
      if(!globals.VENUES[i].isShownOnMap && (globals.VENUES[i].position.longitude - _currentCameraPosition.target.longitude < 0.02 && globals.VENUES[i].position.latitude - _currentCameraPosition.target.latitude < 0.02)){
        Marker marker = Marker(
            markerId: MarkerId(globals.VENUES[i].venueID.toString()),
            position: globals.VENUES[i].position,
            onTap: () => createBottomDrawer(globals.VENUES[i]),
            icon: globals.VENUES[i].drawIconColor()
        );
        globals.VENUES[i].isShownOnMap = true;
        closeByMarkersList.add(marker);
      }
    }
  }

  createBottomDrawer(Venue venue) async {
    _bottomSheetIsOpen = true;
    // Scaffold.of(context).showBottomSheet<void>(((context) {
    showModalBottomSheet(context: context, builder: (BuildContext context) {
      return InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => VenuePage(venue)),
          );
        },
        child: Container(
          height: 175,
          color: const Color(0xFFF5F5F5),
          child: Center(
            child: Column(
              children: [
                bottomSheetWidgetContainer(venue, context),
              ],
            ),
          ),
        ),
      );
    });
  }

  Container bottomSheetWidgetContainer(Venue venue, BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        // mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  columnCoveringNameAndAddress(venue),
                ],
              ),
              // columnCoveringRating(),

            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: const [
                  weatherIconRow(),
                  weatherStatusRow(),
                ],
              ),
              columnHandlingReadMoreButton(context, venue),
            ],
          )
        ],
      ),
    );
  }

  Column columnHandlingReadMoreButton(BuildContext context, Venue venue) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              readMoreButton(context, venue),
            ],
          ),
        ),
      ],
    );
  }

  ElevatedButton readMoreButton(BuildContext context, Venue venue) {
    return ElevatedButton(
      child: const Text(
        'Read More',
        style: TextStyle(fontSize: 16),
      ),
      onPressed: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => VenuePage(venue)));
        _bottomSheetIsOpen = false;
      },
      style: ElevatedButton.styleFrom(
        primary: globals.BUTTONCOLOR,
      ),
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
            fontSize: 20,
          )),
        ),
        Text(
          venue.venueAddress + ' ' + venue.venueStreetNo,
          style: GoogleFonts.roboto(
              textStyle: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w300,
            fontSize: 14,
          )),
        )
      ],
    );
  }

  closeBottomSheetIfOpen() {
    if (_bottomSheetIsOpen) {
      Navigator.pop(context);
      _bottomSheetIsOpen = false;
    }
  }

  void setAllMarkersAsInvisible() {
    for(Venue venue in hiddenVenues){
      venue.isShownOnMap = false;
    }
  }
/*
 Future<void> _handelPressButton() async {
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

class weatherIconRow extends StatelessWidget {
  const weatherIconRow({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text(
          'Weather: \t\t',
          style: TextStyle(fontSize: 18),
        ),
        globals.forecast.getCurrentWeatherIcon(),
      ],
    );
  }
}

class weatherStatusRow extends StatelessWidget {
  const weatherStatusRow({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          '– ' + globals.forecast.getCurrentWeatherStatus(),
          style: const TextStyle(
            fontSize: 16,
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }
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
