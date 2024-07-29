import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Widgets/CostumNavBar.dart';

class ProplemReportedScreen extends StatefulWidget {
  final Map<String, dynamic> routeData;
  final Map<String, dynamic> userData;
  const ProplemReportedScreen(
      {Key? key, required this.userData, required this.routeData})
      : super(key: key);

  @override
  _ProplemReportedScreenState createState() => _ProplemReportedScreenState();
}

class _ProplemReportedScreenState extends State<ProplemReportedScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: CostumNavBar(
            index: 0, routeData: widget.routeData, userData: widget.userData),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.only(top: 60, bottom: 10),
                child: Column(
                  children: [
                    Image.asset("lib/UI/Assets/Images/logo_png.png",
                      height: 60,
                      width: 120,),
                    const SizedBox(
                      height: 5,
                    ),
                    const Text(
                      "Signaler un problème",
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                          fontSize: 22),
                    ),
                  ],
                ),
              ),
              Image.asset(
                "lib/UI/Assets/Images/check.png",
                height: 275,
                width: 300,
              ),
              RichText(
                textAlign: TextAlign.center,
                text: const TextSpan(
                  text: "Problème signalé",
                  style: TextStyle(
                      color: Color.fromARGB(255, 33, 130, 97), fontSize: 25),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(20), //apply padding to all four sides
                child: Text(
                  'Nous vous répondrons dans les plus brefs délais',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Poppins',
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
