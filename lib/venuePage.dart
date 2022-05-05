import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Color _backgroundColor = const Color(0xffac7b84);

class VenuePage extends StatelessWidget {
  final String imageLink = '';

  const VenuePage({Key? key}) : super(key: key);

  validateAndGetImageLink() {
    if (imageLink == '') {
      return 'https://live.staticflickr.com/6205/6081773215_19444220b6_b.jpg';
    } else {
      return imageLink;
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
            Row(
              children: const [
                Text(
                  'Placeholder for image',
                ),
              ],
            ),
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
