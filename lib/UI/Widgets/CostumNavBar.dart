import 'package:flutter/material.dart';
import '../Screens/TaskScreen.dart';
import '../Screens/MapScreen.dart';
import '../Screens/HistoriquesScreen.dart';
import '../Screens/ProfileScreen.dart';
import 'package:intl/intl.dart';


class CostumNavBar extends StatelessWidget {
  const CostumNavBar(
      {Key? key,
      required this.index,
      required this.routeData,
      required this.userData})
      : super(key: key);
  final int index;
  final Map<String, dynamic> routeData;
  final Map<String, dynamic> userData;

  List<Widget> _listOfScreens(BuildContext context) {
    List<String> poubelleAddresses = [];
    String depotAddress = '';

    DateTime now = DateTime.now();
    String todayDate = DateFormat('yyyy-MM-dd').format(now);

    DateTime startTime = DateTime(now.year, now.month, now.day, 8, 0);

    int totalDurationInSeconds = routeData['data']['total_duree'];

    DateTime estimatedEndTime = startTime.add(Duration(seconds: totalDurationInSeconds));

    String formattedStartTime = DateFormat('HH:mm').format(startTime);
    String formattedEstimatedEndTime = DateFormat('HH:mm').format(estimatedEndTime);

    if (routeData.isNotEmpty &&
        routeData['data'] != null &&
        routeData['data']['routes'] != null &&
        routeData['data']['routes'].isNotEmpty) {
      depotAddress = routeData['data']['routes'][0]['route'][0]['from'];
      poubelleAddresses = List<String>.from(routeData['data']['routes'][0]
              ['route']
          .map((segment) => segment['to']));

      if (poubelleAddresses.isNotEmpty) {
        poubelleAddresses =
            poubelleAddresses.sublist(0, poubelleAddresses.length - 1);
      }
    }
    return [
      TaskScreen(
          title: 'Mission du jour',
          date: todayDate,
          startTime: formattedStartTime,
          estimatedEndTime: formattedEstimatedEndTime,
          adresseDepot: depotAddress,
          adressePoubelle: poubelleAddresses,
          routeData: routeData,
          userData: userData
       ),
      MapScreen(
        routeData: routeData,
        userData: userData,
        adresseDepot: depotAddress,
        adressePoubelle: poubelleAddresses,
      ),
      HistoriquesScreen(
        routeData: routeData,
        userData: userData,
      ),
      ProfileScreen(
        image: "lib/UI/Assets/Images/img_5.png",
        userData: userData,
        routeData: routeData,
        adresseDepot: depotAddress,
        adressePoubelle: poubelleAddresses,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 63,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30.0),
          topRight: Radius.circular(30.0),
        ),
        child: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
              icon:
                  Icon(index == 0 ? Icons.home : Icons.home_outlined, size: 27),
              backgroundColor: const Color.fromRGBO(1, 113, 75, 1),
              label: "",
            ),
            BottomNavigationBarItem(
              icon: Icon(index == 1 ? Icons.map : Icons.map_outlined, size: 27),
              backgroundColor: const Color.fromRGBO(1, 113, 75, 1),
              label: "",
            ),
            BottomNavigationBarItem(
              icon: Icon(index == 2 ? Icons.archive : Icons.archive_outlined,
                  size: 27),
              backgroundColor: Color.fromRGBO(1, 113, 75, 1),
              label: "",
            ),
            BottomNavigationBarItem(
              icon: Icon(
                  index == 3 ? Icons.person : Icons.perm_identity_outlined,
                  size: 27),
              backgroundColor: const Color.fromRGBO(1, 113, 75, 1),
              label: "",
            ),
          ],
          onTap: (value) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => _listOfScreens(context)[value]),
            );
          },
          showUnselectedLabels: false,
          showSelectedLabels: false,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white,
          backgroundColor: const Color.fromRGBO(1, 113, 75, 1),
          currentIndex: index,
        ),
      ),
    );
  }
}
