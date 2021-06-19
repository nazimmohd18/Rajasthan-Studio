import 'package:flutter/material.dart';
import 'Screens/HomePage.dart';
import 'Utils/Colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    new Future.delayed(
        const Duration(
          milliseconds: 2000,
        ),
            () => Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        ));
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: white,
body: Center(
  child:   Container(


    child: Image.asset('assets/images/rajstudio.jpeg'),
  ),
),
    );
  }
}
