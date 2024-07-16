import 'dart:async';
import '../Widgets/CostumNavBar.dart';

import 'package:geocoding/geocoding.dart';
import 'package:flutter/material.dart';

import 'package:google_directions_api/google_directions_api.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:url_launcher/url_launcher.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key, required this.routeData,required this.userData}) : super(key: key);
  final Map<String, dynamic> routeData;
  final Map<String, dynamic> userData;

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController mapController;
  LatLng _center = const LatLng(36.737232, 3.086472);
  Map<MarkerId, Marker> markers = {};
//  Map<PolylineId, Polyline> polylines = {};
  Set<Polyline> polylines = {};

  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();
  String googleAPiKey = "AIzaSyD9tpt5CiBIxms61wQ_LR8o0IqDhmoI8Ks"; // Replace with your API key
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

    //  _addPolyLine(); // Tracez la polyline
    } else {
      print('Failed to load route from API: ${data['message']}');
    }
  }

  Future<void> _getDirections(LatLng from, LatLng to) async {
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      googleAPiKey,
      PointLatLng(from.latitude, from.longitude),
      PointLatLng(to.latitude, to.longitude),
    );

    if (result.points.isNotEmpty) {
      for (var point in result.points) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      }

      setState(() {
        polylines.add(
          Polyline(
            polylineId: PolylineId(from.toString() + to.toString()),
            width: 5,
            color: Colors.blue,
            points: polylineCoordinates,
          ),
        );
      });
    }
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
      color: Colors.blue,
      points: polylineCoordinates,
      width: 5,
    );
  //  polylines[id] = polyline;
    setState(() {});
  }

  String formatAddress(String address) {
    return address
        .replaceAll(' ', '+')
        .replaceAll('\'', '%27')
        .replaceAll('é', '%C3%A9')
        .replaceAll('à', '%C3%A0')
        .replaceAll('è', '%C3%A8')
        .replaceAll('ê', '%C3%AA')
        .replaceAll('ç', '%C3%A7');
  }

  void _launchGoogleMapsNavigation() async {
    if (depotAddress.isEmpty || poubelleAddresses.isEmpty) {
      print('No route available');
      return;
    }

    String origin = formatAddress(depotAddress);
    String destination = formatAddress(poubelleAddresses.last);

    // Create a list of waypoints excluding the last address
    List<String> waypointsList = List.from(poubelleAddresses)..removeLast();
    String waypoints = waypointsList
        .map((address) => formatAddress(address))
        .join('|');

    String googleMapsUrl = 'https://www.google.com/maps/dir/?api=1&origin=$origin&destination=$destination&waypoints=$waypoints&travelmode=driving';
    print(googleMapsUrl);

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
        child: Stack(
          children: [
            GoogleMap(
              mapType: MapType.normal,
              onMapCreated: _onMapCreated,
              markers: Set<Marker>.of(markers.values),
              polylines: polylines,
              initialCameraPosition: CameraPosition(
                target: _center,
                zoom: 14.0,
              ),
            ),
            Positioned(
              top: 20,
              left: 70,
              right:70,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(1, 113, 75, 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                ),
                onPressed: _launchGoogleMapsNavigation,

                child: const Text('Start Navigation',style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Poppins',
                  color: Colors.white,
                ),),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CostumNavBar(index: 1, routeData: widget.routeData, userData: widget.userData,),
    );
  }
}