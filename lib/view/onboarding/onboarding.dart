import 'package:flutter/material.dart';
import 'package:klinik_hoaks/view/main_screen/main_screen.dart';
import 'package:klinik_hoaks/view/onboarding/onboarding_state.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnBoarding extends StatelessWidget {

  const OnBoarding({super.key});
  void _saveSession()async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setBool('isVisited', true);
  }
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => OnboardingState(),
      child: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // const Spacer(),
                const Image(image: AssetImage('assets/logo_provinsi_jawa_timur.png'), width: 100, height: 100,),
                Text('data'),
                Consumer<OnboardingState>(
                  builder: (context, onBoarding, _) => Image(
                    width: 245,
                    height: 245,
                    image: AssetImage(
                      onBoarding.imageLocation,
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
                Column(
                  children: [
                    Consumer<OnboardingState>(
                      builder: (context, onBoarding, _) => Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        child: Text(
                          onBoarding.title,
                          style: const TextStyle(
                              fontSize: 28, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Consumer<OnboardingState>(
                      builder: (context, onBoarding, _) => Padding(
                        padding: const EdgeInsets.only(left: 40.0, right: 40.0),
                        child: Text(
                          onBoarding.description,
                          style: const TextStyle(
                            fontSize: 18,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Consumer<OnboardingState>(
                      builder: (context, onBoarding, _) => Container(
                        margin: const EdgeInsets.only(right: 20),
                        width: 32,
                        height: 8,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: onBoarding.onBoardingIndicator(0)),
                      ),
                    ),
                    Consumer<OnboardingState>(
                      builder: (context, onBoarding, _) => Container(
                        margin: const EdgeInsets.only(right: 20),
                        width: 32,
                        height: 8,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: onBoarding.onBoardingIndicator(1)),
                      ),
                    ),
                    Consumer<OnboardingState>(
                      builder: (context, onBoarding, _) => Container(
                        width: 32,
                        height: 8,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: onBoarding.onBoardingIndicator(2)),
                      ),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Material(
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        width: MediaQuery.of(context).size.width /2.75,
                        height: 50,
                        decoration: BoxDecoration(
                            border: Border.all(width: 1.0),
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12)),
                        child: Material(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.transparent,
                          child: Consumer<OnboardingState>(
                            builder: (context, onBoarding, _) => InkWell(
                              borderRadius: BorderRadius.circular(12),
                              onTap: () {
                                if (onBoarding.onBoardingNumber > 0) {
                                  onBoarding.setOnBoardingNumber = 'back';
                                }else if(onBoarding.onBoardingNumber == 0){
                                  onBoarding.setOnBoardingNumber = 'skip';
                                }
                              },
                              child: Center(
                                child: Text(
                                  onBoarding.onBoardingNumber == 0
                                      ? "Skip"
                                      : "Back",
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'DM Sans'),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Material(
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        width:  MediaQuery.of(context).size.width /2.75,
                        height: 50,
                        decoration: BoxDecoration(
                            color: Colors.orange,
                            borderRadius: BorderRadius.circular(12)),
                        child: Material(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.transparent,
                          child: Consumer<OnboardingState>(
                            builder: (context, onBoarding, _) => InkWell(
                              borderRadius: BorderRadius.circular(12),
                              onTap: () {
                                if (onBoarding.onBoardingNumber < 2) {
                                  onBoarding.setOnBoardingNumber = 'next';
                                } else if (onBoarding.onBoardingNumber == 2) {
                                  Navigator.pushReplacement(context,
                                      MaterialPageRoute(builder: (context) {
                                        _saveSession();
                                        return MainScreen();
                                      }));
                                }
                              },
                              child: Center(
                                child: Text(
                                  onBoarding.onBoardingNumber == 2
                                      ? "Start"
                                      : "Next",
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'DM Sans'),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                // const Spacer()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
