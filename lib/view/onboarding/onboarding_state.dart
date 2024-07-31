import 'package:flutter/material.dart';

class OnboardingState with ChangeNotifier {
  int onBoardingNumber = 0;
  List<String> imagePath = [
    'assets/onboarding/step1.png',
    'assets/onboarding/step2.png',
    'assets/onboarding/step3.png'
  ];
  List<String> listTitle = [
    'Klinik Hoaks Insight',
    'Klinik Hoaks Explorer',
    'All in Klinik Hoaks'
  ];
  List<String> listDescription = [
    "Find out the history of upperclassmen's experiences",
    "Find detailed information about your internship location",
    "With a variety of features, your internship will be easier!"
  ];

  String get title => listTitle[onBoardingNumber];
  String get description => listDescription[onBoardingNumber];
  String get imageLocation => imagePath[onBoardingNumber];
  int get onBoardingPageNumber => onBoardingNumber;
  Color onBoardingIndicator(int value) {
    if (value == onBoardingNumber) {
      return Colors.orange;
    } else {
      return Colors.grey;
    }
  }

  set setOnBoardingNumber(String value) {
    if (value == 'next') {
      onBoardingNumber += 1;
      notifyListeners();
    } else if (value == 'back') {
      onBoardingNumber -= 1;
      notifyListeners();
    } else if (value == 'skip') {
      onBoardingNumber = 2;
      notifyListeners();
    }
  }
}
