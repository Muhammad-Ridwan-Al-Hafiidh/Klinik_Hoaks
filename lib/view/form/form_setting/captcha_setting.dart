import 'dart:math';

import 'package:flutter/material.dart';

class CaptchaVerification extends StatefulWidget { 
  const CaptchaVerification({super.key}); 

  @override 
  State<CaptchaVerification> createState() => _CaptchaVerificationState(); 
} 

class _CaptchaVerificationState extends State<CaptchaVerification> { 
  String randomString = ""; 
  bool isVerified = false; 
  TextEditingController controller = TextEditingController(); 

  void buildCaptcha() { 
    const letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890"; 
    const length = 6; 
    final random = Random(); 
    randomString = String.fromCharCodes(List.generate( 
        length, (index) => letters.codeUnitAt(random.nextInt(letters.length)))); 
    setState(() {}); 
    print("the random string is $randomString"); 
  } 

  @override 
  void initState() { 
    super.initState(); 
    buildCaptcha(); 
  } 

  @override 
  Widget build(BuildContext context) { 
    return Padding( 
      padding: const EdgeInsets.all(8.0), 
      child: Column( 
        mainAxisAlignment: MainAxisAlignment.center, 
        crossAxisAlignment: CrossAxisAlignment.center, 
        children: [ 
          const Text( 
            "Enter Captcha Value", 
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold), 
          ), 
          const SizedBox(height: 10), 
          Row( 
            mainAxisAlignment: MainAxisAlignment.center, 
            children: [ 
              Container( 
                  padding: const EdgeInsets.all(12), 
                  decoration: BoxDecoration( 
                      border: Border.all(width: 2), 
                      borderRadius: BorderRadius.circular(8)), 
                  child: Text( 
                    randomString, 
                    style: const TextStyle(fontWeight: FontWeight.w500), 
                  )), 
              const SizedBox(width: 10), 
              IconButton( 
                  onPressed: () { 
                    buildCaptcha(); 
                  }, 
                  icon: const Icon(Icons.refresh)), 
            ], 
          ), 
          const SizedBox(height: 10), 
          TextFormField( 
            onChanged: (value) { 
              setState(() { 
                isVerified = false; 
              }); 
            }, 
            decoration: const InputDecoration( 
                border: OutlineInputBorder(), 
                hintText: "Enter Captcha Value", 
                labelText: "Enter Captcha Value"), 
            controller: controller, 
          ), 
          const SizedBox(height: 10), 
          ElevatedButton( 
              onPressed: () { 
                isVerified = controller.text == randomString; 
                setState(() {}); 
              }, 
              child: const Text("Check")), 
          const SizedBox(height: 10), 
          if (isVerified) 
            const Row( 
              mainAxisAlignment: MainAxisAlignment.center, 
              children: [Icon(Icons.verified), Text("Verified")], 
            ) 
          else
            const Text("Please enter value you see on screen"), 
        ], 
      ), 
    );
  } 
}