import 'dart:convert';
import 'dart:io';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_applicationdemo/venue.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'venue_info.dart';
import 'weather_data.dart';
import 'globals.dart' as globals;
import 'venue.dart';

// Color _backgroundColor = const Color(0xffac7b84);


class VenuePage extends StatefulWidget {
  const VenuePage(this.venue, {Key? key}) : super(key: key);
  final Venue venue;

  @override
  State<VenuePage> createState() => VenuePageState(venue);
}

@visibleForTesting
class VenuePageState extends State<VenuePage> {
  late WeatherData currentWeather;
  final String imageLink = '';
  late final Venue venue;
  late VenueInfo venueInfo;

  VenuePageState(this.venue);


  @override
  void initState() {
    refreshWeather();
  }

  Future gatherVenueInfo() async {
    VenueInfo vi = VenueInfo();
    venueInfo = vi;
    venueInfo = await vi.getVenueInfo(venue);
  }

  Future refreshWeather() async {
    WeatherData tempWeather = WeatherData(0, 0);
    currentWeather = tempWeather;

    Uri weatherDataURI = Uri.parse(
        'https://group-4-75.pvt.dsv.su.se/target/info.war/weather');

    final response = await http.get(weatherDataURI);

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      tempWeather = WeatherData.fromJson(data);

      setState(() {
        globals.forecast = tempWeather;
        currentWeather = tempWeather;
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
        body: Center(
            child: FutureBuilder(
                future: gatherVenueInfo(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return SingleChildScrollView(
                        child: Container(
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width,
                          alignment: Alignment.center,
                          child: buildPageContentColumn(),
                        ),
                    );
                  } else {
                    return const CircularProgressIndicator();
                  }
                })));
  }

  SingleChildScrollView buildPageContentColumn() {
    return SingleChildScrollView(
        child: Column(children: <Widget>[
          Row(
            children: [
              const ShareButton(),
              LikeVenueButton(venue),
            ],
          ),
          Row(children: [
            Expanded(
              child: Image.network(venueInfo.getPhotoURL()),
            ),
          ]),
          Row(children: [buildNameAndAddress(), buildWeatherInfo()]),
          AboutTheSpotTable(venueInfo: venueInfo),
          //Expanded(child: AboutTheSpotTable(venueInfo: venueInfo)),
        ]));
  }

  Expanded buildWeatherInfo() {
    return Expanded(
      child: Container(
        child: buildWeatherColumn(),
      ),
    );
  }

  Expanded buildNameAndAddress() {
    return Expanded(
        child: Column(
      children: [
        Text(venue.venueName,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            )),
        Text(venue.venueAddress + ' ' + venue.venueStreetNo),
      ],
    ));
  }

  Column buildWeatherColumn() {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(4.0),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            Column(
              children: [
                currentWeather.getCurrentWeatherIcon(),
                Text(currentWeather.getCurrentWeatherStatus()),
              ],
            ),
            Text(currentWeather.getCurrentTemperature().toString() + '\u2103'),
          ]),
        ),
      ],
    );
  }
}

//Just an example table
class AboutTheSpotTable extends StatefulWidget {
  final VenueInfo venueInfo;

  AboutTheSpotTable({
    Key? key,
    required this.venueInfo,
  }) : super(key: key);

  @override
  State<AboutTheSpotTable> createState() => _AboutTheSpotTableState();
}

class _AboutTheSpotTableState extends State<AboutTheSpotTable> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Center(
          child: DataTable(
            // headingRowHeight: 30,
            // columnSpacing: 100,
            //dataRowHeight: 30,
            dataTextStyle: GoogleFonts.robotoCondensed(
              color: const Color(0xff4F6272),
            ),
            columns: [
              DataColumn(
                  label: Text('About the spot',
                      style: GoogleFonts.roboto(
                          textStyle: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          )))),
              DataColumn(label: Text('', style: TextStyle())),
            ],
            rows: [
              DataRow(cells: [
                DataCell(Text('Open?')),
                DataCell(Text(widget.venueInfo.getOpenStatus())),
              ]),
               DataRow(cells: [
                DataCell(Text('Popularity')),
                DataCell(Text(widget.venueInfo.getPopularity())),
              ]),
              DataRow(cells: [
                const DataCell(Text('Pricing')),
                DataCell(Text(widget.venueInfo.getPriceClass())),
              ]),
              DataRow(cells: [
                const DataCell(Text('Rating')),
                DataCell(Text(widget.venueInfo.getRating().toString() +
                    ' (' +
                    widget.venueInfo.getTotalRatings().toString() +
                    ' ratings)')),
              ]),
               DataRow(cells: [
                DataCell(Text('Popular hours')),
                DataCell(Text(widget.venueInfo.getPopularHoursToday())),
              ]),
              DataRow(cells: [
                const DataCell(Text('Opening hours')),
                DataCell(Text(widget.venueInfo.getOpeningHours())),
              ]),
            ],
          ),
        ));
  }
}

class LikeVenueButton extends StatelessWidget {
  Venue venue;

  LikeVenueButton(this.venue, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return globals.LOGGED_IN_USER.likedVenuesList.contains(venue) ? buildLikeButton(context, venue, true) : buildLikeButton(context, venue, false);
  }

  Expanded buildLikeButton(BuildContext context, Venue venue, bool alreadyLiked) {
    return alreadyLiked? Expanded(
    child: TextButton.icon(
      onPressed: () {
        venue.unlikeVenue();
        (context as Element).reassemble();
      },
      icon: const Icon(
        Icons.favorite,
        color: Colors.red,
      ),
      label: const Text('Unlike place'),
      style: TextButton.styleFrom(
        primary: const Color(0xff4f6272),
      ),
    ),
    ) : globals.LOGGED_IN_USER.userID != 0 ? Expanded(
        child: TextButton.icon(
          onPressed: () {
            venue.likeVenue();
            (context as Element).reassemble();
          },
          icon: const Icon(
            Icons.favorite_border_outlined,
            color: Colors.red,
          ),
          label: const Text('Like place'),
          style: TextButton.styleFrom(
            primary: const Color(0xff4f6272),
          ),
        )): Expanded(
          child: TextButton.icon(
            onPressed: () async{
              await notLoggedInError(context);
            },
            icon: const Icon(
            Icons.favorite_border_outlined,
            color: Colors.grey,
            ),
            label: const Text('Like place'),
            style: TextButton.styleFrom(
            primary: Color(0xff4f6272),
            ),
    ));
  }

  notLoggedInError(BuildContext context) {
    Widget okButton = TextButton(
      child: Text("OK"),
      onPressed: () => Navigator.pop(context, 'OK'),
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Can\'t like venue"),
      content: Text("You need to be logged in to like venues."),
      actions: [
        okButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
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
      child: Column(
        children: <Widget>[
          TextButton.icon(
            onPressed: () {shareVenue();},
            icon: const Icon(Icons.share),
            label: const Text('Share'),
          ),
        ],
      ),
    );
  }

  void shareVenue() {

    Share.share('Share this venue', subject: 'Subject venue');

  }

}