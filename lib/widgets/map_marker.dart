import 'package:fluster/fluster.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:letsgotrip/_View/MainPages/map/place_detail_ad_screen.dart';
import 'package:letsgotrip/_View/MainPages/map/place_detail_screen.dart';
import 'package:letsgotrip/storage/storage.dart';
import 'package:letsgotrip/widgets/graphql_query.dart';

/// [Fluster] can only handle markers that conform to the [Clusterable] abstract class.
///
/// You can customize this class by adding more parameters that might be needed for
/// your use case. For instance, you can pass an onTap callback or add an
/// [InfoWindow] to your marker here, then you can use the [toMarker] method to convert
/// this to a proper [Marker] that the [GoogleMap] can read.
class MapMarker extends Clusterable {
  final String id;
  final LatLng position;
  final String type;
  // final String imageUrl;
  BitmapDescriptor icon;

  MapMarker(
      {Key key,
      @required this.id,
      @required this.position,
      // @required this.imageUrl,
      this.type,
      this.icon,
      isCluster = false,
      clusterId,
      pointsSize,
      childMarkerId})
      : super(
          markerId: id,
          latitude: position.latitude,
          longitude: position.longitude,
          isCluster: isCluster,
          clusterId: clusterId,
          pointsSize: pointsSize,
          childMarkerId: childMarkerId,
        );

  Marker toMarker() => Marker(
      markerId: MarkerId(id),
      position: LatLng(
        position.latitude,
        position.longitude,
      ),
      icon: icon,
      onTap: () {
        print("🚨 child: $childMarkerId");
        print("🚨 id: $id");
        print("🚨 type : $type");
        int contentsId;
        if ("$type" != "promotions") {
          seeValue("customerId").then((customerId) {
            if (childMarkerId != null) {
              contentsId = int.parse(
                  childMarkerId.substring(0, childMarkerId.indexOf(",")));
              Get.to(() => PlaceDetailScreen(
                  contentsId: contentsId, customerId: int.parse(customerId)));
            } else {
              contentsId = int.parse(id.substring(0, id.indexOf(",")));
              Get.to(() => PlaceDetailScreen(
                  contentsId: contentsId, customerId: int.parse(customerId)));
            }
          });
        } else {
          seeValue("customerId").then((customerId) {
            contentsId = int.parse(id.substring(0, id.indexOf(",")));
            Get.to(() => Query(
                options: QueryOptions(
                  document: gql(Queries.promotionsDetail),
                  variables: {
                    "customer_id": int.parse(customerId),
                    "promotions_id": contentsId,
                  },
                ),
                builder: (result, {refetch, fetchMore}) {
                  if (!result.isLoading && result.data != null) {
                    // print("🚨 promotionsDetail result : $result");

                    Map mapData = result.data["promotions_detail"][0];
                    return PlaceDetailAdScreen(
                      paramData: mapData,
                    );
                  } else {
                    return Container();
                  }
                }));
          });
        }
      });
}
