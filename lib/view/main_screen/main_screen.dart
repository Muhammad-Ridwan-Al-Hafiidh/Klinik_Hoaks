import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:klinik_hoaks/view/home/List_artikel.dart';
import 'package:klinik_hoaks/view/form/form.dart';
import 'package:klinik_hoaks/view/home/history.dart';
import 'package:klinik_hoaks/view/home/home.dart';
import 'package:klinik_hoaks/view/home/tiket.dart';

Future<bool> checkInternetConnection() async {
  var connectivityResult = await Connectivity().checkConnectivity();
  return connectivityResult != ConnectivityResult.none;
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentTab = 0;
  List<Widget> screens = [
    const HomePage(),
    const FormInfo(),
    const Tiket(),
    const ListArtikel(),
    const Rekap()
  ];
  final PageStorageBucket pageStorageBucket = PageStorageBucket();
  Widget currentScreen = HomePage();
  Color onPressed = const Color.fromARGB(255, 255, 255, 255);
  Color notPressed = const Color.fromARGB(255, 255, 255, 255);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        color: const Color.fromRGBO(0, 131, 116, 1.000),
        elevation: 0,
       clipBehavior: Clip.antiAlias,
        //   shape: CircularNotchedRectangle(),
        // notchMargin: 10.0,
        child: Container(
          height: 50, // Adjust height as needed
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // Home button
              Expanded(
                child: MaterialButton(
                  onPressed: () {
                    setState(() {
                      currentScreen = const HomePage();
                      currentTab = 0;
                    });
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.home_filled,
                          color: currentTab == 0 ? onPressed : notPressed),
                      Text(
                        'Home',
                        style: TextStyle(
                            color: currentTab == 0 ? onPressed : notPressed),
                      ),
                    ],
                  ),
                ),
              ),
              // Tiket button
              Expanded(
                child: MaterialButton(
                  onPressed: () {
                    setState(() {
                      currentScreen = const Tiket();
                      currentTab = 1;
                    });
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.code_sharp,
                        color: currentTab == 1 ? onPressed : notPressed,
                      ),
                      Text(
                        'Tiket',
                        style: TextStyle(
                            color: currentTab == 1 ? onPressed : notPressed),
                      ),
                    ],
                  ),
                ),
              ),
              // Discover button
              Expanded(
                child: MaterialButton(
                  onPressed: () {
                    setState(() {
                      currentScreen = const ListArtikel();
                      currentTab = 2;
                    });
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.search,
                        color: currentTab == 2 ? onPressed : notPressed,
                      ),
                      Text(
                        'Search',
                        style: TextStyle(
                            color: currentTab == 2 ? onPressed : notPressed),
                      ),
                    ],
                  ),
                ),
              ),
              // Rekap button
              Expanded(
                child: MaterialButton(
                  onPressed: () {
                    setState(() {
                      currentScreen = const Rekap(); // Change to the appropriate screen widget for Rekap
                      currentTab = 3;
                    });
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.history,
                        color: currentTab == 3 ? onPressed : notPressed,
                      ),
                      Text(
                        'Rekap',
                        style: TextStyle(
                            color: currentTab == 3 ? onPressed : notPressed),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    
      // Form button
      floatingActionButton: FloatingActionButton(
        elevation: 10,
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context)=>FormInfo()));
        },
        
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        child: const Icon(
          Icons.add,
          color: Color.fromRGBO(0, 131, 116, 1.000),
          size: 30,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniCenterDocked,
      body: FutureBuilder<bool>(
        future: checkInternetConnection(),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            } else {
              if (snapshot.data == true) {
                return Stack(
                  children: [
                    PageStorage(
                      bucket: pageStorageBucket,
                      child: currentScreen,
                    ),
                  ],
                );
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
