import 'package:flutter/material.dart';

import '../Widgets/CostumNavBar.dart';
import '../Widgets/TaskCard.dart';

class HistoriquesScreen extends StatefulWidget {

  const HistoriquesScreen({Key? key, required this.routeData,required this.userData}) : super(key: key);
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
    // TODO: implement initState
    listOfMap = [
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

    // Mettre à jour le statut de chargement
    isloading = false;
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _listOfTasksWidgets = List.generate(
        listOfMap.length,
        (index) => TaskCard(
            adresseDepot: "${listOfMap[index]["adresse"]}",
            adressePoubelle:listOfMap[index]["poubelleAdresses"] ,
            date: listOfMap[index]["dateDebut"].substring(0, 10),
            title: listOfMap[index]["title"],
            startTime: listOfMap[index]["dateDebut"].substring(11, 16) + " PM",
            endTime: listOfMap[index]["dateFin"].substring(11, 16) + " PM" ,
            etat: listOfMap[index]["etat"],
            isTypee: true,
        routeData: widget.routeData,
        userData: widget.userData,));

    return Scaffold(
      body: isloading
          ? const Center(
              child: CircularProgressIndicator(
              color: Color.fromARGB(255, 77, 166, 36),
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
                          "Historiques",
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
                              hintText: 'Search',
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
                            color: Color.fromARGB(255, 77, 166, 36),
                          ),
                        ),
                      ],
                    ),
                  ),
                  ..._listOfTasksWidgets,
                ],
              ),
            ),
      bottomNavigationBar: CostumNavBar(index: 2, routeData: widget.routeData,userData: widget.userData,),
    );
  }
}
