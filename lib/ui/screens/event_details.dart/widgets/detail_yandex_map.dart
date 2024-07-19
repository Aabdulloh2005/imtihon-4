import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

class DetailYandexMap extends StatelessWidget {
  final Point point;
  const DetailYandexMap({
    super.key,
    required this.point,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: SizedBox(
        width: double.infinity,
        height: 300,
        child: YandexMap(
          // ignore: prefer_collection_literals
          gestureRecognizers: Set()
            ..add(Factory<EagerGestureRecognizer>(
                () => EagerGestureRecognizer())),
          onMapCreated: (controller) {
            controller.moveCamera(
              CameraUpdate.newCameraPosition(
                CameraPosition(
                  target: point,
                  zoom: 17,
                ),
              ),
            );
          },
          mapObjects: [
            PlacemarkMapObject(
              mapId: const MapObjectId('event_location'),
              point: point,
              icon: PlacemarkIcon.single(
                PlacemarkIconStyle(
                  scale: 0.2,
                  image: BitmapDescriptor.fromAssetImage(
                      "assets/images/place.png"),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
