
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import '../Widgets/CostumNavBar.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class MapScreen extends StatefulWidget {
  const MapScreen({Key? key, required this.routeData}) : super(key: key);
  final Map<String, dynamic> routeData;

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final startAddressController = TextEditingController();

  late GoogleMapController mapController;
  static const LatLng _center = LatLng(48.808897, 2.133712);


  Map<MarkerId, Marker> markers = {};
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();
  String googleAPiKey =
      "AIzaSyD9tpt5CiBIxms61wQ_LR8o0IqDhmoI8Ks"; // Remplacez par votre clé API


  @override
  void initState() {
    super.initState();
    getPolylineFromAPI(widget.routeData); // Utilisez les données de l'API dès le démarrage
  }

  void _onMapCreated(GoogleMapController controller) async {
    mapController = controller;
    await Future.delayed(const Duration(seconds: 1));
  }


  _addMarker(LatLng position, String id, BitmapDescriptor descriptor) {
    MarkerId markerId = MarkerId(id);
    Marker marker =
    Marker(markerId: markerId, icon: descriptor, position: position);
    markers[markerId] = marker;
  }

  _addPolyLine() {
    PolylineId id = const PolylineId("poly");
    Polyline polyline =
    Polyline(polylineId: id, color: Colors.red, points: polylineCoordinates);
    polylines[id] = polyline;
    setState(() {});
  }

  String formatAddress(String address) {
    return address.replaceAll('+', ' ');
  }
  void getPolylineFromAPI(Map<String, dynamic> data) async {
    if (data.isNotEmpty && data['status'] == 'success') {
      List<dynamic> routeSegments = data['data']['routes'][0]['route'];
      polylineCoordinates.clear(); // Clear existing polylineCoordinates
      markers.clear(); // Clear existing markers

      for (var segment in routeSegments) {
        String formattedFrom = formatAddress(segment['from']);
        String formattedTo = formatAddress(segment['to']);

        List<Location> fromLocations = await locationFromAddress(formattedFrom);
        List<Location> toLocations = await locationFromAddress(formattedTo);

        if (fromLocations.isNotEmpty && toLocations.isNotEmpty) {
          LatLng fromLatLng = LatLng(fromLocations.first.latitude, fromLocations.first.longitude);
          LatLng toLatLng = LatLng(toLocations.first.latitude, toLocations.first.longitude);

          // Add points to polylineCoordinates
          polylineCoordinates.add(fromLatLng);
          polylineCoordinates.add(toLatLng);

          // Add markers for from and to locations
          _addMarker(fromLatLng, 'from_$formattedFrom', BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue));
          _addMarker(toLatLng, 'to_$formattedTo', BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed));
        }
      }
      _addPolyLine(); // Draw the polyline
    } else {
      print('Failed to load route from API: ${data['message']}');
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: GoogleMap(
                mapType: MapType.normal,
                onMapCreated: _onMapCreated,
                markers: Set<Marker>.of(markers.values),
                polylines: Set<Polyline>.of(polylines.values),
                initialCameraPosition: const CameraPosition(
                  target: _center,
                  zoom: 14.0,
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CostumNavBar(index: 1,routeData: widget.routeData),
    );
  }
}
