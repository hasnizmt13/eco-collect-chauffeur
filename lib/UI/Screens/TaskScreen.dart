import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import '../Widgets/CostumNavBar.dart';
import '../Widgets/AdresseCard.dart';
import 'ReportProblemScreen.dart';

class TaskScreen extends StatefulWidget {
  const TaskScreen({
    Key? key,
    required this.title,
    required this.date,
    required this.startTime,
    required this.estimatedEndTime,
    required this.adresseDepot,
    required this.adressePoubelle,
    required this.routeData,
    required this.userData,
  }) : super(key: key);

  final String title;
  final String date;
  final String startTime;
  final String estimatedEndTime;
  final String adresseDepot;
  final List<String> adressePoubelle;
  final Map<String, dynamic> routeData;
  final Map<String, dynamic> userData;

  @override
  _TaskScreenState createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  late GoogleMapController mapController;
  LatLng? depotCoordinate;
  List<LatLng> poubelleCoordinates = [];
  List<LatLng> polylineCoordinates = [];
  Set<Polyline> polylines = {};
  bool isLoading = true;
  String googleAPiKey = "";

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
    if (depotCoordinate != null && poubelleCoordinates.isNotEmpty) {
      // Add the route from depot to the first poubelle
      await _addPolyline(depotCoordinate!, poubelleCoordinates.first);

      // Add the routes between the poubelles
      for (int i = 0; i < poubelleCoordinates.length - 1; i++) {
        await _addPolyline(poubelleCoordinates[i], poubelleCoordinates[i + 1]);
      }

      // Add the route from the last poubelle to the depot
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
                      "lib/UI/Assets/Images/logo_png.png",
                      height: 60,
                      width: 120,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    const Text(
                      "Task details",
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
                width: screenWidth / 1.2,
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
                                  "Estimated End Time",
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
                                  Text(
                                    "${widget.userData["numPermis"]}",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: Color.fromRGBO(14, 14, 14, 1),
                                        fontSize: 12),
                                  ),
                                  Text(
                                    widget.date,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: Color.fromRGBO(14, 14, 14, 1),
                                        fontSize: 12),
                                  ),
                                  Text(
                                    widget.startTime,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: Color.fromRGBO(1, 113, 75, 1),
                                        fontSize: 12),
                                  ),
                                  Text(
                                    widget.estimatedEndTime,
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
                                "Votre mission d'aujourd'hui c'est le ramassage dans ces adresses ",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Color.fromRGBO(14, 14, 14, 1),
                                    fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "0%",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 14),
                            ),
                            Slider(
                              value: 0,
                              min: 0,
                              max: 100,
                              divisions: 100,
                              activeColor: const Color.fromRGBO(1, 113, 75, 1),
                              inactiveColor:
                                  const Color.fromARGB(130, 51, 51, 51),
                              onChanged: (double value) {},
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 15,
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
                                      BitmapDescriptor.hueRed),
                                  infoWindow: InfoWindow(
                                    title: 'Depot',
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
                        const SizedBox(
                          height: 20,
                        ),
                        Center(
                          child: SizedBox(
                            width: 250,
                            child: MaterialButton(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              color: const Color.fromRGBO(1, 113, 75, 1),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25.0),
                              ),
                              child: const Text(
                                'Marquez comme Terminé',
                                style: TextStyle(
                                    letterSpacing: 0.8,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                    fontSize: 16),
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Center(
                          child: SizedBox(
                            width: 230,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                backgroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  side: const BorderSide(
                                      color: Color.fromRGBO(1, 113, 75, 1)),
                                  borderRadius: BorderRadius.circular(25.0),
                                ),
                              ),
                              child: const Text(
                                'Signaler un problème',
                                style: TextStyle(
                                    letterSpacing: 0.8,
                                    fontWeight: FontWeight.w600,
                                    color: Color.fromRGBO(1, 113, 75, 1),
                                    fontSize: 16),
                              ),
                              onPressed: () {
                                Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            ReportProblemScreen(
                                                routeData: widget.routeData,
                                                userData: widget.userData)));
                              },
                            ),
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
              Container(
                width: screenWidth / 1.2,
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      child: const Text(
                        "  Adresse de Dépots",
                        style: TextStyle(
                            fontWeight: FontWeight.w900,
                            color: Colors.black,
                            fontSize: 19),
                      ),
                    ),
                    AdresseCard(
                      adresse: widget.adresseDepot,
                      nomRegion: 'Depot Region',
                      tauxRemplissage: 'N/A',
                      etat: 'N/A',
                      isTypee: false,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: const Text(
                        "  Adresses des Poubelles",
                        style: TextStyle(
                            fontWeight: FontWeight.w900,
                            color: Colors.black,
                            fontSize: 19),
                      ),
                    ),
                    ...widget.adressePoubelle.map((adresse) {
                      return AdresseCard(
                        adresse: adresse,
                        nomRegion: 'Poubelle Region',
                        tauxRemplissage: 'N/A',
                        etat: 'N/A',
                        isTypee: false,
                      );
                    }).toList(),
                    const SizedBox(height: 20),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: CostumNavBar(
        index: 0,
        routeData: widget.routeData,
        userData: widget.userData,
      ),
    );
  }
}
