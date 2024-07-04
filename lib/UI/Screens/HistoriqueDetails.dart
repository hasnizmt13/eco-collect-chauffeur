import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';

import '../Widgets/CostumNavBar.dart';

class HistoriqueDetails extends StatefulWidget {
  const HistoriqueDetails(
      {Key? key,
        required this.title,
        required this.date,
        required this.startTime,
        required this.endTime,
        required this.adresseDepot,
        required this.adressePoubelle,
        required this.routeData})
      : super(key: key);
  final String title;
  final String date;
  final String startTime;
  final String endTime;
  final String adresseDepot;
  final List<String> adressePoubelle;
  final Map<String, dynamic> routeData;

  @override
  _HistoriqueDetailsState createState() => _HistoriqueDetailsState();
}

class _HistoriqueDetailsState extends State<HistoriqueDetails> {
  late GoogleMapController mapController;
  LatLng? depotCoordinate;
  List<LatLng> poubelleCoordinates = [];
  bool isLoading = true;
  List<LatLng> polylineCoordinates = [];
  Set<Polyline> polylines = {};
  Map<MarkerId, Marker> markers = {};
  String googleAPiKey = "";


  @override
  void initState() {
    super.initState();
    _getCoordinates();
  }

  Future<void> _getCoordinates() async {
    try {
      // Convertir l'adresse de dépôt en coordonnées
      List<Location> depotLocations = await locationFromAddress(widget.adresseDepot);
      if (depotLocations.isNotEmpty) {
        depotCoordinate = LatLng(depotLocations.first.latitude, depotLocations.first.longitude);
      }

      // Convertir les adresses des poubelles en coordonnées
      for (String adresse in widget.adressePoubelle) {
        List<Location> locations = await locationFromAddress(adresse);
        if (locations.isNotEmpty) {
          poubelleCoordinates.add(LatLng(locations.first.latitude, locations.first.longitude));
        }
      }

      // Tracez la route
      await _createPolylines();

      setState(() {
        isLoading = false; // Marquer le chargement comme terminé
      });
    } catch (e) {
      print('Error occurred while getting coordinates: $e');
      setState(() {
        isLoading = false; // Marquer le chargement comme terminé même en cas d'erreur
      });
    }
  }
  Future<void> _createPolylines() async {
    if (depotCoordinate != null && poubelleCoordinates.isNotEmpty) {
      // Ajouter le trajet de dépôt à la première poubelle
      await _addPolyline(depotCoordinate!, poubelleCoordinates.first);

      // Ajouter les trajets entre les poubelles
      for (int i = 0; i < poubelleCoordinates.length - 1; i++) {
        await _addPolyline(poubelleCoordinates[i], poubelleCoordinates[i + 1]);
      }

      // Ajouter le trajet de la dernière poubelle au dépôt
      await _addPolyline(poubelleCoordinates.last, depotCoordinate!);
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




  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    LatLng center = depotCoordinate ?? const LatLng(36.737232, 3.086472);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.only(top: 35, bottom: 10),
                child: Column(
                  children: [
                    Image.asset(
                      "lib/UI/Assets/Images/logo.png",
                      height: 60,
                      width: 120,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    const Text(
                      "Historique detail",
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                          fontSize: 21),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                width: screenWidth / 1.3,
                child: Card(
                  color: const Color.fromRGBO(240, 240, 240, 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                      Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        widget.title,
                        style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            color: Color.fromRGBO(14, 14, 14, 1),
                            fontSize: 20),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Vehicule ID",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Color.fromRGBO(51, 51, 51, 0.6),
                                  fontSize: 12),
                            ),
                            Text(
                              "Date",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Color.fromRGBO(51, 51, 51, 0.6),
                                  fontSize: 12),
                            ),
                            Text(
                              "Start Time",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Color.fromRGBO(51, 51, 51, 0.6),
                                  fontSize: 12),
                            ),
                            Text(
                              "End Time",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Color.fromRGBO(51, 51, 51, 0.6),
                                  fontSize: 12),
                            ),
                          ],
                        ),
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "6348489404",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Color.fromRGBO(14, 14, 14, 1),
                                    fontSize: 12),
                              ),
                              Text(
                                "${widget.date}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Color.fromRGBO(14, 14, 14, 1),
                                    fontSize: 12),
                              ),
                              Text(
                                "${widget.startTime}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Color.fromRGBO(1, 113, 75, 1),
                                    fontSize: 12),
                              ),
                              Text(
                                "${widget.endTime}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Color.fromRGBO(1, 113, 75, 1),
                                    fontSize: 12),
                              ),
                            ])
                      ],
                    ),
                    const Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Description : ",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Color.fromRGBO(51, 51, 51, 0.6),
                              fontSize: 12),
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Expanded(
                          child: Text(
                              "Ramassage achevé à cette adresse ",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Color.fromRGBO(14, 14, 14, 1),
                                    fontSize: 12),
                              )),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "100%",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 14),
                            ),
                            Slider(
                              value: 100,
                              min: 0,
                              max: 100,
                              divisions: 100,
                              activeColor:
                              const Color.fromRGBO(1, 113, 75, 1),
                              inactiveColor:
                              const Color.fromARGB(130, 51, 51, 51),
                              onChanged: (double value) {},
                            ),
                          ],
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          child: const Text(
                            "Adresse de Dépots",
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Color.fromRGBO(1, 113, 75, 1),
                                fontSize: 17),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            widget.adresseDepot,
                            style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Color.fromRGBO(14, 14, 14, 1),
                                fontSize: 15),
                          ),
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          child: const Text(
                            "Adresses des Poubelles",
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Color.fromRGBO(1, 113, 75, 1),
                                fontSize: 17),
                          ),
                        ),
                        ...List.generate(
                          widget.adressePoubelle.length,
                              (index) => Container(
                            alignment: Alignment.centerLeft,
                            margin: const EdgeInsets.only(top: 8),
                            child: Text(
                              " ${index+1}- ${widget.adressePoubelle[index]}",
                              style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Color.fromRGBO(14, 14, 14, 1),
                                  fontSize: 15),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          height: 300,
                          child: GoogleMap(
                            initialCameraPosition: CameraPosition(
                              target: center,
                              zoom: 10,
                            ),
                            markers: {
                              if (depotCoordinate != null)
                                Marker(
                                  markerId: const MarkerId('depot'),
                                  position: depotCoordinate!,
                                  icon: BitmapDescriptor.defaultMarkerWithHue(
                                      BitmapDescriptor.hueBlue),
                                  infoWindow: InfoWindow(
                                    title: 'Depot',
                                    snippet: widget.adresseDepot,
                                  ),
                                ),
                              ...poubelleCoordinates.map(
                                    (coordinate) => Marker(
                                  markerId: MarkerId(coordinate.toString()),
                                  position: coordinate,
                                  infoWindow: InfoWindow(
                                    title: 'Poubelle',
                                    snippet: widget.adressePoubelle[
                                    poubelleCoordinates
                                        .indexOf(coordinate)],
                                  ),
                                ),
                              ),
                            }.toSet(),
                            polylines: polylines,
                            onMapCreated: (GoogleMapController controller) {
                              mapController = controller;
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CostumNavBar(index: 2, routeData: widget.routeData),
    );
  }
}
