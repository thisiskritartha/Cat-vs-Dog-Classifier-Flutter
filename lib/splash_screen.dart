import 'package:easy_splash_screen/easy_splash_screen.dart';
import 'package:flutter/material.dart';
import 'home_screen.dart';

class MySplash extends StatefulWidget {
  const MySplash({Key? key}) : super(key: key);

  @override
  State<MySplash> createState() => _MySplashState();
}

class _MySplashState extends State<MySplash> {
  @override
  Widget build(BuildContext context) {
    return EasySplashScreen(
      durationInSeconds: 2,
      navigator: const HomeScreen(),
      showLoader: true,
      loadingText: const Text(
        "Loading...",
        style: TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          letterSpacing: 2,
        ),
      ),
      title: const Text(
        'Cat vs Dog Classifier',
        style: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      backgroundColor: Colors.blueAccent,
      loaderColor: Colors.white,
      logo: Image.asset(
        'images/cat_dog_icon.png',
      ),
      logoWidth: 100,
    );
  }
}
