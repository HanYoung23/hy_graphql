import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_controller/google_maps_controller.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:letsgotrip/functions/google_map_functions.dart';
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
  GoogleMapController mapController;

  LatLngBounds latlngBounds;

  @override
  void initState() {
    getMapCoord().then((value) {
      setState(() {
        latlngBounds = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final CameraPosition initPosition = CameraPosition(
      target:
          LatLng(widget.userPosition.latitude, widget.userPosition.longitude),
      zoom: 5,
    );

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
        if (result.hasException) return Text(result.exception.toString());
        if (result.isLoading) return Text('Loading');

        print("🚨🚨 $result");

        List<Marker> mapMarkers = [];
        for (int i = 0; i < result.data["photo_list_map"].length; i++) {
          int markerId =
              int.parse("${result.data["photo_list_map"][i]["contents_id"]}");
          double markerLat =
              double.parse("${result.data["photo_list_map"][i]["latitude"]}");
          double markerLng =
              double.parse("${result.data["photo_list_map"][i]["longitude"]}");

          mapMarkers.add(Marker(
            markerId: MarkerId("$markerId"),
            position: LatLng(markerLat, markerLng),
          ));
        }

        return GoogleMap(
          mapType: MapType.normal,
          myLocationButtonEnabled: false,
          initialCameraPosition: initPosition,
          onMapCreated: (mapController) {
            _controller.complete(mapController);
          },
          onCameraMove: (_) {
            print("🚨🚨 screen moved");
          },
          markers: Set.from(mapMarkers),
        );
      },
    );
  }
}


    // String southwestLat = widget.latlngBounds.southwest.latitude.toString();
    // String southwestLng = widget.latlngBounds.southwest.longitude.toString();
    // String northeastLat = widget.latlngBounds.northeast.latitude.toString();
    // String northeastLng = widget.latlngBounds.northeast.longitude.toString();

