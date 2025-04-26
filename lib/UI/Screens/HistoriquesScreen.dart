import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../Widgets/CostumNavBar.dart';
import '../Widgets/TaskCard.dart';

class HistoriquesScreen extends StatefulWidget {
  const HistoriquesScreen(
      {Key? key, required this.routeData, required this.userData})
      : super(key: key);
  final Map<String, dynamic> routeData;
  final Map<String, dynamic> userData;

  @override
  State<HistoriquesScreen> createState() => _HistoriquesScreenState();
}

class _HistoriquesScreenState extends State<HistoriquesScreen> {
  Map<String, dynamic> Tasks = {};
  List<dynamic> listOfMap = [];
  bool isloading = true;
  @override
  void initState() {
    super.initState();
    fetchHistorique();
    // TODO: implement initState
    /* listOfMap = [
      {
        "idDistributeur": "001",
        "adresse": "Rue Didouche Mourad, Alger Centre",
        "dateDebut": "2024-06-27T14:20",
        "dateFin": "2024-06-26T12:15",
        "title": "Ramassage poubelle",
        "etat": "Done",
        "poubelleAdresses": ["Rue Hassiba Ben Bouali, Alger Centre", "Rue Larbi Ben M'hidi, Alger Centre"]
      },
      {
        "idDistributeur": "002",
        "adresse": "Avenue Pasteur, Alger Centre",
        "dateDebut": "2024-06-26T11:15",
        "dateFin": "2024-06-26T12:15",
        "title": "Ramassage poubelle",
        "etat": "Done",
        "poubelleAdresses": ["Rue Emir Abdelkader, Alger Centre", "Rue Sidi Yahia, Hydra"]
      },
      {
        "idDistributeur": "003",
        "adresse": "Boulevard Mohamed V, Alger Centre",
        "dateDebut": "2024-06-25T09:45",
        "dateFin": "2024-06-26T12:15",
        "title": "Ramassage poubelle",
        "etat": "Done",
        "poubelleAdresses": ["Rue Didouche Mourad, Alger Centre", "Avenue Khelifa Boukhalfa, Alger Centre", "Rue des Frères Amrani, El Harrach", "Rue de Tripoli, Hussein Dey"]
      }
    ];
*/
    // Mettre à jour le statut de chargement
    isloading = false;
  }

  Future<void> fetchHistorique() async {
    try {
      final chauffeurId = widget.userData['id']; // id du chauffeur
      final response = await http.get(
        Uri.parse('https://refactored-zebra-rxpxgr695vjcwjj7-5000.app.github.dev/api/historiqueChauffeur?id=$chauffeurId'),
      );

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);

        listOfMap = [];

        for (var task in data) {
          // Itinéraire contient plusieurs points
          List<dynamic> itineraire = jsonDecode(task['itineraire']);
          List<String> poubelleAdresses = [];

          for (var point in itineraire) {
            try {
              List<Placemark> placemarks = await placemarkFromCoordinates(
                point['latitude'],
                point['longitude'],
              );
              if (placemarks.isNotEmpty) {
                Placemark placemark = placemarks.first;
                String adresse =
                    "${placemark.street}, ${placemark.locality}, ${placemark.country}";
                poubelleAdresses.add(adresse);
              }
            } catch (e) {
              print('Erreur de géocodage: $e');
            }
          }

          listOfMap.add({
            "idDistributeur": task['id'].toString(),
            "adresse":
                "${poubelleAdresses.isNotEmpty ? poubelleAdresses.first : ''}", // Premier point = adresse départ
            "dateDebut": task['date_debut'],
            "dateFin": task['date_fin'],
            "title": task['titre'],
            "etat": task['etat'],
            "poubelleAdresses":
                poubelleAdresses.toList(), // Les autres = poubelles
          });
        }

        setState(() {
          isloading = false;
        });
      } else {
        throw Exception('Erreur lors de la récupération de l’historique.');
      }
    } catch (e) {
      print('Erreur: $e');
      setState(() {
        isloading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _listOfTasksWidgets = List.generate(
        listOfMap.length,
        (index) => TaskCard(
              adresseDepot: "${listOfMap[index]["adresse"]}",
              adressePoubelle: listOfMap[index]["poubelleAdresses"],
              date: listOfMap[index]["dateDebut"].substring(0, 10),
              title: listOfMap[index]["title"],
              startTime:
                  listOfMap[index]["dateDebut"].substring(11, 16) + " PM",
              endTime: listOfMap[index]["dateFin"].substring(11, 16) + " PM",
              etat: listOfMap[index]["etat"],
              isTypee: true,
              routeData: widget.routeData,
              userData: widget.userData,
            ));

    return Scaffold(
      body: isloading
          ? const Center(
              child: CircularProgressIndicator(
              color: Color.fromRGBO(1, 113, 75, 1)
            ))
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.only(top: 60, bottom: 10),
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
                          "Historique",
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                              fontSize: 21),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 35),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          width: 210,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                spreadRadius: 0.5,
                                blurRadius: 1,
                                offset: const Offset(3, 3),
                              ),
                            ],
                            color: const Color.fromRGBO(242, 242, 242, 1),
                          ),
                          child: TextField(
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              fillColor: const Color.fromRGBO(242, 242, 242, 1),
                              contentPadding:
                                  const EdgeInsets.symmetric(vertical: 0),
                              prefixIcon: const Icon(
                                Icons.search,
                                size: 20,
                                color: Color.fromRGBO(51, 51, 51, 0.74),
                              ),
                              hintText: 'Rechercher',
                              hintStyle: const TextStyle(
                                color: Color.fromRGBO(51, 51, 51, 0.74),
                              ),
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.filter_list_rounded,
                            size: 30,
                            color: Color.fromRGBO(1, 113, 75, 1),
                          ),
                        ),
                      ],
                    ),
                  ),
                  ..._listOfTasksWidgets,
                ],
              ),
            ),
      bottomNavigationBar: CostumNavBar(
        index: 2,
        routeData: widget.routeData,
        userData: widget.userData,
      ),
    );
  }
}
