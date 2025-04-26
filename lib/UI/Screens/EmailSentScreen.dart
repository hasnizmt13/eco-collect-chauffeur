import 'package:flutter/material.dart';

import 'SignIn.dart';

class EmailSent extends StatefulWidget {
  final String adresseDepot;
  final List<String> adressePoubelle;
  final String email;

  const EmailSent({
    Key? key,
    required this.adresseDepot,
    required this.adressePoubelle,
    required this.email

  }) : super(key: key);

  @override
  State<EmailSent> createState() => _EmailSent();
}

class _EmailSent extends State<EmailSent> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Container(
                margin: const EdgeInsets.only(top: 30, right: 10, left: 10),
                child: Column(
                  children: [
                    Image.asset(
                      "lib/UI/Assets/Images/logo_png.png",
                      height: 70,
                      width: 100,
                    ),
                    const SizedBox(height: 70.0),
                    const Text(
                      "Email envoyé !",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        fontFamily: 'Poppins',
                        color: Color.fromARGB(255, 33, 130, 97),
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    const Text(
                      "Nous avons envoyé un lien de réinitialisation du mot de passe à",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Poppins',
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      widget.email,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins',
                        color: Colors.black,
                      ),
                    ),
                    Container(
                      margin:
                          const EdgeInsets.only(top: 50, left: 20, right: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 50.0),
                          const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Vous n’avez rien reçu ?",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'Poppins',
                                    color: Color.fromARGB(200, 51, 51, 51),
                                  ),
                                ),
                                TextButton(
                                  onPressed: null,
                                  child: Text(
                                    "Renvoyer",
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'Poppins',
                                      color: Color.fromARGB(255, 33, 130, 97),
                                    ),
                                  ),
                                ),
                              ]),
                          const SizedBox(height: 20.0),
                          Center(
                            child: SizedBox(
                              height: 50,
                              width: 300,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25.0),
                                  ),
                                  backgroundColor:
                                      const Color.fromARGB(255, 33, 130, 97),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SignIn(
                                            adresseDepot: widget.adresseDepot,
                                            adressePoubelle:
                                                widget.adressePoubelle)),
                                  );
                                },
                                child: const Text(
                                  "Retour à la connexion",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w900,
                                    fontFamily: 'Poppins',
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20.0),
                          const Center(
                            child: TextButton(
                              onPressed: null,
                              child: Text(
                                "Nous contacter",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Poppins',
                                  color: Color.fromARGB(255, 33, 130, 97),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
