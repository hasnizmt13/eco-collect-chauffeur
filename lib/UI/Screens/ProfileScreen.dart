import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_app_1/UI/Screens/SignIn.dart';
import 'package:mobile_app_1/UI/Widgets/CostumNavBar.dart';
import 'package:http/http.dart' as http;


class ProfileScreen extends StatefulWidget {
  final Map<String, dynamic> routeData;
  final String image;
  final Map<String, dynamic> userData;
  final String adresseDepot;
  final List<String> adressePoubelle;
  const ProfileScreen(
      {Key? key,
      required this.image,
      required this.userData,
      required this.routeData,
        required this.adresseDepot,
        required this.adressePoubelle,})
      : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreen();
}

class _ProfileScreen extends State<ProfileScreen> {
  File? _image;

  // This is the image picker
  final _picker = ImagePicker();
  // Implementing the image picker
  Future<void> _openImagePicker() async {
    final XFile? pickedImage =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
      });
    }
  }
  Future<void> _logout() async {
    final response =
    await http.get(Uri.parse('https://refactored-zebra-rxpxgr695vjcwjj7-5000.app.github.dev/api/auth/logout'));

    if (response.statusCode == 200) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => SignIn(adresseDepot: widget.adresseDepot, adressePoubelle: widget.adressePoubelle)),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Échec de la déconnexion')),
      );
    }
  }


  bool _obscureText = true;
  bool _obscureText2 = true;
  final _formKey = GlobalKey<FormState>();
  late String _email, _password, _confirmPassword;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30),
          ),
        ),
        toolbarHeight: 245,
        backgroundColor: const Color.fromRGBO(1, 113, 75, 1),
        flexibleSpace: SafeArea(
            child: Column(
          children: [
            const SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(
                  width: 100,
                ),
                const Text(
                  "Mon Profil",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Poppins',
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  height: 10,
                  width: 100,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.logout,
                        size: 27, color: Colors.white),
                    onPressed: _logout,
                    label: const SizedBox.shrink(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(1, 113, 75, 1),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Container(
              width: 100,
              height: 100,
              child: ClipRRect(
                borderRadius: const BorderRadius.all(
                  Radius.circular(200),
                ),
                child: Image.asset(
                  widget.image,
                  fit: BoxFit.fill,
                ),
              ),
            ),
            const SizedBox(height: 5),
             Text(
              '${widget.userData['first_name']} ${widget.userData['last_name']}',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                fontFamily: 'Poppins',
                color: Colors.white,
              ),
            ),
            TextButton(
              onPressed: _openImagePicker,
              child: const Text(
                "Téléverser une image",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Poppins',
                  color: Colors.white,
                ),
              ),
            )
          ],
        )),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin:
                const EdgeInsets.only(top: 40, right: 20, left: 20, bottom: 30),
            child: Form(
              child: Column(
                children: [
                  Container(
                    margin:
                        const EdgeInsets.only(left: 20, bottom: 20, right: 20),
                    child: Column(
                      children: [
                        TextFormField(
                          initialValue: widget.userData['email'],
                          decoration: const InputDecoration(
                            labelText: 'Email',
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
                              return 'Veuillez saisir votre email';
                            }
                            if (!input.contains('@')) {
                              return 'Veuillez saisir un email valide';
                            }
                            return null;
                          },
                          onSaved: (input) => _email = input!,
                        ),
                        const SizedBox(height: 16.0),
                        TextFormField(
                          obscureText: _obscureText,
                          validator: (input) {
                            if (input!.length < 8) {
                              return 'Le mot de passe doit contenir au moins 8 caractères';
                            }
                            return null;
                          },
                          onSaved: (input) => _password = input!,
                          decoration: InputDecoration(
                            labelText: 'Mot de passe',
                            labelStyle: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Poppins',
                              color: Color.fromARGB(255, 51, 51, 51),
                            ),
                            suffixIcon: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _obscureText = !_obscureText;
                                });
                              },
                              child: Icon(
                                _obscureText
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        TextFormField(
                          obscureText: _obscureText2,
                          validator: (input) {
                            if (input!.isEmpty) {
                              return 'Veuillez confirmer votre mot de passe';
                            }
                            return null;
                          },
                          onSaved: (value) => _confirmPassword = value!,
                          decoration: InputDecoration(
                            labelText: 'Confirmez le mot de passe',
                            labelStyle: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Poppins',
                              color: Color.fromARGB(255, 51, 51, 51),
                            ),
                            suffixIcon: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _obscureText2 = !_obscureText2;
                                });
                              },
                              child: Icon(
                                _obscureText2
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Center(
                    child: Container(
                      margin: const EdgeInsets.only(top: 10),
                      child: SizedBox(
                        height: 50,
                        width: 300,
                        child: MaterialButton(
                          onPressed: () {},
                          color: const Color.fromRGBO(1, 113, 75, 1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(23.0),
                          ),
                          child: const Text(
                            "Enregistrer les modifications",
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
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: CostumNavBar(index: 3, routeData: widget.routeData,userData: widget.userData),
    );
  }
}
