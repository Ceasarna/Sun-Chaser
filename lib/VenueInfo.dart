import 'dart:collection';
import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;
import 'dart:io';

import 'Venue.dart';

class VenueInfo {

  static const photoSize = 'original'; //Can be replaced with custom size (Example Format: '300x400')
  late String _photo = 'https://www.bing.com/th?id=OIP.ZSXrQuieNC-hoPC4kIv_vgAAAA&w=212&h=212&c=8&rs=1&qlt=90&o=6&dpr=1.35&pid=3.1&rm=2';
  late int _priceClass = -1;
  late double _rating = -1;
  late int _totalRatings = -1;
  late bool _openNow = false;
  late String _openHoursToday = 'N/A';
  late String _fsqLink;
  late double _popularity = -1;

  VenueInfo();

  Future getVenueInfo(Venue venue) async {
    String venueName = venue.venueName;
    double lat = venue.position.latitude;
    double lng = venue.position.longitude;

    final response1 = await http.get(
        Uri.parse('https://api.foursquare.com/v3/autocomplete?query=$venueName&ll=$lat%2C$lng&types=place'),
        headers: {
          HttpHeaders.authorizationHeader: 'fsq3LBbeZ8imQK8X1hov7DTb9F64Xs1fs2bojHQ99QNm4TE=',
        });
    if(response1.statusCode == 200) {
      Map data = jsonDecode(response1.body);
      List results = data['results'];
      if(results.isNotEmpty && data['results'][0]['link'] != null) {
        _fsqLink = data['results'][0]['link'];
        final response2 = await http.get(
            Uri.parse('https://api.foursquare.com$_fsqLink?fields=price%2Crating%2Cphotos%2Chours%2Cstats%2Cpopularity'),
            headers: {
              HttpHeaders.authorizationHeader: 'fsq3LBbeZ8imQK8X1hov7DTb9F64Xs1fs2bojHQ99QNm4TE=',
            }
        );
        if(response2.statusCode == 200) {
          Map data = jsonDecode(response2.body);
          data['price'] != null ? _priceClass = data['price']: null;
          data['rating'] != null ? _rating = data['rating']: null;
          data['hours']['open_now'] != null ? _openNow = data['hours']['open_now']: null;
          data['stats']['total_ratings'] != null ?  _totalRatings = data['stats']['total_ratings']: null;
          data['hours']['display'] != null ? _openHoursToday = data['hours']['display']: null;
          data['popularity'] != null ? _popularity = data['popularity']: null;
          data['photos'][0]['prefix'] != null && data['photos'][0]['suffix'] != null ?
          _photo = data['photos'][0]['prefix'] + photoSize + data['photos'][0]['suffix']: null;
        }
        else {
          throw const HttpException("No connection to api.foursquare.com");
        }
      }
    }
    else {
      throw const HttpException("No connection to api.foursquare.com");
    }
}

  /*Future getVenueInfo(String venueName) async {

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
        if(data['price'] != null) {
          _priceClass = data['price'];
        }
        if(data['rating'] != null) {
          _rating = data['rating'];
        }
        if(data['photos'][0] != null) {
          _photos = data['photos'][0];
        }
        if(data['hours']['open now'] != null) {
          _openNow = data['hours']['open_now'];
        }
        if(data['stats']['total_ratings'] != null) {
          _totalRatings = data['stats']['total_ratings'];
        }
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
  }*/

  String getRating() {
    return _rating != -1 ? _rating.toString() + '/10': 'N/A';
  }

  String getTotalRatings() {
    return _totalRatings != -1 ? _totalRatings.toString(): 'N/A';
  }

  String getOpenStatus() {
    return _openNow ? 'Open now!': 'Closed';
  }

  String getOpeningHours() {
    String splitString;
    if(_openHoursToday.isNotEmpty) {
      splitString = _openHoursToday.replaceAll(';', '\n');
      return splitString;
    }
    return 'N/A';
  }
  String getPriceClass () {
   return  _priceClass != -1 ? '\$'*_priceClass : 'N/A';
  }
  String getPhotoURL () {
      return _photo;
  }
  String getPopularity() {
    return _popularity != -1 ?  (_popularity*100).truncate().toString() + '%': 'N/A';
  }
  bool isOpenNow() {
    return _openNow;
  }
  String getVenueURL () {
    return 'https://api.foursquare.com$_fsqLink';
  }
}