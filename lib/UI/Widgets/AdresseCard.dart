import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';

class AdresseCard extends StatefulWidget {
  const AdresseCard({
    Key? key,
    required this.adresse,
    required this.nomRegion,
    required this.tauxRemplissage,
    required this.etat,
    required this.isTypee,
  }) : super(key: key);

  final String adresse;
  final String nomRegion;
  final String tauxRemplissage;
  final String etat;
  final bool isTypee;

  @override
  _AdresseCardState createState() => _AdresseCardState();
}

class _AdresseCardState extends State<AdresseCard> {
  bool isExpanded = false;
  late GoogleMapController mapController;
  LatLng? addressLocation;

  @override
  void initState() {
    super.initState();
    _initializeLocation();
  }

  Future<void> _initializeLocation() async {
    try {
      List<Location> locations = await locationFromAddress(widget.adresse);
      if (locations.isNotEmpty) {
        setState(() {
          addressLocation =
              LatLng(locations.first.latitude, locations.first.longitude);
        });
      }
    } catch (e) {
      print('Error initializing location: $e');
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isExpanded = !isExpanded;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.symmetric(vertical: 7, horizontal: 0),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 2,
              offset: const Offset(3, 3),
            ),
          ],
          color: const Color.fromRGBO(240, 240, 240, 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.nomRegion,
              style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 17,
                  color: Color.fromRGBO(1, 113, 75, 1)),
            ),
            const SizedBox(height: 5),
            Text(
              widget.adresse,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.restore_from_trash,
                        size: 19, color: Color.fromRGBO(51, 51, 51, 0.72)),
                    const SizedBox(width: 5),
                    Text(
                      widget.tauxRemplissage,
                      style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          color: Color.fromRGBO(51, 51, 51, 0.72)),
                    ),
                  ],
                ),
                widget.isTypee
                    ? Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 2, horizontal: 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: const Color.fromRGBO(1, 113, 75, 0.14),
                  ),
                  child: Text(
                    widget.etat,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                      color: widget.etat == "Pas Pleine"
                          ? const Color.fromRGBO(1, 113, 75, 1)
                          : const Color.fromRGBO(255, 0, 0, 1),
                    ),
                  ),
                )
                    : Container(),
              ],
            ),
            if (isExpanded && addressLocation != null)
              Container(
                height: 200,
                margin: const EdgeInsets.only(top: 10),
                child: GoogleMap(
                  onMapCreated: _onMapCreated,
                  initialCameraPosition: CameraPosition(
                    target: addressLocation!,
                    zoom: 14.0,
                  ),
                  markers: {
                    Marker(
                        markerId: MarkerId(widget.adresse),
                        position: addressLocation!,
                        infoWindow: InfoWindow(title: widget.adresse))
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}