import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/material.dart';

//This widget can be called like: ShadowMap(latitude: 59.27439, longitude: 18.03250);

class ShadowMap extends StatefulWidget {
  final double latitude;
  final double longitude;

  const ShadowMap({
    Key? key,
    required this.latitude,
    required this.longitude,
  }) : super(key: key);

  @override
  State<ShadowMap> createState() => _ShadowMapState();
}

class _ShadowMapState extends State<ShadowMap> {
  @override
  Widget build(BuildContext context) {
    var lat = widget.latitude;
    var lng = widget.longitude;
    var dateInMilliseconds = DateTime.now().millisecondsSinceEpoch.toString();
    return Scaffold(
     appBar: AppBar(
       centerTitle: true,
       backgroundColor: const Color.fromARGB(204, 172, 123, 132),
       title: Text(
         'Sun Chasers',
         style: TextStyle(
           fontSize: 42,
           color: const Color.fromARGB(255, 79, 98, 114),
           fontFamily: 'Sacramento',
           shadows: <Shadow>[
             Shadow(
               offset: Offset(2, 2),
               blurRadius: 10.0,
               color: Color.fromARGB(255, 0, 0, 0),
             ),
           ],
         ),
       ),
     ),
     body: WebView(
       initialUrl: 'https://app.shadowmap.org/?lat=$lat&lng=$lng&zoom=17&basemap=map&time=$dateInMilliseconds&vq=2',
       javascriptMode: JavascriptMode.unrestricted,
     )
    );
  }
}
