import 'package:flutter/material.dart';
import 'SplashScreen.dart';
import 'package:get/get.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(debugShowCheckedModeBanner: false,
      title: 'Rajasthan Studio',
      theme: ThemeData.dark(
      ),
      home: SplashScreen(),
    );
  }
}
