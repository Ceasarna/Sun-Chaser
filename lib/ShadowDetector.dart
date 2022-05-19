
import 'package:http/http.dart';
import 'dart:async';

class ShadowDetector {

  bool inShade = false;

  ShadowDetector(double latitude, double longitude) {

    evaluateShadowSituation(latitude, longitude);

  }

  void evaluateShadowSituation (double latitude, double longitude) async {
    var lat = latitude.toString();
    var lng = longitude.toString();
    var dateInMilliseconds = DateTime.now().millisecondsSinceEpoch.toString() + 't';
    final response = await get(Uri.parse('https://node.sacalerts.com/og-image/loc@$lat,$lng,14.82137z,$dateInMilliseconds'));
    var responseAsString = response.body.toString();
    print(response);
    print(responseAsString);
    if(responseAsString[responseAsString.length - 2] == 1) {
      this.inShade = true;
    }
  }
  bool get isInShade =>inShade;
}