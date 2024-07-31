// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:flutter/material.dart';
// import 'package:klinik_hoaks/models/klarifikasi.dart';
// import 'package:klinik_hoaks/view/article/detail_artikel.dart';
// import 'package:klinik_hoaks/view/home/List_artikel.dart';
// import 'package:klinik_hoaks/view/main_screen/main_screen.dart';

// class HomePage extends StatefulWidget {
//   const HomePage({super.key});

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//    List<KlarifikasiModel> klarifikasiData = [];

//    @override
//   void initState() {
//     super.initState();
//     fetchKlarifikasiData();
//   }

//   Future<void> fetchKlarifikasiData() async {
//     final response = await http.get(Uri.parse('https://demo-klinikhoaks.jatimprov.go.id/api/mobile/aduan'));
    
//     if (response.statusCode == 200) {
//       final List<dynamic> jsonData = json.decode(response.body);
//       setState(() {
//         klarifikasiData = jsonData.map((item) => KlarifikasiModel.fromJson(item)).toList();
//       });
//     } else {
//       throw Exception('Failed to load klarifikasi data');
//     }
//   }

//   Future<void> submitKlarifikasi(KlarifikasiModel klarifikasi) async {
//     final response = await http.post(
//       Uri.parse('https://demo-klinikhoaks.jatimprov.go.id/api/mobile/aduan'),
//       body: klarifikasi.toJson(),
//     );

//     if (response.statusCode == 200) {
//       // Handle successful submission
//       print('Klarifikasi submitted successfully');
//     } else {
//       throw Exception('Failed to submit klarifikasi');
//     }
//   }

//   Future<void> uploadImage(String tiketNo, String fotoBase64) async {
//     final response = await http.post(
//       Uri.parse('https://demo-klinikhoaks.jatimprov.go.id/api/mobile/uploadfotoaduan'),
//       body: {
//         'tiket_no': tiketNo,
//         'foto': fotoBase64,
//       },
//     );

//     if (response.statusCode == 200) {
//       // Handle successful image upload
//       print('Image uploaded successfully');
//     } else {
//       throw Exception('Failed to upload image');
//     }
//   }


//   @override
//   Widget build(BuildContext context) {
//     double screenWidth = MediaQuery.of(context).size.width;
//     double screenHeight = MediaQuery.of(context).size.height;

//     return Scaffold(
//       appBar: AppBar(
//         title: InkWell(
//           onTap: () {
//             Navigator.of(context).pushReplacement(
//               MaterialPageRoute(builder: (context) => MainScreen()),
//             );
//           },
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Image.asset(
//                 'assets/logo_provinsi_jawa_timur.png',
//                 width: 50,
//                 height: 50,
//               ),
//               Text(
//                 'Klinik Hoaks',
//                 style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
//               ),
//             ],
//           ),
//         ),
//         centerTitle: true,
//       ),
//       body: Column(
//         children: [
//           // Frame banner
//           Container(
//             width: double.infinity,
//             padding: EdgeInsets.all(10),
//             color: Color.fromRGBO(0, 131, 116, 1.000),
//             child: Text(
//               'Selamat datang di Klinik Hoaks Jawa Timur',
//               style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//               textAlign: TextAlign.center,
//             ),
//           ),
//           Expanded(
//             child: SingleChildScrollView(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 children: [
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Text(
//                           'Informasi Terbaru',
//                           style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                         ),
//                       ),
//                       SizedBox(height: 10),
//                       Container(
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
//                       SizedBox(height: 20),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: Text(
//                               'Semua Klarifikasi',
//                               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                             ),
//                           ),
//                           InkWell(
//                             onTap: () {
//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(builder: (context) => ListArtikel()),
//                               );
//                             },
//                             child: Icon(Icons.arrow_forward_outlined),
//                           ),
//                         ],
//                       ),
//                       SizedBox(height: 10),
//                         ListView.builder(
//                     shrinkWrap: true,
//                     physics: NeverScrollableScrollPhysics(),
//                     itemCount: klarifikasiData.length,
//                     itemBuilder: (context, index) {
//                       final item = klarifikasiData[index];
//                       return Padding(
//                         padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
//                         child: InkWell(
//                           onTap: () {
//                             Navigator.push(context, MaterialPageRoute(builder: (context) => DetailArtikel()));
//                           },
//                           child: Card(
//                             child: Container(
//                               width: screenWidth * 0.9,
//                               height: screenHeight * 0.2,
//                               child: Stack(
//                                 children: [
//                                       // Image layer
//                                       Container(
//                                         decoration: BoxDecoration(
//                                           borderRadius: BorderRadius.circular(8.0),
                                         
//                                         ),
//                                       ),
//                                       // Gradient layer
//                                       Container(
//                                         decoration: BoxDecoration(
//                                           borderRadius: BorderRadius.circular(8.0),
//                                           gradient: LinearGradient(
//                                             begin: Alignment.topCenter,
//                                             end: Alignment.bottomCenter,
//                                             colors: [
//                                               Colors.transparent,
//                                               Color.fromRGBO(0, 131, 116, 1.000).withOpacity(0.9),
//                                             ],
//                                           ),
//                                         ),
//                                       ),
//                                       // Content layer
//                                        Padding(
//                                     padding: const EdgeInsets.all(8.0),
//                                     child: Column(
//                                       mainAxisAlignment: MainAxisAlignment.center,
//                                       crossAxisAlignment: CrossAxisAlignment.start,
//                                       children: [
//                                         Text(
//                                           item.nama,
//                                           style: TextStyle(
//                                             color: Colors.white,
//                                             fontSize: 18,
//                                             fontWeight: FontWeight.bold,
//                                           ),
//                                         ),
//                                            SizedBox(height: 2),
//                                         Text(
//                                           item.uraian,
//                                           style: TextStyle(
//                                             color: Colors.white,
//                                             fontSize: 14,
//                                           ),
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           );
//                         },
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
