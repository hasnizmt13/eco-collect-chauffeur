import 'dart:async';
import '../Widgets/CostumNavBar.dart';

import 'package:geocoding/geocoding.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({
    Key? key,
    required this.routeData,
    required this.userData,
    required this.adresseDepot,
    required this.adressePoubelle,
  }) : super(key: key);
  final Map<String, dynamic> routeData;
  final Map<String, dynamic> userData;
  final String adresseDepot;
  final List<String> adressePoubelle;

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {

  late GoogleMapController mapController;
  Map<MarkerId, Marker> markers = {};
  Set<Polyline> polylines = {};
  late LatLng depotCoordinate = const LatLng(36.737232, 3.086472);
  List<LatLng> poubelleCoordinates = [];
  List<LatLng> polylineCoordinates = [];

  PolylinePoints polylinePoints = PolylinePoints();
  String googleAPiKey = dotenv.env['API_KEY'] ?? '';

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _getCoordinates();
  }

  Future<void> _getCoordinates() async {
    try {
      // Convert depot address to coordinates
      List<Location> depotLocations =
          await locationFromAddress(widget.adresseDepot);
      if (depotLocations.isNotEmpty) {
        depotCoordinate = LatLng(
            depotLocations.first.latitude, depotLocations.first.longitude);
      }

      // Convert poubelle addresses to coordinates
      for (String adresse in widget.adressePoubelle) {
        List<Location> locations = await locationFromAddress(adresse);
        if (locations.isNotEmpty) {
          poubelleCoordinates
              .add(LatLng(locations.first.latitude, locations.first.longitude));
        }
      }

      // Draw the route
      await _createPolylines();

      setState(() {
        isLoading = false; // Mark loading as completed
      });
    } catch (e) {
      print('Error occurred while getting coordinates: $e');
      setState(() {
        isLoading = false; // Mark loading as completed even in case of error
      });
    }
  }

  Future<void> _createPolylines() async {
    if (poubelleCoordinates.isNotEmpty) {
      // Add the route from depot to the first poubelle
      await _addPolyline(depotCoordinate, poubelleCoordinates.first);

      // Add the routes between the poubelles
      for (int i = 0; i < poubelleCoordinates.length - 1; i++) {
        await _addPolyline(poubelleCoordinates[i], poubelleCoordinates[i + 1]);
      }

      // Add the route from the last poubelle to the depot
      await _addPolyline(poubelleCoordinates.last, depotCoordinate);
    }
  }

  Future<void> _addPolyline(LatLng from, LatLng to) async {
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

    if (widget.adresseDepot.isEmpty || widget.adressePoubelle.isEmpty) {
      print('No route available');
      return;
    }


    String origin = formatAddress(widget.adresseDepot);
    print('Origin: $origin');
    String destination = formatAddress(widget.adresseDepot);
    print('Destination: $destination');

    // Create a list of waypoints excluding the last address
    List<String> waypointsList = List.from(widget.adressePoubelle);
 //   String waypoints = 'optimize:true|' + waypointsList.map((address) => formatAddress(address)).join('|');
    String waypoints =
        waypointsList
            .map((address) => address.trim().replaceAll(RegExp(r',\s*,+'), '')) // supprime les ", ,"
            .where((a) => a.isNotEmpty) // évite les adresses vides
            .map(formatAddress)
            .join('|');

    print('widget.adressePoubelle: ${widget.adressePoubelle}');

    print('Waypoints: $waypoints');

    String googleMapsUrl =
        'https://www.google.com/maps/dir/?api=1&origin=$origin&destination=$destination&waypoints=$waypoints&travelmode=driving';
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
              initialCameraPosition: CameraPosition(
                target: depotCoordinate,
                zoom: 14,
              ),
              markers: {
                Marker(
                  markerId: const MarkerId('depot'),
                  position: depotCoordinate,
                  icon: BitmapDescriptor.defaultMarkerWithHue(
                      BitmapDescriptor.hueRed),
                  infoWindow: InfoWindow(
                    title: 'Dépôt',
                    snippet: widget.adresseDepot,
                  ),
                ),
                ...poubelleCoordinates.map(
                  (coordinate) => Marker(
                    markerId: MarkerId(coordinate.toString()),
                    position: coordinate,
                    icon: BitmapDescriptor.defaultMarkerWithHue(
                        BitmapDescriptor.hueBlue),
                    infoWindow: InfoWindow(
                      title: 'Poubelle',
                      snippet: widget.adressePoubelle[
                          poubelleCoordinates.indexOf(coordinate)],
                    ),
                  ),
                ),
              }.toSet(),
              polylines: polylines,
              onMapCreated: (GoogleMapController controller) {
                mapController = controller;
              },
            ),
            Positioned(
              width: 200,
              bottom: 20,
              left: 10,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    side:
                        const BorderSide(color: Color.fromRGBO(1, 113, 75, 1)),
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                ),
                onPressed: _launchGoogleMapsNavigation,
                child: const Text(
                  'Démarrer la navigation',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Poppins',
                    color: Color.fromRGBO(1, 113, 75, 1),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CostumNavBar(
        index: 1,
        routeData: widget.routeData,
        userData: widget.userData,
      ),
    );
  }
}
