import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:location/location.dart';
import 'venue_page.dart';
import 'venue.dart';
import 'login/user.dart';
import 'globals.dart' as globals;
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:flutter_applicationdemo/manage_account_page.dart';
import 'feedback_page.dart';
import 'login/create_account_page.dart';
import 'login/sign_in_page.dart';

class Map extends StatefulWidget {
  @override
  State<Map> createState() => MapState();
}

const kGoogleApiKey = "AIzaSyAUmhd6Xxud8SwgDxJ4LlYlcntm01FGoSk";

final homeScaffoldKey = GlobalKey<ScaffoldState>();

late CameraPosition _currentCameraPosition;

class MapState extends State<Map> {
  // bool _bottomSheetIsOpen = false;

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
        key: homeScaffoldKey,
        actions: <Widget>[createFilterMenuButton()],
        backgroundColor: const Color.fromARGB(255, 190, 146, 160),
      ),
      drawer: Drawer(
        child: Container(
          child: globals.LOGGED_IN_USER.userID == 0
              ? buildDrawerSignedOut(context)
              : buildDrawerSignedIn(context),
        ),
      ),
      body: Stack(
        children: [
          GoogleMap(
            cameraTargetBounds: CameraTargetBounds(LatLngBounds(
                northeast: const LatLng(59.3474696569038, 18.1001602476002147),
                southwest:
                    const LatLng(59.297332547922636, 17.999522500277884))),
            minMaxZoomPreference: MinMaxZoomPreference(12.5, 18.5),
            onCameraMove: (CameraPosition camera) {
              _currentCameraPosition = camera;
            },
            onCameraIdle: () {
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
              // closeBottomSheetIfOpen();
            },
          ),
        ],
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

  Future<void> _goToCurrentPosition(LatLng latlng) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        bearing: 0,
        target: LatLng(latlng.latitude, latlng.longitude),
        //tilt: 59.440717697143555,
        zoom: 15.4746)));
  }

  void removeMarkersOutOfRange() {
    for (int i = 0; i < closeByMarkersList.length; i++) {
      Marker marker = closeByMarkersList[i];
      globals.venueAlreadyAdded(
          globals.getVenueByID(int.parse(marker.markerId.value))!.venueName);
      if (marker.position.longitude - _currentCameraPosition.target.longitude >
              0.02 ||
          marker.position.latitude - _currentCameraPosition.target.latitude >
              0.02) {
        closeByMarkersList.remove(marker);
        globals.getVenueByID(int.parse(marker.markerId.value))?.isShownOnMap =
            false;
        i--;
      }
    }
  }

  void addMarkersInRange() {
    for (int i = 0; i < globals.VENUES.length; i++) {
      if (!globals.VENUES[i].isShownOnMap &&
          (globals.VENUES[i].position.longitude -
                      _currentCameraPosition.target.longitude <
                  0.02 &&
              globals.VENUES[i].position.latitude -
                      _currentCameraPosition.target.latitude <
                  0.02)) {
        Marker marker = Marker(
            markerId: MarkerId(globals.VENUES[i].venueID.toString()),
            position: globals.VENUES[i].position,
            onTap: () => createBottomSheet(globals.VENUES[i]),
            icon: globals.VENUES[i].drawIconColor());
        globals.VENUES[i].isShownOnMap = true;
        closeByMarkersList.add(marker);
      }
    }
  }

  createBottomSheet(Venue venue) async {
    // Scaffold.of(context).showBottomSheet<void>(((context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
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
                  WeatherIconRow(),
                  WeatherStatusRow(),
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

/*  closeBottomSheetIfOpen() {
    if (_bottomSheetIsOpen) {
      Navigator.pop(context);
      _bottomSheetIsOpen = false;
    }
  }*/

  void setAllMarkersAsInvisible() {
    for (Venue venue in hiddenVenues) {
      venue.isShownOnMap = false;
    }
  }
}

class WeatherIconRow extends StatelessWidget {
  const WeatherIconRow({
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

class WeatherStatusRow extends StatelessWidget {
  const WeatherStatusRow({
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
        giveFeedbackTile(context),
        settingsTile(context),
        signOutTile(context),
      ],
    ),
  );
}

Widget buildDrawerSignedOut(BuildContext context) {
  return Drawer(
    child: ListView(
      padding: EdgeInsets.zero,
      children: [
        drawerHeader(),
        createAccountTile(context),
        logInTile(context),
        giveFeedbackTile(context),
      ],
    ),
  );
}

DrawerHeader drawerHeader() {
  return DrawerHeader(
    decoration: const BoxDecoration(color: Color.fromARGB(255, 190, 146, 160)),
    child: Column(
      children: const <Widget>[
        Text(
          'Sun Chaser',
          style: TextStyle(fontSize: 32),
        ),
        SizedBox(height: 30),
      ],
    ),
  );
}

ListTile settingsTile(BuildContext context) {
  return ListTile(
    leading: Icon(Icons.settings),
    title: Text('Change password'),
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ManageAccountPage(),
        ),
      );
    },
  );
}

ListTile signOutTile(BuildContext context) {
  return ListTile(
    leading: Icon(Icons.logout),
    title: Text('Sign out'),
    onTap: () {
      globals.LOGGED_IN_USER = User(0, "", "");
      Navigator.pop(
        context,
      );
      (context as Element).reassemble();
    },
  );
}

ListTile giveFeedbackTile(BuildContext context) {
  return ListTile(
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
  );
}

ListTile logInTile(BuildContext context) {
  return ListTile(
    leading: Icon(Icons.login),
    title: Text('Sign in'),
    onTap: () async{
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SignInPage(),
        ),
      );
      (context as Element).reassemble();
    },
  );
}

ListTile createAccountTile(BuildContext context) {
  return ListTile(
    leading: Icon(Icons.account_box_rounded),
    title: Text('Create account'),
    onTap: () async {
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CreateAccountPage(),
        ),
      );
      (context as Element).reassemble();
    },
  );
}
