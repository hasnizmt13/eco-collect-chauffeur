import 'dart:convert';


import 'package:flutter/material.dart';
import '../Widgets/CostumNavBar.dart';
import 'ProblemReportedScreen.dart';

import 'ProblemReportedScreen.dart';
import 'package:http/http.dart' as http;

class ReportProblemScreen extends StatefulWidget {
  final Map<String, dynamic> routeData;
  final Map<String, dynamic> userData;
  const ReportProblemScreen(
      {Key? key, required this.userData, required this.routeData})
      : super(key: key);

  @override
  _ReportProblemScreenState createState() => _ReportProblemScreenState();
}

class _ReportProblemScreenState extends State<ReportProblemScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _subject;
  late String _description;


  Future<void> _sendReclamation() async {

    final url = Uri.parse('https://refactored-zebra-rxpxgr695vjcwjj7-5000.app.github.dev/api/contact');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "idUser": widget.userData['id'],
        "titre": _subject,
        "message": _description,
      }),
    );

    if (response.statusCode == 200) {
      print('Réclamation envoyée avec succès');
    } else {
      print('Erreur lors de l\'envoi de la réclamation : ${response.statusCode}');
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CostumNavBar(
          index: 0, routeData: widget.routeData, userData: widget.userData),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.only(top: 40, bottom: 10),
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
                      "Signaler un problème",
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                          fontSize: 21),
                    ),
                  ],
                ),
              ),
              Container(
                margin:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 50),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: const InputDecoration(
                          hintText: "Raison de la réclamation...",
                          hintStyle: TextStyle(
                              color: Color.fromRGBO(51, 51, 51, 0.74),
                              fontSize: 14),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Veuillez entrer le motif de votre réclamation';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _subject = value!;
                        },
                      ),
                      const SizedBox(
                        height: 35,
                      ),
                      TextFormField(
                        maxLines: 8,
                        decoration: InputDecoration(
                          hintText: "Décrivez votre problème en détail...",
                          hintStyle: const TextStyle(
                              color: Color.fromRGBO(51, 51, 51, 0.74),
                              fontSize: 14),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Veuillez entrer la description de votre problème';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _description = value!;
                        },
                      ),
                      const SizedBox(
                        height: 35,
                      ),
                      Center(
                        child: SizedBox(
                          width: 230,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              backgroundColor:
                                  const Color.fromRGBO(1, 113, 75, 1),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25.0),
                              ),
                            ),
                            child: const Text(
                              'Envoyer',
                              style: TextStyle(
                                  letterSpacing: 0.8,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                  fontSize: 16),
                            ),
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();
                                await _sendReclamation();

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ProplemReportedScreen(
                                              routeData: widget.routeData,
                                              userData: widget.userData)),
                                );
                              }
                            },
                          ),
                        ),
                      ),
                    ],
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
