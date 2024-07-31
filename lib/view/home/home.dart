import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:klinik_hoaks/models/artikel.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:klinik_hoaks/view/article/detail_artikel.dart';
import 'package:klinik_hoaks/view/home/List_artikel.dart';
import 'package:klinik_hoaks/view/main_screen/main_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Artikel> artikelList = [];

  Future<void> fetchArtikelData() async {
  try {
    final response = await Supabase.instance.client
        .from('artikel')
        .select();

    if (response != null && response is List) {
      setState(() {
        artikelList = response.map((item) => Artikel.fromJson(item as Map<String, dynamic>)).toList();
      });
    } else {
      throw Exception('Invalid data received from Supabase');
    }
  } catch (e) {
    print('Error fetching artikel data: $e');
    // You might want to show an error message to the user here
  }
}

  @override
  void initState() {
    super.initState();
    fetchArtikelData();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: InkWell(
          onTap: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => MainScreen()),
            );
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/logo_provinsi_jawa_timur.png',
                width: 50,
                height: 50,
              ),
              Text(
                'Klinik Hoaks',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Frame banner
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(10),
            color: Color.fromRGBO(0, 131, 116, 1.000),
            child: Text(
              'Selamat datang di Klinik Hoaks Jawa Timur',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Informasi Terbaru',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(height: 10),
                      // Your carousel code here
                      //  Container(
//                         margin: EdgeInsets.symmetric(horizontal: 0.0),
//                         child: CarouselSlider(
//                           options: CarouselOptions(
//                             autoPlay: true,
//                             autoPlayInterval: Duration(seconds: 3),
//                             height: 160,
//                             enlargeCenterPage: true,
//                             enableInfiniteScroll: true,
//                           ),
//                           items: klarifikasiData.take(3).map((item) {
//                             return Builder(
//                               builder: (BuildContext context) {
//                                 return Container(
//                                   width: MediaQuery.of(context).size.width,
//                                   margin: EdgeInsets.symmetric(horizontal: 5.0),
//                                   decoration: BoxDecoration(
//                                     borderRadius: BorderRadius.circular(8.0),
                                   
//                                   ),
//                                   child: InkWell(
//                                     onTap: () {
//                                       Navigator.push(context, MaterialPageRoute(builder: (context) => DetailArtikel()));
//                                     },
//                                     child: Container(
//                                       decoration: BoxDecoration(
//                                         borderRadius: BorderRadius.circular(8.0),
//                                         gradient: LinearGradient(
//                                           begin: Alignment.topCenter,
//                                           end: Alignment.bottomCenter,
//                                           colors: [
//                                             Colors.transparent,
//                                             Color.fromRGBO(0, 131, 116, 1.000).withOpacity(0.9),
//                                           ],
//                                         ),
//                                       ),
//                                       child: Padding(
//                                         padding: const EdgeInsets.all(8.0),
//                                         child: Column(
//                                           mainAxisAlignment: MainAxisAlignment.center,
//                                           crossAxisAlignment: CrossAxisAlignment.start,
//                                           children: [
//                                             Center(
//                                               child: Image.asset(
//                                                 'assets/fakta.png',
//                                                 width: 160,
//                                               ),
//                                             ),
//                                             Text(
//                                               item.nama,
//                                               style: TextStyle(
//                                                 color: Colors.white,
//                                                 fontSize: 18,
//                                                 fontWeight: FontWeight.bold,
//                                               ),
//                                             ),
//                                             SizedBox(height: 2),
//                                             Text(
//                                                item.nama,
//                                               style: TextStyle(
//                                                 color: Colors.white,
//                                                 fontSize: 14,
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 );
//                               },
//                             );
//                           }).toList(),
//                         ),
//                       ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Semua Klarifikasi',
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => ListArtikel()),
                              );
                            },
                            child: Icon(Icons.arrow_forward_outlined),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: artikelList.length,
                        itemBuilder: (context, index) {
                          final artikel = artikelList[index];
                          return ListTile(
                            title: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => DetailArtikel()));
                                },
                                child: Card(
                                  child: Container(
                                    width: screenWidth * 0.9,
                                    height: screenHeight * 0.2,
                                    child: Stack(
                                      children: [
                                        // Image layer
                                        Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(8.0),
                                            image: DecorationImage(
                                              image: NetworkImage(artikel.image),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        // Gradient layer
                                        Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(8.0),
                                            gradient: LinearGradient(
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomCenter,
                                              colors: [
                                                Colors.transparent,
                                                Color.fromRGBO(0, 131, 116, 1.000).withOpacity(0.9),
                                              ],
                                            ),
                                          ),
                                        ),
                                        // Content layer
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Center(
                                                child: Image.asset(
                                                  'assets/fakta.png',
                                                  width: 160,
                                                ),
                                              ),
                                              Text(
                                                artikel.title,
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              SizedBox(height: 2),
                                              Text(
                                                artikel.uraian,
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
