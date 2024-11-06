import 'package:flutter/material.dart';
import 'package:klinik_hoaks/view/main_screen/main_screen.dart';
import 'package:klinik_hoaks/view/onboarding/onboarding.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool isVisited = false;

  void _saveSession() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setBool('isVisited', isVisited);
  }

  Future<bool?> getSession() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getBool("isVisited");
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getSession().then((value) {
      if (value == null) {
        _saveSession();
      } else {
        isVisited = value;
      }
      Future.delayed(const Duration(seconds: 3), () {
        Navigator.pushReplacement(
            context,
            PageRouteBuilder(
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  return FadeTransition(
                    opacity: animation,
                    child: child,
                  );
                },
                transitionDuration: const Duration(microseconds: 1500),
                pageBuilder: (context, animation, secondaryAnimation) =>
                    isVisited ? const MainScreen() : const OnBoarding()));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 20),
                    // Changed from MainAxisAlignment to margin
                    child: Image.asset(
                      'assets/logo_provinsi_jawa_timur.png', width: 150, height: 150,
                    ),
                  ),
                  const Text(
                    'Klinik Hoaks',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // spacing between logo and "Your story became my apprentice" text
                  const Center(
                    child: Text(
                      'Aplikasi Kominfo Untuk Memberantas Informasi Hoaks',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 63, 170, 86),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(15.0),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Text(
                  'Versi 1.1.1',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}