import 'dart:convert';

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_applicationdemo/login/user.dart';
import 'Venue.dart';




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

    //print('Response status: ${response.statusCode}');
   // print('Response body: ${response.body.toString()}');
    var jsonData = jsonDecode(response.body);


    

    //print(jsonData['features'][1]['geometry']['coordinates']);*/

    //print(jsonData['features'][0]['properties']['MAIN_ATTRIBUTE_VALUE']);
  
   // List<_Marker> markers = [];

    for(var m in jsonData['features']) {
      String data = m['properties']['Kategorityp'];
      String typ = m['properties']['MAIN_ATTRIBUTE_VALUE'];
      if(m['properties']['Kategorityp'] == "1.400I, Uteservering A-läge") {
        //print(m['properties']['Kategorityp']);
        _Marker marker = _Marker(m['properties']['Plats_1'],m['properties']['Gatunr_1'],m['geometry']['coordinates']);
        markers.add(marker);
      }

      //print(markers.length);


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
    List<Venue> venues;
    Marker marker_1;
    //for(var marker in markers) {
      marker_1 = const Marker(
        markerId: MarkerId('id_1'),
        position: LatLng(59.320671571444514, 18.055854162299937),
        infoWindow: InfoWindow(
          title: 'Münchenbryggeriet Beer Garden',
          snippet: 'Uteservering',
        ),
        );

      Marker marker_2 = const Marker(
        markerId: MarkerId('id_2'),
        position: LatLng(59.33115735285231, 18.074432570090742),
        infoWindow: InfoWindow(
          title: 'Le Hibou',
          snippet: 'Uteservering',
        )
        );

      Marker marker_3 = const Marker(
        markerId: MarkerId('id_3'),
        position: LatLng(59.3315552932853, 18.092751076985277),
        infoWindow: InfoWindow(
          title: 'Strandbryggan',
          snippet: 'Uteservering',
        )
        );

      Marker marker_4 = const Marker(
        markerId: MarkerId('id_4'),
        position: LatLng(59.33632582609118, 18.072980646196587),
        infoWindow: InfoWindow(
          title: 'Stureplan 1',
          snippet: 'Uteservering',
        )
        );

      Marker marker_5 = const Marker(
        markerId: MarkerId('id_5'),
        position: LatLng(59.3240158318325, 18.070690101341437),
        infoWindow: InfoWindow(
          title: 'Bågspännaren Bar & Cafe',
          snippet: 'Uteservering',
        )
        );

      Marker marker_6 = const Marker(
        markerId: MarkerId('id_6'),
        position: LatLng(59.31905195030728, 18.075349015415547),
        infoWindow: InfoWindow(
          title: 'Mosebacketerrassen',
          snippet: 'Uteservering',
        )
        );

      Marker marker_7 = const Marker(
        markerId: MarkerId('id_7'),
        position: LatLng(59.31583756143469, 18.072591381467536),
        infoWindow: InfoWindow(
          title: 'Snaps Bar & Bistro',
          snippet: 'Uteservering',
        )
        );
      
      Marker marker_8 = const Marker(
        markerId: MarkerId('id_8'),
        position: LatLng(59.315129508641505, 18.074243159987006),
        infoWindow: InfoWindow(
          title: 'Kvarnen',
          snippet: 'Uteservering',
        )
        );
      
      Marker marker_9 = const Marker(
        markerId: MarkerId('id_9'),
        position: LatLng(59.31533181094423, 18.070972638518455),
        infoWindow: InfoWindow(
          title: 'Neverland Pub & Restaurang',
          snippet: 'Uteservering',
        )
        );

      Marker marker_10 = const Marker(
        markerId: MarkerId('id_10'),
        position: LatLng(59.31578389646754, 18.071146819010995),
        infoWindow: InfoWindow(
          title: 'Baras Imperium',
          snippet: 'Uteservering',
        )
        );

      Marker marker_11 = const Marker(
        markerId: MarkerId('id_11'),
        position: LatLng(59.31549103673382, 18.035425964557245),
        infoWindow: InfoWindow(
          title: 'YUC Tanto',
          snippet: 'Uteservering',
        )
        );

      Marker marker_12 = const Marker(
        markerId: MarkerId('id_12'),
        position: LatLng(59.314826329005506, 18.03317611771755),
        infoWindow: InfoWindow(
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
          ElevatedButton(onPressed: _handelPressButton
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