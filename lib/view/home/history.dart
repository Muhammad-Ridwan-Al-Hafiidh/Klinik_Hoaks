import 'package:flutter/material.dart';

import 'package:klinik_hoaks/models/search.dart';

class Rekap extends StatefulWidget {
  const Rekap({super.key});

  @override
  State<Rekap> createState() => _RekapState();
}

class _RekapState extends State<Rekap> with TickerProviderStateMixin {
  late AnimationController _controllerHoaks;
  late Animation<int> _animationHoaks;

  late AnimationController _controllerDisinformasi;
  late Animation<int> _animationDisinformasi;

  late AnimationController _controllerFakta;
  late Animation<int> _animationFakta;

  late AnimationController _controllerHateSpeech;
  late Animation<int> _animationHateSpeech;

  String selectedYear = '2024';
  int countHoaks = 0;
  int countDisinformasi = 0;
  int countFakta = 0;
  int countHateSpeech = 0;

  final ArtikelService artikelService = ArtikelService();

  @override
  void initState() {
    super.initState();

    // Initialize controllers
    _controllerHoaks = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _controllerDisinformasi = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _controllerFakta = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _controllerHateSpeech = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    // Initialize animations with default values
    _animationHoaks = IntTween(begin: 0, end: 0).animate(_controllerHoaks);
    _animationDisinformasi = IntTween(begin: 0, end: 0).animate(_controllerDisinformasi);
    _animationFakta = IntTween(begin: 0, end: 0).animate(_controllerFakta);
    _animationHateSpeech = IntTween(begin: 0, end: 0).animate(_controllerHateSpeech);

    // Fetch data
    fetchArticleData();
  }

  Future<void> fetchArticleData() async {
    try {
      List<Artikel> articles = await artikelService.fetchArticles();

      setState(() {
        countHoaks = articles
            .where((article) => article.judul.contains('Hoaks'))
            .length;
        countDisinformasi = articles
            .where((article) => article.judul.contains('Disinformasi'))
            .length;
        countFakta = articles
            .where((article) => article.judul.contains('Fakta'))
            .length;
        countHateSpeech = articles
            .where((article) => article.judul.contains('Hate Speech'))
            .length;

        // Update the animations based on the new data
        _animationHoaks = IntTween(begin: 0, end: countHoaks).animate(_controllerHoaks);
        _animationDisinformasi = IntTween(begin: 0, end: countDisinformasi).animate(_controllerDisinformasi);
        _animationFakta = IntTween(begin: 0, end: countFakta).animate(_controllerFakta);
        _animationHateSpeech = IntTween(begin: 0, end: countHateSpeech).animate(_controllerHateSpeech);

        // Start the animation
        _controllerHoaks.forward();
        _controllerDisinformasi.forward();
        _controllerFakta.forward();
        _controllerHateSpeech.forward();
      });
    } catch (e) {
      print("Error fetching articles: $e");
    }
  }

  @override
  void dispose() {
    _controllerHoaks.dispose();
    _controllerDisinformasi.dispose();
    _controllerFakta.dispose();
    _controllerHateSpeech.dispose();
    super.dispose();
  }

  final List<String> years = [
    '2024',
    '2023',
    '2022',
    '2021',
    '2020',
    '2019',
  ];
  String? selectedValue;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Rekap Klarifikasi Informasi',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
          child: ListView(
        children: [
          Column(
            children: [
              Card(
                elevation: 15,
                child: Container(
                    decoration: const BoxDecoration(shape: BoxShape.rectangle),
                    width: screenWidth * 0.7,
                    height: screenHeight * 0.2,
                    child: Image.asset(
                      'assets/rekap.png',
                      fit: BoxFit.fill,
                    )),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Card(
                      elevation: 10,
                      child: Container(
                        color: Colors.white,
                        alignment: Alignment.center,
                        width: screenWidth * 0.4,
                        height: screenHeight * 0.2,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 25),
                          child: Column(
                            children: [
                              AnimatedBuilder(
                                animation: _animationHoaks,
                                builder: (context, child) {
                                  return Text(
                                    '${_animationHoaks.value}',
                                    style: const TextStyle(
                                        fontSize: 40,
                                        fontWeight: FontWeight.bold,
                                        color:
                                            Color.fromRGBO(0, 131, 116, 1.000)),
                                  );
                                },
                              ),
                              const Text(
                                'Hoaks',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Card(
                      elevation: 10,
                      child: Container(
                        color: Colors.white,
                        alignment: Alignment.center,
                        width: screenWidth * 0.4,
                        height: screenHeight * 0.2,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 25),
                          child: Column(
                            children: [
                              AnimatedBuilder(
                                animation: _animationDisinformasi,
                                builder: (context, child) {
                                  return Text(
                                    '${_animationDisinformasi.value}',
                                    style: const TextStyle(
                                        fontSize: 40,
                                        fontWeight: FontWeight.bold,
                                        color:
                                            Color.fromRGBO(0, 131, 116, 1.000)),
                                  );
                                },
                              ),
                              const Text(
                                'Disinformasi',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.yellow),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Card(
                      elevation: 10,
                      child: Container(
                        color: Colors.white,
                        alignment: Alignment.center,
                        width: screenWidth * 0.4,
                        height: screenHeight * 0.2,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 25),
                          child: Column(
                            children: [
                              AnimatedBuilder(
                                animation: _animationFakta,
                                builder: (context, child) {
                                  return Text(
                                    '${_animationFakta.value}',
                                    style: const TextStyle(
                                        fontSize: 40,
                                        fontWeight: FontWeight.bold,
                                        color:
                                            Color.fromRGBO(0, 131, 116, 1.000)),
                                  );
                                },
                              ),
                              const Text(
                                'Fakta',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Card(
                      elevation: 10,
                      child: Container(
                        color: Colors.white,
                        alignment: Alignment.center,
                        width: screenWidth * 0.4,
                        height: screenHeight * 0.2,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 25),
                          child: Column(
                            children: [
                              AnimatedBuilder(
                                animation: _animationHateSpeech,
                                builder: (context, child) {
                                  return Text(
                                    '${_animationHateSpeech.value}',
                                    style: const TextStyle(
                                        fontSize: 40,
                                        fontWeight: FontWeight.bold,
                                        color:
                                            Color.fromRGBO(0, 131, 116, 1.000)),
                                  );
                                },
                              ),
                              const Text(
                                'Hate Speech',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.orange),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          )
        ],
      )),
    );
  }
}
