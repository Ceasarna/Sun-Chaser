import 'dart:convert';

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:http/http.dart' as http;




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
      
      
      /*for (var mar in markers) {
        print(mar.Plats_1);
        print(mar.Gatunr_1);
        print(mar.coordinates[1]);
        print(mar.coordinates[0]);
      }*/

      //print(m['properties']['Kategorityp']);
    } 
  }

  final Completer<GoogleMapController> _controller = Completer();

  final TextEditingController _searchController =  TextEditingController();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(59.325027,18.068516),
    zoom: 14.4746,
  );

  List<Marker> markersList = [];

  @override
  void initState() {
    intilize();
    super.initState();
  }

  intilize() {
    Marker newMarker;
    //for(var marker in markers) {
      newMarker = Marker(
        markerId: MarkerId(''),
        position: LatLng(59.325027,18.068516),
        );
      markersList.add(newMarker);
   // }
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
          ElevatedButton(onPressed: getMerkerData
          ,child: const Text("Search Placses"))
        ],
      )
    );
  }

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
  }
}

class _Marker {

  var Plats_1;
  var Gatunr_1;
  var coordinates;

  _Marker(this.Plats_1, this.Gatunr_1, this.coordinates);

}