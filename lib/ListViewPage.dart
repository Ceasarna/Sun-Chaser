import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'globals.dart' as globals;
import 'package:flutter_applicationdemo/Venue.dart';
import 'VenuePage.dart';

class ListViewPage extends StatefulWidget {
  const ListViewPage({Key? key}) : super(key: key);

  @override
  State<ListViewPage> createState() => _ListViewPageState();
}

class _ListViewPageState extends State<ListViewPage> {
  final List<Venue> allVenues = globals.VENUES;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Venues near you',),
        backgroundColor: globals.BACKGROUNDCOLOR,
      ),
      body: buildListView(),
    );
  }

  ListView buildListView() {
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: allVenues.length,
      itemBuilder: (context, index) {
        return ListTile(
            shape: buildBorder(),
            onTap: () => _navigateToVenue(allVenues[index]),
            leading: buildIconBox(index, context),
            title: buildTitleText(index),
            subtitle: buildWeatherRow(),

            // trailing: const Text('400m'),
        );
      },
    );
  }

  RoundedRectangleBorder buildBorder() {
    return RoundedRectangleBorder(
        side: const BorderSide(color: Color(0xffe9e9e9), width: 1),
        borderRadius: BorderRadius.circular(5));
  }

  SizedBox buildIconBox(int index, BuildContext context) {
    return SizedBox(
      height: double.infinity,
      child: allVenues[index].getIcon(context),
    );
  }

  Row buildWeatherRow() {
    return Row(
      children: [
        const Text('Current weather: '),
        const Spacer(
          flex: 2,
        ),
        globals.forecast.getCurrentWeatherIcon(),
        const Spacer(),
      ],
    );
  }

  Text buildTitleText(int index) {
    return Text(
      allVenues[index].venueName.toString(),
      style: GoogleFonts.roboto(
          textStyle: const TextStyle(
            fontSize: 18,
            color: Color(0xff994411),
          )),
    );
  }

  void _navigateToVenue(Venue venue) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => VenuePage(venue)));
  }


}
