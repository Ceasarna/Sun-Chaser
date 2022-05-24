import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;

class WebScraper {

  late List<String> openingHoursThisWeek;
  late String openingHoursToday;
  late String reviewScore;
  //late String priceClass;

  WebScraper() { //Must provide an URL from bing search engine.

  }

  Future getWebsiteData(String venueName) async {
    final bingURL = Uri.parse('https://www.bing.com/search?q=$venueName');
    final bingResponse = await http.get(bingURL);
    dom.Document htmlBing = dom.Document.html(bingResponse.body);


    openingHoursToday = htmlBing
        .getElementsByClassName('opHr_Exp')
        .map((e) => e.text)
        .toList()[0]
        .toString();

    openingHoursThisWeek = htmlBing
        .getElementsByClassName('hrRange')
        .map((e) => e.text)
        .toList();

    reviewScore = htmlBing.getElementsByClassName('csrc sc_rc1')
        .map((e) => e.attributes['aria-label'])
        .toList()[0]
        .toString();

   /* final tripAdvisorURL = htmlBing.querySelectorAll('div.infoModule.b_divsec.topBleed.noSeparator > div > a')
        .map((e) => e.attributes['href'])
        .toList()[0]
        .toString();

    final tripAdvisorResponse = await http.get(Uri.parse(tripAdvisorURL));
    dom.Document htmlTripAdvisor = dom.Document.html(tripAdvisorResponse.body);

    priceClass = htmlTripAdvisor
        .getElementsByClassName('drUyy')
        .map((e) => e.text)
        .toList()[0]
        .toString();*/
  }

  List<String> get getOpeningHoursThisWeek => openingHoursThisWeek; //First item is monday, last item is sunday.
  // Output example: "[11:00 - 01:00, 11:00 - 01:00, 11:00 - 01:00, 11:00 - 01:00, 11:00 - 01:00, 11:00 - 01:00, 11:00 - 01:00]"

  String get getOpeningHoursToday => openingHoursToday; //Output example: "Open · Closes 01:00" (Gets automatically updated).
  String get getReviewScore => reviewScore; // Output example: "Star Rating: 4 out of 5.".
  //String get getPriceClass => priceClass; // Output example: "$$ - $$$".

}