import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_controller/google_maps_controller.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapContainer extends StatefulWidget {
  final Position userPosition;
  final ScreenCoordinate screenCoord;
  const GoogleMapContainer(
      {Key key, @required this.userPosition, @required this.screenCoord})
      : super(key: key);

  @override
  _GoogleMapContainerState createState() => _GoogleMapContainerState();
}

class _GoogleMapContainerState extends State<GoogleMapContainer> {
  Completer<GoogleMapController> _controller = Completer();
  var _googleMapController = GoogleMapsController();

  static final CameraPosition _currentPosition = CameraPosition(
    target: LatLng(41.456038, 15.777665),
  );

  Future<void> _goToCurrentPosition() async {
    final GoogleMapController controller = await _controller.future;
    controller
        .animateCamera(CameraUpdate.newCameraPosition(_currentPosition))
        .then((_) async {
      await controller.getVisibleRegion().then((value) {
        print("🚨 southwest.latitude: " + value.southwest.latitude.toString());
        print(
            "🚨 southwest.longitude: " + value.southwest.longitude.toString());
        print("🚨 northeast.latitude: " + value.northeast.latitude.toString());
        print(
            "🚨 northeast.longitude: " + value.northeast.longitude.toString());
      });
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          child: Container(
            child: GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: CameraPosition(
                target: LatLng(widget.userPosition.latitude,
                    widget.userPosition.longitude),
                zoom: 13,
              ),
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
                _goToCurrentPosition();
              },
            ),
          ),
        ),
        // Positioned(
        //   top: 0,
        //   child: InkWell(
        //     onTap: () {
        //       _goToCurrentPosition();
        //     },
        //     child: Container(
        //       color: Colors.amber,
        //       height: 100,
        //       width: 100,
        //     ),
        //   ),
        // )
      ],
    );
  }
}
