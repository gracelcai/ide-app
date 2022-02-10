import 'package:flutter/material.dart';
import 'package:ide_app/home.dart';
import 'package:ide_app/sign_in.dart';
import 'package:ide_app/sign_up.dart';
import 'package:ide_app/splash.dart';

Future<void> main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Firebase Auth',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
        primaryColor: Colors.indigoAccent,
        scaffoldBackgroundColor: Color(0xFFf7f7f7),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => Splash(),
        '/signin': (context) => SignIn(),
        '/signup': (context) => SignUp(),
        '/home': (context) => Home(),
      },
    );
  }
}
