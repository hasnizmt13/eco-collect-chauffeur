import 'package:flutter/material.dart';

import '../Widgets/CostumNavBar.dart';

class TaskScreen extends StatelessWidget {
  const TaskScreen(
      {Key? key,
      required this.title,
      required this.date,
      required this.startTime,
      required this.estimatedEndTime,
      required this.adresseDepot,
      required this.adressePoubelle,
      required this.routeData})
      : super(key: key);
  final String title;
  final String date;
  final String startTime;
  final String estimatedEndTime;
  final String adresseDepot;
  final List<String> adressePoubelle;
  final Map<String, dynamic> routeData;

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
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
                      "Task detail",
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
                            title,
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
                                  const Text(
                                    "6348489404",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: Color.fromRGBO(14, 14, 14, 1),
                                        fontSize: 12),
                                  ),
                                  Text(
                                    "$date",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: Color.fromRGBO(14, 14, 14, 1),
                                        fontSize: 12),
                                  ),
                                  Text(
                                    "$startTime",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: Color.fromRGBO(1, 113, 75, 1),
                                        fontSize: 12),
                                  ),
                                  Text(
                                    "$estimatedEndTime",
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
                              "Votre mission d'aujourd'hui c'est le ramassage dans cette adresse ",
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
                              "0%",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 14),
                            ),
                            Slider(
                              value: 0,
                              min: 0,
                              max: 100,
                              divisions: 100,
                              activeColor:
                                  const Color.fromARGB(255, 77, 166, 36),
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
                                color: Color.fromARGB(255, 77, 166, 36),
                                fontSize: 17),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "- $adresseDepot",
                            style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Color.fromRGBO(14, 14, 14, 1),
                                fontSize: 14),
                          ),
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          child: const Text(
                            "Adresses des Poubelles",
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Color.fromARGB(255, 77, 166, 36),
                                fontSize: 17),
                          ),
                        ),
                        ...List.generate(
                          adressePoubelle.length,
                          (index) => Container(
                            alignment: Alignment.centerLeft,
                            margin: const EdgeInsets.only(top: 3),
                            child: Text(
                              "${index + 1} - ${adressePoubelle[index]}",
                              style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Color.fromRGBO(14, 14, 14, 1),
                                  fontSize: 13),
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          child: Image.asset("lib/UI/Assets/Images/map.png"),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Center(
                          child: SizedBox(
                            width: 230,
                            child: MaterialButton(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              color: Color.fromRGBO(1, 113, 75, 1),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25.0),
                              ),
                              child: Text(
                                'Mark as Done',
                                style: TextStyle(
                                    letterSpacing: 0.8,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.white,
                                    fontSize: 16),
                              ),
                              onPressed: () {
                                Navigator.pop(context);
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
            ],
          ),
        ),
      ),
      bottomNavigationBar: CostumNavBar(index: 0, routeData: routeData),
    );
  }
}
