import 'package:flutter/material.dart';
import 'UI/Screens/WaitingScreen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';


void main() async {
  await dotenv.load();
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ECO-COLLECT',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home:  WaitingScreen(),
    );
  }
}

