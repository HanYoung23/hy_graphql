import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_controller/google_maps_controller.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:letsgotrip/widgets/graphql_query.dart';

class GoogleMapContainer extends StatefulWidget {
  final Position userPosition;
  const GoogleMapContainer({Key key, @required this.userPosition})
      : super(key: key);

  @override
  _GoogleMapContainerState createState() => _GoogleMapContainerState();
}

class _GoogleMapContainerState extends State<GoogleMapContainer> {
  Completer<GoogleMapController> _controller = Completer();
  // var _googleMapController = GoogleMapsController();

  LatLngBounds latlngBounds;

  @override
  void initState() {
    _goToCurrentPosition();
    super.initState();
  }

  Future<void> _goToCurrentPosition() async {
    final GoogleMapController controller = await _controller.future;
    await controller.getVisibleRegion().then((latlng) {
      setState(() {
        latlngBounds = latlng;
      });
      print("🚨 southwest.latitude: " + latlng.southwest.latitude.toString());
      print("🚨 southwest.longitude: " + latlng.southwest.longitude.toString());
      print("🚨 northeast.latitude: " + latlng.northeast.latitude.toString());
      print("🚨 northeast.longitude: " + latlng.northeast.longitude.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    final CameraPosition _currentPosition = CameraPosition(
      target:
          LatLng(widget.userPosition.latitude, widget.userPosition.longitude),
    );

    return Stack(
      children: [
        Positioned(
          child: Container(
            child: GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: CameraPosition(
                target: LatLng(widget.userPosition.latitude,
                    widget.userPosition.longitude),
                zoom: 5,
              ),
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
                // _goToCurrentPosition();
              },
            ),
          ),
        ),
        Positioned(
          top: 0,
          child: InkWell(
            onTap: () {
              _goToCurrentPosition();
            },
            child: Container(
              color: Colors.amber,
              height: 100,
              width: 100,
              child: MapPhotos(latlngBounds: latlngBounds),
            ),
          ),
        ),
      ],
    );
  }
}

class MapPhotos extends StatefulWidget {
  final LatLngBounds latlngBounds;
  const MapPhotos({Key key, @required this.latlngBounds}) : super(key: key);

  @override
  _MapPhotosState createState() => _MapPhotosState();
}

class _MapPhotosState extends State<MapPhotos> {
  @override
  Widget build(BuildContext context) {
    // String southwestLat = widget.latlngBounds.southwest.latitude.toString();
    // String southwestLng = widget.latlngBounds.southwest.longitude.toString();
    // String northeastLat = widget.latlngBounds.northeast.latitude.toString();
    // String northeastLng = widget.latlngBounds.northeast.longitude.toString();

    return Query(
      options: QueryOptions(
        document: gql(Queries.mapPhotos),
        variables: {
          "latitude1": "33.2200505873032",
          "latitude2": "38.479807266878815",
          "longitude1": "125.27173485606909",
          "longitude2": "129.98494371771812"
        },
      ),
      builder: (result, {refetch, fetchMore}) {
        // if (result.hasException) return Text(result.exception.toString());
        // if (result.isLoading) return Text('Loading');
        // List photos = result.data['photos']['results'];
        // List<Widget> photosWidgets = photos.map<Widget>((photoInfo) {
        //   return Text('${photoInfo['id']}. ${photoInfo['name']}');
        // }).toList();
        print("🚨🚨 $result");
        return ListView.builder(
            itemCount: 4,
            itemBuilder: (context, index) {
              return Text("$result");
            });
      },
    );
  }
}

// "latitude1": southwestLat,
          // "latitude2": northeastLat,
          // "longitude1": southwestLng,
          // "longitude2": northeastLng,

// I/flutter (13306): 🚨 southwest.latitude: 37.24570368093961
// I/flutter (13306): 🚨 southwest.longitude: 127.01033771038055
// I/flutter (13306): 🚨 northeast.latitude: 37.313451887073825
// I/Counters(13306): exceeded sample count in FrameTime
// I/flutter (13306): 🚨 northeast.longitude: 127.07213547080755

