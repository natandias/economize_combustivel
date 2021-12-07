import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as latLng;
import 'package:ionicons/ionicons.dart';

class LocationMap extends StatelessWidget {
  final double latitude;
  final double longitude;
  final void Function() goBack;

  const LocationMap(
      {Key? key,
      required this.latitude,
      required this.longitude,
      required this.goBack})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      ElevatedButton(
        style:
            ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 16)),
        onPressed: goBack,
        child: const Text(
          'Voltar',
          style: TextStyle(color: Colors.white),
        ),
      ),
      Expanded(
        child: FlutterMap(
          options: MapOptions(
            center: latLng.LatLng(latitude, longitude),
            zoom: 16.0,
          ),
          layers: [
            TileLayerOptions(
                urlTemplate:
                    "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                subdomains: ['a', 'b', 'c']),
            MarkerLayerOptions(
              markers: [
                Marker(
                  width: 80.0,
                  height: 20.0,
                  point: latLng.LatLng(latitude, longitude),
                  builder: (ctx) => const Icon(
                    Ionicons.pin,
                    color: Colors.red,
                    size: 40.0,
                  ),
                ),
              ],
            ),
          ],
        ),
      )
    ]);
  }
}
