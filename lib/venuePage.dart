import 'dart:convert';
import 'dart:io';

import 'package:flutter_applicationdemo/Venue.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

// Color _backgroundColor = const Color(0xffac7b84);

class WeatherData {
  final int weatherValue;
  final int temperature;

  WeatherData(this.weatherValue, this.temperature);

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    var value = json.values;
    var tempWeatherData;
    var tempTemperature;

    if (value.first['wsymb2'] is int) {
      tempWeatherData = value.first['wsymb2'];
    }
    if (value.first['temp'] is double) {
      tempTemperature = value.first['temp'];
    }

    if (tempWeatherData != null && tempTemperature != null) {
      return WeatherData(tempWeatherData, tempTemperature.round());
    } else {
      return WeatherData(0, 0);
    }
  }

  int getCurrentTemperature() {
    return temperature;
  }

  String getCurrentWeatherStatus() {
    String weatherStatus;
    switch (weatherValue) {
      case 0:
        weatherStatus = 'Undefined';
        break;
      case 1:
        weatherStatus = 'Clear sky';
        break;
      case 2:
        weatherStatus = 'Nearly clear sky';
        break;
      case 3:
        weatherStatus = 'Variable cloudiness';
        break;
      case 4:
        weatherStatus = 'Halfclear sky';
        break;
      case 5:
        weatherStatus = 'Cloudy sky';
        break;
      case 6:
        weatherStatus = 'Overcast';
        break;
      case 7:
        weatherStatus = 'Fog';
        break;
      case 8:
        weatherStatus = 'Light rain showers';
        break;
      case 9:
        weatherStatus = 'Moderate rain showers';
        break;
      case 10:
        weatherStatus = 'Heavy rain showers';
        break;
      case 11:
        weatherStatus = 'Thunderstorm';
        break;
      case 12:
        weatherStatus = 'Light sleet showers';
        break;
      case 13:
        weatherStatus = 'Moderate sleet showers';
        break;
      case 14:
        weatherStatus = 'Heavy sleet showers';
        break;
      case 15:
        weatherStatus = 'Light snow showers';
        break;
      case 16:
        weatherStatus = 'Moderate snow showers';
        break;
      case 17:
        weatherStatus = 'Heavy snow showers';
        break;
      default:
        weatherStatus = 'Undefined';
    }
    return weatherStatus;
  }

  Widget getCurrentWeatherIcon() {
    switch (weatherValue) {
      case 1:
        return const Icon(
          Icons.sunny,
          color: Color.fromARGB(255, 251, 183, 9),
        );
      case 2:
        return const Icon(
          Icons.sunny,
          color: Color.fromARGB(255, 251, 183, 9),
        );
      case 3:
        return const FaIcon(FontAwesomeIcons.cloudSun);
      case 4:
        return const FaIcon(FontAwesomeIcons.cloudSun);
      case 5:
        return const FaIcon(FontAwesomeIcons.cloud);
      case 6:
        return const FaIcon(FontAwesomeIcons.cloud);
      case 7:
        return const FaIcon(FontAwesomeIcons.smog);
      case 8:
        return const FaIcon(FontAwesomeIcons.umbrella);
      case 9:
        return const FaIcon(FontAwesomeIcons.cloudRain);
      case 10:
        return const FaIcon(FontAwesomeIcons.cloudShowersHeavy);
      case 11:
        return const FaIcon(FontAwesomeIcons.cloudflare);
      case 12:
        return const FaIcon(FontAwesomeIcons.cloudRain);
      case 13:
        return const FaIcon(FontAwesomeIcons.cloudShowersHeavy);
      case 14:
        return const FaIcon(FontAwesomeIcons.cloudShowersHeavy);
      case 15:
        return const FaIcon(FontAwesomeIcons.snowflake);
      case 16:
        return const FaIcon(FontAwesomeIcons.snowflake);
      case 17:
        return const FaIcon(FontAwesomeIcons.snowflake);
      default:
        return const Icon(Icons.not_accessible);
    }
  }
}

class VenuePage extends StatefulWidget {
  const VenuePage(this.venue, {Key? key}) : super(key: key);
  final Venue venue;

  @override
  State<VenuePage> createState() => _VenuePageState(venue);
}

class _VenuePageState extends State<VenuePage> {
  late WeatherData currentWeather;
  final String imageLink = '';
  late final Venue venue;

  _VenuePageState(this.venue);

  validateAndGetImageLink() {
    if (imageLink == '') {
      return 'https://live.staticflickr.com/6205/6081773215_19444220b6_b.jpg';
    } else {
      return imageLink;
    }
  }

  @override
  void initState() {
    refreshWeather();
  }

  Future refreshWeather() async {
    WeatherData tempWeather = WeatherData(0, 0);
    currentWeather = tempWeather;

    Uri weatherDataURI = Uri.parse(
        'https://group-4-75.pvt.dsv.su.se/target/weather-0.0.2-SNAPSHOT.war/weather');

    final responce = await http.get(weatherDataURI);

    if (responce.statusCode == 200) {
      var data = json.decode(responce.body);
      tempWeather = WeatherData.fromJson(data);

      print(data);

      setState(() {
        currentWeather = tempWeather; //Could be a widget instead??
      });
    } else {
      throw const HttpException("Problem fetching the weather data");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfffceff9),
      appBar: AppBar(
        title: Text(venue.venueName),
        backgroundColor: const Color(0xffac7b84),
      ),
      body: Center(child: SingleChildScrollView(
        child: Container(
          alignment: Alignment.center,
          child: Column(children: <Widget>[
            Row(
              children: const [
                ShareButton(),
                SavePlaceButton(),
              ],
            ),
            Row(children: [
              Expanded(
                child: Image.network(validateAndGetImageLink()),
              ),
            ]),
            // Row(
            //   children: const [
            //     Text(
            //       'Placeholder for image',
            //     ),
            //   ],
            // ),
            Row(children: [
              Expanded(
                  child: Column(
                children: [
                  Text(venue.venueName),
                  Text('This is the address'),
                ],
              )),
              Expanded(
                child: Container(
                  // decoration: BoxDecoration(
                  //   border: Border.all(color: const Color(0xffaaaaaa)),
                  // ),
                  // color: const Color(0xffe9e9e9),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text('Weather Status:',
                            style: GoogleFonts.robotoCondensed(
                              textStyle: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            )),
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              children: [
                                currentWeather.getCurrentWeatherIcon(),
                                Text(currentWeather.getCurrentWeatherStatus()),
                              ],
                            ),
                            Text(currentWeather
                                    .getCurrentTemperature()
                                    .toString() +
                                '\u2103'),
                          ]),
                    ],
                  ),
                ),
              )
            ]),
            const AboutTheSpotTable(),
            /*GridView.count(
              crossAxisCount: 2,
              children: [],
            )*/
          ]),
        ),
      ),
    ));
  }
}

//Just an example table
class AboutTheSpotTable extends StatelessWidget {
  const AboutTheSpotTable({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DataTable(
      headingRowHeight: 30,
      columnSpacing: 100,
      dataRowHeight: 30,
      dataTextStyle: GoogleFonts.robotoCondensed(
        color: const Color(0xff4F6272),
      ),
      columns: [
        DataColumn(
            label: Text('About the spot',
                style: GoogleFonts.roboto(
                    textStyle: const TextStyle(
                  fontSize: 18,
                )))),
        const DataColumn(label: Text('', style: TextStyle())),
      ],
      rows: const [
        DataRow(cells: [
          DataCell(Text('Type of venue')),
          DataCell(Text('Saloon')),
        ]),
        DataRow(cells: [
          DataCell(Text('Pricing')),
          DataCell(Text('\$\$\$')),
        ]),
        DataRow(cells: [
          DataCell(Text('Rating')),
          DataCell(Text('4.2/5')),
        ]),
        DataRow(cells: [
          DataCell(Text('Current activity')),
          DataCell(Text('Moderate')),
        ]),
        DataRow(cells: [
          DataCell(Text('Opening hours')),
          DataCell(Text('11:00-23:00')),
        ]),
      ],
    );
  }
}

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         backgroundColor: const Color(0xfffceff9),
//         appBar: AppBar(
//           title: const Text('My Venue'),
//           backgroundColor: _backgroundColor,
//         ),
//         body: Row(
//           children: const <Widget>[
//             ShareButton(),
//             SavePlaceButton(),
//           ],
//         ));
//   }
// }

class SavePlaceButton extends StatelessWidget {
  const SavePlaceButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TextButton.icon(
        onPressed: () {},
        icon: const Icon(
          Icons.favorite,
          color: Colors.red,
        ),
        label: const Text('Save place'),
        style: TextButton.styleFrom(
          primary: Color(0xff4f6272),
        ),
      ),
    );
  }
}

class ShareButton extends StatelessWidget {
  const ShareButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TextButton.icon(
        onPressed: () {},
        icon: const Icon(Icons.share),
        label: const Text('Share'),
      ),
    );
  }
}
