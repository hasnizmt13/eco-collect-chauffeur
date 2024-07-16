import 'package:flutter/material.dart';

import '../Screens/HistoriqueDetails.dart';
class TaskCard extends StatelessWidget {
  const TaskCard({Key? key, required this.adresseDepot,required this.adressePoubelle, required this.date, required this.title, required this.startTime,
  required this.endTime, required this.etat, required this.isTypee,required this.routeData,required this.userData}) : super(key: key);
  final String adresseDepot;
  final List<String> adressePoubelle;
  final String date;
  final String title;
  final String startTime;
  final String endTime;
  final String etat;
  final bool isTypee;
  final Map<String, dynamic> routeData;
  final Map<String, dynamic> userData;

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: (){
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HistoriqueDetails(adressePoubelle:adressePoubelle ,adresseDepot: adresseDepot, title: title,date: date,startTime: startTime,endTime: endTime, routeData: routeData,userData: userData, )),
      );
    },
    child :Container(
      margin: const EdgeInsets.symmetric(vertical: 13,horizontal: 35),
      padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 20),
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
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("$adresseDepot",style: const TextStyle(fontWeight: FontWeight.w600,fontSize: 12),),
              Text("$date",style: const TextStyle(fontWeight: FontWeight.w500,fontSize: 12),)
            ],
          ),
          const SizedBox(height: 5,),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text("$title",style: const TextStyle(fontWeight: FontWeight.w700,fontSize: 17,color: Color.fromRGBO(1, 113, 75, 1)),),
            ],
          ),
          const SizedBox(height: 5,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.access_time_filled,size: 19,color: Color.fromRGBO(51, 51, 51, 0.72)),
                  const SizedBox(width: 5,),
                  Text("$startTime",style: const TextStyle(fontWeight: FontWeight.w500,fontSize: 14,color: Color.fromRGBO(51, 51, 51, 0.72)),),
                ],
              ),
              isTypee? Container(
                padding: const EdgeInsets.symmetric(vertical: 2,horizontal: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: const Color.fromRGBO(1, 113, 75, 0.14),
                ),
                child: Text("$etat",style: const TextStyle(fontWeight: FontWeight.w600,fontSize: 12,color: Color.fromRGBO(1, 113, 75, 1)),),
              ):Container(),
            ],
          ),
        ],
      ),// add your child widget here
    ),);
  }

}