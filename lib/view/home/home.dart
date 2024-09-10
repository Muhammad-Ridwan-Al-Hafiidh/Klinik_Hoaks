import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:klinik_hoaks/models/search.dart';
import 'package:klinik_hoaks/view/home/List_artikel.dart';
import 'package:klinik_hoaks/view/home/webview.dart';
import 'package:klinik_hoaks/view/main_screen/main_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Artikel>> _carouselArticles;
  late Future<List<Artikel>> _klarifikasiArticles;

  @override
  void initState() {
    super.initState();
    _carouselArticles = _fetchCarouselArticles();
    _klarifikasiArticles = _fetchKlarifikasiArticles();
  }

  Future<List<Artikel>> _fetchCarouselArticles() async {
    final articles = await ArtikelService().fetchArticles();
    return articles.take(5).toList(); // Fetch and limit to 5 articles
  }

  Future<List<Artikel>> _fetchKlarifikasiArticles() async {
    final articles = await ArtikelService().fetchArticles();
    return articles; // Fetch all articles
  }

  void _launchURL(String slugPath) {
    final encodedSlugPath = Uri.encodeComponent(slugPath);
    final url = 'https://demo-klinikhoaks.jatimprov.go.id/post/$encodedSlugPath#blogdetail';
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => WebViewPage(url: url)),
    );
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
              MaterialPageRoute(builder: (context) => const MainScreen()),
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
              const Text(
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
            padding: const EdgeInsets.all(10),
            color: const Color.fromRGBO(0, 131, 116, 1.000),
            child: const Text(
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
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Informasi Terbaru',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 10),
                      FutureBuilder<List<Artikel>>(
                        future: _carouselArticles,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(child: Text('Error: ${snapshot.error}'));
                          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                            return const Center(child: Text('No articles found'));
                          } else {
                            return CarouselSlider(
                              options: CarouselOptions(
                                autoPlay: true,
                                autoPlayInterval: const Duration(seconds: 3),
                                height: 160,
                                enlargeCenterPage: true,
                                enableInfiniteScroll: true,
                              ),
                              items: snapshot.data!.map((item) {
                                return Builder(
                                  builder: (BuildContext context) {
                                    return Container(
                                      width: MediaQuery.of(context).size.width,
                                      margin: const EdgeInsets.symmetric(horizontal: 5.0,vertical: 1),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8.0),
                                        image: DecorationImage(
                                          image: NetworkImage(item.image),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      child: InkWell(
                                        onTap: () {
                                          _launchURL(item.slugPath); // Use slugPath for URL
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(8.0),
                                            gradient: LinearGradient(
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomCenter,
                                              colors: [
                                                Colors.transparent,
                                                const Color.fromRGBO(0, 131, 116, 1.000).withOpacity(0.9),
                                              ],
                                            ),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              children: [
                                                Text(
                                                  item.judul,
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              }).toList(),
                            );
                          }
                        },
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'Semua Klarifikasi',
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const ListArtikel()),
                              );
                            },
                            child: const Icon(Icons.arrow_forward_outlined),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      FutureBuilder<List<Artikel>>(
                        future: _klarifikasiArticles,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(child: Text('Error: ${snapshot.error}'));
                          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                            return const Center(child: Text('No klarifikasi found'));
                          } else {
                            return ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: snapshot.data!.length,
                              itemBuilder: (context, index) {
                                final item = snapshot.data![index];
                                return Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                                  child: InkWell(
                                    onTap: () {
                                      _launchURL(item.slugPath); // Use slugPath for URL
                                    },
                                    child: Card(
                                      child: Container(
                                        width: screenWidth * 0.9,
                                        height: screenHeight * 0.2,
                                        child: Stack(
                                          children: [
                                            // Image layer
                                            Container(
                                              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 1),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(8.0),
                                                image: DecorationImage(
                                                  image: NetworkImage(item.image),
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
                                                    const Color.fromRGBO(0, 131, 116, 1.000).withOpacity(0.9),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            // Content layer
                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.end,
                                                children: [
                                                  Text(
                                                    item.judul,
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 18,
                                                      fontWeight: FontWeight.bold,
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
                                );
                              },
                            );
                          }
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
