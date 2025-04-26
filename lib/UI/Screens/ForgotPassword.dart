import 'package:flutter/material.dart';
import 'package:mobile_app_1/UI/Screens/EmailSentScreen.dart';
import 'package:mobile_app_1/UI/Screens/SignIn.dart';

class ForgotPassword extends StatefulWidget {
  final String adresseDepot;
  final List<String> adressePoubelle;
  const ForgotPassword({
    Key? key,
    required this.adresseDepot,
    required this.adressePoubelle,
  }) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _formKey = GlobalKey<FormState>();
  late String _email = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Container(
              margin: const EdgeInsets.only(top: 30),
              child: Column(
                children: [
                  Image.asset(
                    "lib/UI/Assets/Images/logo_png.png",
                    height: 70,
                    width: 100,
                  ),
                  const SizedBox(height: 40.0),
                  const Text(
                    "Mot de passe oublié ?",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      fontFamily: 'Poppins',
                      color: Color.fromARGB(255, 33, 130, 97),
                    ),
                  ),
                  Container(
                    width: 300,
                    alignment: Alignment.center,
                    margin: const EdgeInsets.only(top: 30, right: 10, left: 10),
                    child: const Text(
                      "Pas d’inquiétude ! Entrez votre email enregistré ci-dessous pour recevoir les instructions.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Poppins',
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 50, left: 20, right: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          decoration: const InputDecoration(
                            labelText: "Adresse email",
                            labelStyle: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'Poppins',
                              color: Color.fromARGB(200, 51, 51, 51),
                            ),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          onChanged: (input) {
                            // handle email input changes
                          },
                          validator: (input) {
                            if (input!.isEmpty) {
                              return "Veuillez saisir votre adresse email";
                            }
                            if (!input.contains('@')) {
                              return "Veuillez saisir une adresse email valide";
                            }
                            return null;
                          },
                          onSaved: (input) => _email = input!,
                        ),
                        const SizedBox(height: 50.0),
                        Center(
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  "Vous vous souvenez du mot de passe ?",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'Poppins',
                                    color: Color.fromARGB(200, 51, 51, 51),
                                  ),
                                ),
                                TextButton(
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
                                    "Se connecter",
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'Poppins',
                                      color: Color.fromARGB(255, 33, 130, 97),
                                    ),
                                  ),
                                ),
                              ]),
                        ),
                        const SizedBox(height: 20.0),
                        Center(
                          child: Container(
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
                                  if (_formKey.currentState!.validate()) {
                                    _formKey.currentState!
                                        .save(); // Enregistre le champ _email
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => EmailSent(
                                          adresseDepot: widget.adresseDepot,
                                          adressePoubelle:
                                              widget.adressePoubelle,
                                          email:
                                              _email, // Maintenant il est bien défini
                                        ),
                                      ),
                                    );
                                  }
                                },
                                child: const Text(
                                  "Réinitialiser le mot de passe",
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
                        ),
                        const SizedBox(height: 20.0),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
