import 'dart:collection';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;
import 'dart:io';

class VenueInfo {

  static const photoSize = '600x400'; //Can be replaced with custom size (Example Format: '300x400')
  late LinkedHashMap<String, dynamic> _photos;
  late List<dynamic> _tastes;
  late int _priceClass;
  late double _rating;
  late int _totalRatings;
  late bool _openNow;
  late String _openHoursToday;


  VenueInfo() {

  }

  Future getVenueInfo(String venueName) async {

    final fourSquareURL =
    Uri.parse('https://foursquare.com/explore?mode=url&near=Stockholm%2C%20Sweden&nearGeoId=72057594040601666&q=$venueName');

    final response1 = await http.get(fourSquareURL);
    if(response1.statusCode == 200) {
      dom.Document html = dom.Document.html(response1.body);

      var fsqId = html.getElementsByClassName('card singleRecommendation hasPhoto tipWithLogging leftPhotoLayout').map((e) => e.attributes['data-id']).toList()[0];

      final response2 = await http.get(
        Uri.parse('https://api.foursquare.com/v3/places/$fsqId?fields=price%2Crating%2Cphotos%2Chours%2Cstats%2Ctastes'),
        headers: {
          HttpHeaders.authorizationHeader: 'fsq3LBbeZ8imQK8X1hov7DTb9F64Xs1fs2bojHQ99QNm4TE='
        },
      );

      if(response2.statusCode == 200) {
        Map data = jsonDecode(response2.body);
        _priceClass = data['price'];
        _rating = data['rating'];
        _photos = data['photos'][0];
        _openNow = data['hours']['open_now'];
        _totalRatings = data['stats']['total_ratings'];
        _tastes = data['tastes'];
        if(data['hours']['display'] != null) {
          _openHoursToday = data['hours']['display'];
        }
      }
      else {
        throw const HttpException("No connection to api.foursquare.com");
      }
    }
    else {
      throw const HttpException("No connection to foursquare.com");
    }



  }

  double getRating() {
    return _rating;
  }

  int getTotalRatings() { //Number of people who contributed to rating score
    return _totalRatings;
  }

  String getOpenStatus() {
    if(_openNow)
      return 'Open now!';
    else
      return 'Closed';
  }

  String getOpeningHours() {
    if(_openHoursToday.isNotEmpty) {
      return  _openHoursToday;
    }
    return 'N/A';
  }


  String getPriceClass () {
    return '\$'*_priceClass;
  }
  String getPhotoURL () {
    return _photos['prefix'] + photoSize + _photos['suffix'];
  }

  bool isOpenNow() {
    return _openNow;
  }


}