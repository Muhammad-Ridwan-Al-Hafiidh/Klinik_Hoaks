import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:connectivity/connectivity.dart';
import 'package:klinik_hoaks/view/form/form_setting/form_validasi.dart';
import 'package:klinik_hoaks/view/splash_screen/splash_screen.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<bool> checkInternetConnection() async {
  var connectivityResult = await Connectivity().checkConnectivity();
  return connectivityResult != ConnectivityResult.none;
}

void main() async {
   WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://buguxhaiqootukcsttkp.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJ1Z3V4aGFpcW9vdHVrY3N0dGtwIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MjIzOTQyNTUsImV4cCI6MjAzNzk3MDI1NX0.FAI35VhAaB-aNuPGPCTr0oFWkAWAkttn5PpKiu9Wi6M',
  );
  runApp(
    ChangeNotifierProvider(
      create: (_) => FormValidasi(),
      child: KlinikHoaks(),
    ),
  );
}

class KlinikHoaks extends StatelessWidget {
  const KlinikHoaks({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FutureBuilder<bool>(
        future: checkInternetConnection(),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else {
            if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            } else {
              if (snapshot.data == true) {
                return const SplashScreen();
              } else {
                return AlertDialog(
                  title: const Text('No Internet Connection'),
                  content: const Text(
                      'Please check your internet connection and try again.'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        SystemNavigator.pop();
                      },
                      child: const Text('OK'),
                    ),
                  ],
                );
              }
            }
          }
        },
      ),
    );
  }
}
