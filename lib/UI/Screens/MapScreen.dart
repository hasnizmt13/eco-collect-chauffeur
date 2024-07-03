import 'dart:async';
import '../Widgets/CostumNavBar.dart';

import 'package:geocoding/geocoding.dart';
import 'package:flutter/material.dart';

import 'package:google_directions_api/google_directions_api.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_directions_api/google_directions_api.dart' as directions_api;
import 'package:url_launcher/url_launcher.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key, required this.routeData}) : super(key: key);
  final Map<String, dynamic> routeData;
  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController mapController;
  LatLng _center = const LatLng(36.737232, 3.086472);
  Map<MarkerId, Marker> markers = {};
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();
  String googleAPiKey = "API_"; // Replace with your API key
  late String depotAddress;
  late List<String> poubelleAddresses;

  @override
  void initState() {
    super.initState();
    DirectionsService.init(googleAPiKey);
    depotAddress = widget.routeData['data']['routes'][0]['route'][0]['from'];
    poubelleAddresses = List<String>.from(widget.routeData['data']['routes'][0]['route'].map((segment) => segment['to']));
    _initializeCenter(); // Initialize _center with depot coordinates
    getPolylineFromAPI(widget.routeData); // Utilisez les données de l'API dès le démarrage
  }

  Future<void> _initializeCenter() async {
    List<Location> depotLocations = await locationFromAddress(depotAddress);
    if (depotLocations.isNotEmpty) {
      setState(() {
        _center = LatLng(depotLocations.first.latitude, depotLocations.first.longitude);
      });
    }
  }

  void getPolylineFromAPI(Map<String, dynamic> data) async {
    if (data.isNotEmpty && data['status'] == 'success') {
      List<dynamic> routeSegments = data['data']['routes'][0]['route'];
      polylineCoordinates.clear(); // Clear existing polylineCoordinates
      markers.clear(); // Clear existing markers

      LatLng? previousLatLng;

      for (var segment in routeSegments) {
        String formattedFrom = formatAddress(segment['from']);
        String formattedTo = formatAddress(segment['to']);

        List<Location> fromLocations = await locationFromAddress(formattedFrom);
        List<Location> toLocations = await locationFromAddress(formattedTo);

        if (fromLocations.isNotEmpty && toLocations.isNotEmpty) {
          LatLng fromLatLng = LatLng(fromLocations.first.latitude, fromLocations.first.longitude);
          LatLng toLatLng = LatLng(toLocations.first.latitude, toLocations.first.longitude);

          // Obtenez des directions précises entre les deux points
          if (previousLatLng != null) {
            await _getDirections(previousLatLng, fromLatLng);
          }

          previousLatLng = toLatLng;

          // Ajoutez des marqueurs pour les emplacements de départ et d'arrivée
          _addMarker(fromLatLng, 'from_$formattedFrom', BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue), segment['from']);
          _addMarker(toLatLng, 'to_$formattedTo', BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed), segment['to']);
        }
      }

      if (previousLatLng != null) {
        // Reliez le dernier point de l'itinéraire au point initial pour boucler le circuit
        LatLng initialLatLng = polylineCoordinates.first;
        await _getDirections(previousLatLng, initialLatLng);
      }

      _addPolyLine(); // Tracez la polyline
    } else {
      print('Failed to load route from API: ${data['message']}');
    }
  }

  Future<void> _getDirections(LatLng from, LatLng to) async {
    final directions = DirectionsService();
    final request = DirectionsRequest(
      origin: '${from.latitude},${from.longitude}',
      destination: '${to.latitude},${to.longitude}',
      travelMode: directions_api.TravelMode.driving,
    );

    directions.route(request, (DirectionsResult response, DirectionsStatus? status) {
      if (status == DirectionsStatus.ok) {
        final route = response.routes!.first;
        final leg = route.legs!.first;

        for (final step in leg.steps!) {
          final startLocation = step.startLocation;
          final endLocation = step.endLocation;

          polylineCoordinates.add(LatLng(startLocation!.latitude, startLocation.longitude));
          polylineCoordinates.add(LatLng(endLocation!.latitude, endLocation.longitude));
        }
        setState(() {});
      } else {
        print('Directions API Error: $status');
      }
    });
  }

  void _onMapCreated(GoogleMapController controller) async {
    mapController = controller;

    // Wait a bit before centering the map
    await Future.delayed(const Duration(seconds: 1));

    // Center map on depot location
    mapController.animateCamera(CameraUpdate.newLatLngZoom(_center, 14.0));
  }

  _addMarker(LatLng position, String id, BitmapDescriptor descriptor, String title) {
    MarkerId markerId = MarkerId(id);
    Marker marker = Marker(
      markerId: markerId,
      icon: descriptor,
      position: position,
      infoWindow: InfoWindow(
        title: title,
      ),
    );
    markers[markerId] = marker;
  }

  _addPolyLine() {
    PolylineId id = const PolylineId("poly");
    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.red,
      points: polylineCoordinates,
      width: 5,
    );
    polylines[id] = polyline;
    setState(() {});
  }

  String formatAddress(String address) {
    return address.replaceAll(' ', '+');
  }

  void _launchGoogleMapsNavigation() async {
    if (depotAddress.isEmpty || poubelleAddresses.isEmpty) {
      print('No route available');
      return;
    }

    String waypoints = poubelleAddresses.join('|');
    String googleMapsUrl = 'https://www.google.com/maps/dir/?api=1&origin=$depotAddress&destination=${poubelleAddresses.last}&waypoints=$waypoints&travelmode=driving';

    if (await canLaunch(googleMapsUrl)) {
      await launch(googleMapsUrl);
    } else {
      throw 'Could not launch $googleMapsUrl';
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
                initialCameraPosition: CameraPosition(
                  target: _center,
                  zoom: 14.0,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: _launchGoogleMapsNavigation,
              child: const Text('Start Navigation in Google Maps'),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CostumNavBar(index: 1, routeData: widget.routeData),
    );
  }
}
