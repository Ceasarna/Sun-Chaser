import 'package:flutter/material.dart';
import 'package:flutter_applicationdemo/venue_page.dart';
import 'venue.dart';
import 'globals.dart' as globals;
import 'login/sign_in_page.dart';
import 'mysql.dart';


@override
class FavoritePage extends StatefulWidget {
  const FavoritePage({Key? key}) : super(key: key);

  @override
  _FavoritePageState createState() => _FavoritePageState();
}
class _FavoritePageState extends State<FavoritePage> {
  List<Venue> likedVenuesList = globals.LOGGED_IN_USER.likedVenuesList;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Text("Liked"),
            backgroundColor: globals.BACKGROUNDCOLOR,
          ),
          body: globals.LOGGED_IN_USER.userID != 0 ? ListView.builder(
            itemCount: likedVenuesList.length,
            itemBuilder: (BuildContext context, int index) {
              return Dismissible(
              key: UniqueKey(),
              background: buildDeleteBackground(MainAxisAlignment.start, true),
              secondaryBackground: buildDeleteBackground(MainAxisAlignment.end, false),
              confirmDismiss: (DismissDirection direction) async{
                return await showDialog(
                    context: context,
                    builder: (BuildContext context){
                      return buildUnlikeConfirmation(index, context);
                    },
                );
              },
                onDismissed: (DismissDirection direction){
                  removeVenueAsFavorite(likedVenuesList[index]);
                  setState(() {
                  likedVenuesList.removeAt(index);
                });
                },
                child: SizedBox(
                  width: double.infinity,
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: InkWell(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Text(likedVenuesList[index].venueName),
                      ),
                      onTap: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => VenuePage(likedVenuesList[index])),
                        );
                      },
                    ),
                  ),
                ),
              );
            },
          )
              : Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const Text(
                  'Can\'t find your liked venues\n since you\'re not logged in',
                  style: TextStyle(fontSize: 25),
                ),
                const Padding(padding: EdgeInsets.symmetric(horizontal: 10, vertical: 45),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    fixedSize: const Size(200, 50),
                    primary: globals.BUTTONCOLOR,
                    elevation: 100,
                  ),
                  onPressed: () async{
                    await Navigator.push(
                      context, //SignInPage()
                      MaterialPageRoute(builder: (context) =>SignInPage()), //Replace Container() with call to Map-page.
                    );
                    (context as Element).reassemble();
                  },
                  child: Text('Sign in',
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          shadows: <Shadow> [
                            Shadow(
                              offset: Offset(2, 2),
                              blurRadius: 10.0,
                              color: globals.SHADOWCOLOR,
                            ),
                          ])
                  ),
                ),
              ],
            )
          )
        ),
    );
  }

  AlertDialog buildUnlikeConfirmation(int index, BuildContext context) {
    return AlertDialog(
                      title: Text("Delete confirmation"),
                      content: Text("Are you sure you want to unlike ${likedVenuesList[index].venueName}?"),
                      actions: <Widget>[
                        TextButton(
                            onPressed: () => Navigator.of(context).pop(true),
                            child: const Text("Delete")
                        ),
                        TextButton(onPressed: () => Navigator.of(context).pop(false),
                            child: const Text("Cancel")
                        ),
                      ],
                    );
  }

  Container buildDeleteBackground(MainAxisAlignment maa, bool heartAtStart) {
    return Container(
      color: Colors.red,
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Row(
          mainAxisAlignment: maa,
          children: setHeartAtBeginning(heartAtStart),
        ),
      ),
    );
  }

  List<Widget> setHeartAtBeginning(bool heartAtStart) {
    if(heartAtStart){
      return <Widget>[
        const Icon(Icons.heart_broken, color: Colors.white),
        Text("Remove liked venue", style: TextStyle(color: Colors.white)),
      ];
    }
    return <Widget>[
      const Text("Remove liked venue", style: TextStyle(color: Colors.white)),
      Icon(Icons.heart_broken, color: Colors.white),
    ];
  }

  void removeVenueAsFavorite(Venue likedVenue) {
    var db = mysql();
    db.getConnection().then((conn){
      String sql =
          "DELETE from maen0574.userFavorites where user_id = '${globals.LOGGED_IN_USER.userID}' and venue_id = '${likedVenue.venueID}'";
      conn.query(sql).then((results) {});
    });
  }
}

