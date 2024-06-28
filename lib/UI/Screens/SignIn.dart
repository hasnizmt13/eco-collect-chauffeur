
import 'package:flutter/material.dart';
import 'package:mobile_app_1/UI/Screens/MapScreen.dart';

import '../Provider/route_data_provider.dart';
import 'ForgotPassword.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignIn();
}

class _SignIn extends State<SignIn> {
  bool _obscureText = true;
  bool _isChecked = false;
  final bool _isloading = false;
  final _formKey = GlobalKey<FormState>();
  late String _email, _password;
  final List<String> addresses = [
    '2+Rue+Alexis+de+Tocqueville,+78000+Versailles',
    'UVSQ+-+UFR+des+Sciences+-+Universite+Paris-Saclay,+45+Av.+des+3tats+Unis,+78000+Versailles',
    '67+Av.+de+Saint-Cloud,+78000+Versailles',
    'Residence+Ecla+Paris+Massy-Palaiseau',
    'Chateau+de+Versailles',
    '21+Pl.+du+Grand+Ouest,+91300+Massy',
  ];
  Future<Map<String, dynamic>> fetchRouteData() async {
    String addressesString = addresses.join(",");
    print(addressesString);
    final url = "https://api-pfe-1.onrender.com/api/calculate_distance/?addresses=$addressesString&num_vehicles=4&vehicle_id=1";
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print("Data fetched successfully: ${data.toString()}"); // Debugging statement
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
    // Ajoutez ici votre logique de connexion
    final routeData = await fetchRouteData();
    RouteDataProvider().setRouteData(routeData); // Store the route data globally


    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => MapScreen(routeData: routeData),
      ),
    );
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
                        "lib/UI/Assets/Images/logo.png",
                        height: 60,
                        width: 120,
                      ),
                    ],
                  ),
                  Container(
                    margin : const EdgeInsets.only(top: 100, right: 20, left: 20),
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
                      onChanged: (input) {
                        // handle email input changes
                      },
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
                    margin:
                    const EdgeInsets.only(top: 16, right: 20, left: 20),
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
                                  color: Color.fromARGB(255, 77, 166, 36),
                                ),
                              ),
                              activeColor:
                                  const Color.fromARGB(255, 77, 166, 36),
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
                            color: Color.fromARGB(255, 77, 166, 36),
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
                          backgroundColor: const Color.fromARGB(255, 77, 166, 36),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                        ),
                        onPressed: signIn,
                        child: _isloading?const CircularProgressIndicator(color: Colors.white,strokeWidth: 3,):
                        const Text(
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
