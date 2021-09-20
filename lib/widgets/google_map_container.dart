import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_controller/google_maps_controller.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:letsgotrip/server/server_map_photos.dart';

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

  @override
  void initState() {
    super.initState();
  }

  Future<void> _goToCurrentPosition() async {
    final GoogleMapController controller = await _controller.future;
    await controller.getVisibleRegion().then((lntlngBounds) {
      postServerMapPhotos(context, lntlngBounds);
      print("🚨 southwest.latitude: " +
          lntlngBounds.southwest.latitude.toString());
      print("🚨 southwest.longitude: " +
          lntlngBounds.southwest.longitude.toString());
      print("🚨 northeast.latitude: " +
          lntlngBounds.northeast.latitude.toString());
      print("🚨 northeast.longitude: " +
          lntlngBounds.northeast.longitude.toString());
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
                zoom: 13,
              ),
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
                _goToCurrentPosition();
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
            ),
          ),
        )
      ],
    );
  }
}

// I/flutter (13306): 🚨 southwest.latitude: 37.24570368093961
// I/flutter (13306): 🚨 southwest.longitude: 127.01033771038055
// I/flutter (13306): 🚨 northeast.latitude: 37.313451887073825
// I/Counters(13306): exceeded sample count in FrameTime
// I/flutter (13306): 🚨 northeast.longitude: 127.07213547080755

