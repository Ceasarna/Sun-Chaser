import 'dart:convert';
import 'dart:developer';
import 'dart:io';

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

  Widget getCurrentWeatherIcon() {
    switch (weatherValue) {
      case 1:
        return const Icon(Icons.sunny);
      case 2:
        return const Icon(Icons.wb_sunny_outlined);
      case 3:
        return const Icon(Icons.sunny);
      case 4:
        return const Icon(Icons.sunny);
      case 5:
        return const Icon(Icons.cloud);
      case 6:
        return const Icon(Icons.cloud);
      case 7:
        return const Icon(Icons.sunny);
      case 8:
        return const Icon(Icons.sunny);
      case 9:
        return const Icon(Icons.sunny);
      default:
        return const Icon(Icons.not_accessible);
    }
  }
}

class VenuePage extends StatefulWidget {
  const VenuePage({Key? key}) : super(key: key);

  @override
  State<VenuePage> createState() => _VenuePageState();
}

class _VenuePageState extends State<VenuePage> {
  late WeatherData currentWeather;
  final String imageLink = '';

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
        title: const Text('My Venue'),
        backgroundColor: const Color(0xffac7b84),
      ),
      body: Center(
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
                children: const [
                  Text('This is the name'),
                  Text('This is the address'),
                ],
              )),
              Expanded(
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      currentWeather.getCurrentWeatherIcon(),
                      Text(currentWeather.getCurrentTemperature().toString() +
                          '\u2103'),
                    ]),
              )
            ]),
            const AboutTheSpotTable(),
            GridView.count(
              crossAxisCount: 2,
              children: [],
            )
          ]),
        ),
      ),
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
