import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

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

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  GoogleMapController mapController;

  var isLoading = true;
  final LatLng _center = const LatLng(45.521563, -122.677433);

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
                onPressed: () {
                  print("Search button pressed");
                  setState(() {
                    isLoading = false;
                  });
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
                  child: FloatingActionButton(onPressed: mapController == null ? null :(){
                    mapController.addMarker(MarkerOptions(
                      draggable: false,
                      position: _center,
                      infoWindowText: InfoWindowText('My Location', "marker"),
                    ));
                  },
                  materialTapTargetSize: MaterialTapTargetSize.padded,
                  backgroundColor: Colors.blue,
                  child: const Icon(Icons.my_location, size: 36.0)),
                )
            )
          ],
        )
//      body: GoogleMap(
//        onMapCreated: _onMapCreated,
//        options: GoogleMapOptions(
//          cameraPosition: CameraPosition(target: _center,
//            zoom:11.0,
//          ),
//        ),
//      ),
        );
  }
}

class DataSearch extends SearchDelegate<String> {
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
    // TODO: implement buildResults
    return null;
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // TODO: implement buildSuggestions
    return null;
  }
}
