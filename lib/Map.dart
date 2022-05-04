import 'package:flutter/material.dart';
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class Map extends StatefulWidget {
  @override
  State<Map> createState() => MapState();
}

class MapState extends State<Map> {
  final Completer<GoogleMapController> _controller = Completer();

  final TextEditingController _searchController =  TextEditingController();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(55.427320, 13.819257),
    zoom: 14.4746,
  );

  int currentIndex = 0;
  final screens =[
    Map(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //leading: IconButton(icon: Icon(Icons.search), onPressed:() {},),
        actions: <Widget>[
          IconButton(icon: const Icon(Icons.search), onPressed:() {},),
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
            onMapCreated: (GoogleMapController controller) {
           _controller.complete(controller);
           },
          ),
         // ElevatedButton(onPressed: () {},child: const Text("Search Placses"))
        ],
      )
    );
  }
}

