import 'dart:convert';
import 'dart:io';

import 'package:flutter_applicationdemo/Venue.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'WeatherData.dart';
import 'globals.dart' as globals;


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
        'https://group-4-75.pvt.dsv.su.se/target/weather-0.0.4-SNAPSHOT.war/weather');

    final response = await http.get(weatherDataURI);

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      tempWeather = WeatherData.fromJson(data);

      setState(() {
        globals.forecast = tempWeather;
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
                  Text(venue.venueName,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      )
                  ),
                  Text(venue.venueAddress + ' ' + venue.venueStreetNo),
                ],
              )),
              Expanded(
                child: Container(
                  // decoration: BoxDecoration(
                  //   border: Border.all(color: const Color(0xffaaaaaa)),
                  // ),
                  // color: const Color(0xffe9e9e9),
                  child: buildWeatherColumn(),
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

  Column buildWeatherColumn() {
    return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: /*Text('Weather Status:',
                          style: GoogleFonts.robotoCondensed(
                            textStyle: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          )),*/
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
                    ),
                  ],
                );
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
          primary: const Color(0xff4f6272),
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
