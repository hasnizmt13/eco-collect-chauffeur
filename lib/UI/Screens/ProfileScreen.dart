import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_app_1/UI/Screens/SignIn.dart';
import 'package:mobile_app_1/UI/Widgets/CostumNavBar.dart';

class ProfileScreen extends StatefulWidget {
  final Map<String, dynamic> routeData;
  final String image;
  final String full_name;
  const ProfileScreen(
      {Key? key,
      required this.image,
      required this.full_name,
      required this.routeData})
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
        toolbarHeight: 235,
        backgroundColor: const Color.fromARGB(255, 77, 166, 36),
        flexibleSpace: SafeArea(
            child: Column(
          children: [
            const SizedBox(height: 25),
            const Text(
              "My Profile",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                fontFamily: 'Poppins',
                color: Colors.white,
              ),
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
            const Text(
              "Hasni ZOUMATA",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                fontFamily: 'Poppins',
                color: Colors.white,
              ),
            ),
            TextButton(
              onPressed: _openImagePicker,
              child: const Text(
                "Upload Images",
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
                    margin: const EdgeInsets.only(
                        left: 20, bottom: 20, right: 20),
                    child: Column(
                      children: [
                        TextFormField(
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
                        const SizedBox(height: 16.0),
                        TextFormField(
                          obscureText: _obscureText,
                          validator: (input) {
                            if (input!.length < 8) {
                              return 'Password must be at least 8 characters';
                            }
                            return null;
                          },
                          onSaved: (input) => _password = input!,
                          decoration: InputDecoration(
                            labelText: 'Password',
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
                              return 'Please confirm your password';
                            }
                            return null;
                          },
                          onSaved: (value) => _confirmPassword = value!,
                          decoration: InputDecoration(
                            labelText: 'Confirm Password',
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
                          onPressed:(){},
                          color: const Color.fromARGB(255, 77, 166, 36),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(23.0),
                          ),
                          child: const Text(
                            "Save Changes",
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
               /*   SizedBox(
                    height: 10,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 77, 166, 36),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const SignIn()),
                        );
                      },
                      child: const Text(
                        "Sign Out",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          fontFamily: 'Poppins',
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),*/
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: CostumNavBar(index: 3, routeData: widget.routeData),
    );
  }
}
