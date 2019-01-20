import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:polseinzer/database/db_helper.dart';
import 'package:polseinzer/database/model/sign.dart';

void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  GoogleMapController mapController;
  GoogleMapOptions mapOptions;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  GoogleMapController mapController;
  DatabaseHelper databaseHelper = new DatabaseHelper();

  List<Sign> signs;
  final LatLng _center = const LatLng(45.4957515, -73.5811633);

  final DataSearch _delegate = new DataSearch();

  String _lastStringSelected;

  void getAllSigns(LatLng center) async {
    if (mapController == null) return;

    mapController.clearMarkers();
    mapController.addMarker(MarkerOptions(
      draggable: false,
      position: center,
      // icon: BitmapDescriptor.fromAsset('images/circle.png',),
    ));
    mapController.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: center, zoom: 18.0)));

    signs =
        await databaseHelper.getZone(center.longitude, center.latitude, 200);
    print("sign added");
    print(signs.length);
    for (Sign sign in signs) {
      print("sign added1");
      mapController.addMarker(MarkerOptions(
        draggable: false,
        position: LatLng(sign.y, sign.x),
      ));
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        drawer: Drawer(
            child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text('Drawer Header'),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            )
          ],
        )),
        appBar: new AppBar(
          title: new Text('Google Maps'),
          actions: <Widget>[
            new IconButton(
                icon: new Icon(Icons.search),
                onPressed: () async {
                  print("Search button pressed");
                  final String selected = await showSearch<String>(
                      context: context, delegate: _delegate);
                  if (selected != null) {
                    setState(() {
                      _lastStringSelected =
                          selected.replaceAll(r'[^\d\.-,]+', '');
                      var latlng = _lastStringSelected.split(',');
                      LatLng dest = new LatLng(
                          double.parse(latlng[0].substring(1)),
                          double.parse(
                              latlng[1].substring(0, latlng[1].length - 1)));
                      getAllSigns(dest);
                    });
                  }
                }),
          ],
        ),
        body: Stack(
          children: <Widget>[
            new GoogleMap(
              onMapCreated: _onMapCreated,
              options: GoogleMapOptions(
                  compassEnabled: true,
                  cameraPosition: CameraPosition(
                    target: _center,
                    zoom: 18.0,
                  )),
            ),
            Padding(
                padding: const EdgeInsets.all(16.0),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: FloatingActionButton(
                      heroTag: "fab1",
                      onPressed: () {
                        getAllSigns(_center);
                      },
                      materialTapTargetSize: MaterialTapTargetSize.padded,
                      backgroundColor: Colors.blue,
                      child: const Icon(Icons.my_location, size: 36.0)),
                )),
          ],
        ));
  }
}

class DataSearch extends SearchDelegate<String> {
  final List<Address> _data = <Address>[];
  AlertDialog alert;

  @override
  List<Widget> buildActions(BuildContext context) {
    // TODO: implement buildActions
    return null;
  }

  @override
  Widget buildLeading(BuildContext context) {
    // TODO: implement buildLeading
    return IconButton(
        icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow,
          progress: transitionAnimation,
        ),
        onPressed: () {
          close(context, null);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    Geocoder.google("AIzaSyBSNLUYYbxq3A24F9p9QD5A7wI5bcVUlXE")
        .findAddressesFromQuery(query)
        .then((addressResponse) {
      if (alert == null) {
        alert = AlertDialog(
          title: Text('${addressResponse[0].addressLine}'),
          actions: <Widget>[
            FlatButton(
                child: Text('Yes'),
                onPressed: () {
                  Navigator.of(context).pop();
                  close(context, addressResponse[0].coordinates.toString());
                }),
            FlatButton(
                child: Text('No'),
                onPressed: () {
                  Navigator.of(context).pop();
                })
          ],
        );
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return alert;
            });
      }
    });

    var lv = ListView.builder(
        itemCount: _data.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('${_data[index].addressLine}'),
            onTap: () {
              print(_data[index].coordinates.toString());
              close(context, _data[index].coordinates.toString());
            },
          );
        });

    return lv.build(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    alert = null;

    final Iterable<String> suggestions = <String>[];

    return _SuggestionList(
      query: query,
      suggestions: suggestions.toList(),
      onSelected: (String suggestion) {
        query = suggestion;
        showResults(context);
      },
    );
  }
}

class _SuggestionList extends StatelessWidget {
  const _SuggestionList({this.suggestions, this.query, this.onSelected});

  final List<String> suggestions;
  final String query;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (BuildContext context, int i) {
        final String suggestion = suggestions[i];
        return ListTile(
          leading: query.isEmpty ? const Icon(Icons.history) : const Icon(null),
          title: RichText(
            text: TextSpan(
              text: suggestion.substring(0, query.length),
              style:
                  theme.textTheme.subhead.copyWith(fontWeight: FontWeight.bold),
              children: <TextSpan>[
                TextSpan(
                  text: suggestion.substring(query.length),
                  style: theme.textTheme.subhead,
                ),
              ],
            ),
          ),
          onTap: () {
            onSelected(suggestion);
          },
        );
      },
    );
  }
}
