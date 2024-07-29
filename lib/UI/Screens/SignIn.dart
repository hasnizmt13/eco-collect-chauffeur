import 'package:flutter/material.dart';
import 'package:mobile_app_1/UI/Screens/MapScreen.dart';
import 'ForgotPassword.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class SignIn extends StatefulWidget {
  final String adresseDepot;
  final List<String> adressePoubelle;

  const SignIn({
    Key? key,
    required this.adresseDepot,
    required this.adressePoubelle,
  }) : super(key: key);

  @override
  State<SignIn> createState() => _SignIn();
}

class _SignIn extends State<SignIn> {
  bool _obscureText = true;
  bool _isChecked = false;
  bool _isloading = false;
  final _formKey = GlobalKey<FormState>();
  late String _email, _password;
  final List<String> addressesn = [
    '1 Avenue du Docteur Saadane, 16000 Alger',
    'Place des Martyrs, 16000 Alger',
    'Parc de la Liberté, 16000 Alger',
    'Jardin d\'Essai du Hamma, Rue Mohamed Belouizdad, 16015 Alger',
    'Basilique Notre-Dame d\'Afrique, Rue Belkacem Bettoua, 16000 Alger',
    'Aéroport Houari Boumediene, Dar El Beida, 16033 Alger',
    'Rue Didouche Mourad, 16000 Alger',
    'Musée National des Beaux-Arts d\'Alger, Rue Mohamed Belouizdad, 16015 Alger',
    'Hôtel El Aurassi, 2 Boulevard Frantz Fanon, 16000 Alger',
    '12 Rue Docteur Cherif Saadane, Alger Centre, 16000 Alger',
    'Boulevard Mohamed Khemisti, Alger Centre, 16000 Alger',
    'Rue Larbi Ben M\'Hidi, Alger Centre, 16000 Alger',
    'Avenue Pasteur, Alger Centre, 16000 Alger',
    'Boulevard Ernesto Che Guevara, Casbah, 16000 Alger',
    '16 Avenue Victor Hugo, Sidi M\'Hamed, 16000 Alger',
    'Rue Mohamed Tebib, Alger Centre, 16000 Alger',
    'Boulevard Frantz Fanon, Alger Centre, 16000 Alger',
    'Rue des Frères Berrezouane, Alger Centre, 16000 Alger',
    'Rue Hamani Arezki, Alger Centre, 16000 Alger'
  ];

  Future<Map<String, dynamic>> fetchRouteData() async {
    final List<String> addresses = addressesn.map((address) {
      return address.replaceAll(' ', '+');
    }).toList();
    String addressesString = addresses.join(",");
    print(addressesString);
    final url =
        "https://api-pfe-1.onrender.com/api/calculate_distance/?addresses=$addressesString&num_vehicles=4&vehicle_id=1";
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print(
            "Data fetched successfully: ${data.toString()}"); // Debugging statement
        return data;
      } else {
        print('Failed to load data from API: ${response.statusCode}');
        return {};
      }
    } catch (e) {
      print('Error occurred while fetching routes: $e');
      return {};
    }
  }

  void signIn() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _isloading = true;
      });
      try {
        final response = await http.post(
          Uri.parse('http://172.20.10.4:5000/api/authRole/loginDriver'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            'email': _email,
            'password': _password,
          }),
        );
        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          if (data['status'] == 200) {
            final user = data['data'];
            print(user);
            final routeData = await fetchRouteData();
            print(routeData);

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => MapScreen(
                  routeData: routeData,
                  userData: user,
                  adresseDepot: widget.adresseDepot,
                  adressePoubelle: widget.adressePoubelle,
                ),
              ),
            );
          }
        } else {
          // Handle errors
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Échec de la connexion')),
          );
        }
      } catch (e) {
        // Handle exceptions
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Une erreur est survenue')),
        );
      } finally {
        setState(() {
          _isloading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin:
                const EdgeInsets.only(top: 40, right: 10, left: 10, bottom: 10),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Good Morning,  ",
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w400,
                              fontFamily: 'Poppins',
                              color: Color.fromARGB(255, 19, 55, 75),
                            ),
                          ),
                          Text(
                            "Welcome back!",
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w900,
                              fontFamily: 'Poppins',
                              color: Color.fromARGB(255, 19, 55, 75),
                            ),
                          ),
                        ],
                      ),
                      Image.asset(
                        "lib/UI/Assets/Images/logo_png.png",
                        height: 60,
                        width: 120,
                      ),
                    ],
                  ),
                  Container(
                    margin:
                        const EdgeInsets.only(top: 100, right: 20, left: 20),
                    child: TextFormField(
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
                      validator: (input) {
                        if (input!.isEmpty) {
                          return 'Please enter your email';
                        }
                        if (!input.contains('@')) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                      onSaved: (input) => _email = input!,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 16, right: 20, left: 20),
                    child: TextFormField(
                      obscureText: _obscureText,
                      validator: (input) {
                        if (input!.isEmpty) {
                          return 'Please enter your Password';
                        }
                        return null;
                      },
                      onSaved: (input) => _password = input!,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        labelStyle: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Poppins',
                          color: Color.fromARGB(200, 51, 51, 51),
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
                  ),
                  const SizedBox(height: 35),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Transform.scale(
                            scale: 1,
                            child: Checkbox(
                              value: _isChecked,
                              onChanged: (value) {
                                setState(() {
                                  _isChecked = value!;
                                });
                              },
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                side: const BorderSide(
                                  color: Color.fromRGBO(1, 113, 75, 1),
                                ),
                              ),
                              activeColor: const Color.fromRGBO(1, 113, 75, 1),
                            ),
                          ),
                          const Text(
                            "Se souvenir",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'Poppins',
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const ForgotPassword()),
                          );
                        },
                        child: const Text(
                          "Mot de passe oublié ?",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Poppins',
                            color: Color.fromRGBO(1, 113, 75, 1),
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 55),
                  Center(
                    child: SizedBox(
                      width: 300,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromRGBO(1, 113, 75, 1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                        ),
                        onPressed: signIn,
                        child: _isloading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 3,
                              )
                            : const Text(
                                "Login",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w900,
                                  fontFamily: 'Poppins',
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
