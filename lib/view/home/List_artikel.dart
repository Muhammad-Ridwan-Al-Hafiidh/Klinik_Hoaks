import 'package:flutter/material.dart';
import 'package:klinik_hoaks/animation/src/searchbar.dart';
import 'package:klinik_hoaks/models/search.dart';
import 'package:klinik_hoaks/view/home/webview.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';

class ListArtikel extends StatefulWidget {
  const ListArtikel({super.key});

  @override
  State<ListArtikel> createState() => _ListArtikelState();
}

class _ListArtikelState extends State<ListArtikel> {
  bool _isSearchBarOpen = false;
  TextEditingController _searchController = TextEditingController();
  List<Artikel> _allArticles = [];
  List<Artikel> _displayedArticles = [];
  late Future<List<Artikel>> _futureArticles;
  List<String> _filters = ['Fakta', 'Hoaks', 'Disinformasi', 'Hate Speech'];
  List<bool> _selectedFilters = [false, false, false, false];
  String _searchKeyword = '';

  @override
  void initState() {
    super.initState();
    _futureArticles = _fetchArticles();
  }

  Future<List<Artikel>> _fetchArticles([String keywords = '']) async {
    try {
      final articles = await ArtikelService().fetchArticles(keywords: keywords);
      setState(() {
        _allArticles = articles;
        _applyFilters();
      });
      return articles;
    } catch (e) {
      print('Error fetching articles: $e');
      return [];
    }
  }

  void _applyFilters() {
    setState(() {
      List<String> activeFilters = _filters
          .asMap()
          .entries
          .where((entry) => _selectedFilters[entry.key])
          .map((entry) => entry.value.toLowerCase())
          .toList();

      _displayedArticles = _allArticles.where((artikel) {
        bool matchesKeyword = _searchKeyword.isEmpty ||
            artikel.judul.toLowerCase().contains(_searchKeyword.toLowerCase());
        bool matchesFilter = activeFilters.isEmpty ||
            activeFilters.any((filter) => artikel.judul.toLowerCase().contains(filter));
        return matchesKeyword && matchesFilter;
      }).toList();
    });
  }

  void _searchArticles(String keywords) {
    setState(() {
      _searchKeyword = keywords;
      _applyFilters();
    });
  }

  void _toggleFilter(int index) {
    setState(() {
      _selectedFilters[index] = !_selectedFilters[index];
      _applyFilters();
    });
  }

  Future<void> _launchUrl(String slugPath) async {
    final encodedSlugPath = Uri.encodeComponent(slugPath);
    final url = Uri.parse('https://demo-klinikhoaks.jatimprov.go.id/post/$encodedSlugPath#blogdetail');
    try {
      if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
        throw Exception('Could not launch $url');
      }
    } catch (e) {
      print('An error occurred: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to open the link. Please try again.')),
      );
    }
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
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text('Cek Hoaks atau Fakta ?'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Positioned(
              top: 10,
              child: AnimatedOpacity(
                opacity: _isSearchBarOpen ? 0.0 : 1.0,
                duration: Duration(milliseconds: 200),
                child: Padding(
                  padding: const EdgeInsets.only(top: 8, left: 16),
                  child: Text(
                    'Masukkan Kata Kunci Anda',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: SearchBarAnimation(
                textEditingController: _searchController,
                isOriginalAnimation: true,
                enableKeyboardFocus: true,
                onExpansionComplete: () {
                  setState(() {
                    _isSearchBarOpen = true;
                  });
                  debugPrint('Search bar opened.');
                },
                onCollapseComplete: () {
                  setState(() {
                    _isSearchBarOpen = false;
                    _searchController.clear();
                    _searchKeyword = '';
                    _futureArticles = _fetchArticles();
                  });
                  debugPrint('Search bar closed.');
                },
                onPressButton: (isSearchBarOpens) {
                  if (isSearchBarOpens) {
                    _searchArticles(_searchController.text);
                  }
                  debugPrint('Animation ${isSearchBarOpens ? 'opening' : 'closing'} started.');
                },
                trailingWidget: const Icon(
                  Icons.search,
                  size: 20,
                  color: Colors.black,
                ),
                secondaryButtonWidget: const Icon(
                  Icons.close,
                  size: 20,
                  color: Colors.black,
                ),
                buttonWidget: const Icon(
                  Icons.search,
                  size: 20,
                  color: Colors.black,
                ),
                onChanged: _searchArticles,
                onFieldSubmitted: _searchArticles,
              ),
            ),
            Positioned(
              top: 60,
              left: 0,
              right: 0,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(_filters.length, (index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: FilterChip(
                        label: Text(_filters[index]),
                        selected: _selectedFilters[index],
                        onSelected: (bool selected) {
                          _toggleFilter(index);
                        },
                        selectedColor: Colors.teal,
                        backgroundColor: Colors.grey[200],
                        labelStyle: TextStyle(
                          color: _selectedFilters[index] ? Colors.white : Colors.black,
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),
            Positioned(
              top: 100,
              left: 0,
              right: 0,
              bottom: 0,
              child: FutureBuilder<List<Artikel>>(
                future: _futureArticles,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No articles found'));
                  } else {
                    return _displayedArticles.isEmpty
                        ? Lottie.asset('assets/vector/tiket_handle.json',repeat: false,)
                        : ListView.builder(
                            itemCount: _displayedArticles.length,
                            itemBuilder: (context, index) {
                              final artikel = _displayedArticles[index];
                              final item = snapshot.data![index];
                              return GestureDetector(
                                 onTap: () {
                                      _launchURL(item.slugPath); // Use slugPath for URL
                                    },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 8),
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    child: Container(
                                      width: screenWidth * 0.5,
                                      height: screenHeight * 0.2,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8.0),
                                        image: DecorationImage(
                                          image: NetworkImage(artikel.image),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      child: Stack(
                                        children: [
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
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Align(
                                              alignment: Alignment.bottomLeft,
                                              child: Text(
                                                artikel.judul,
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
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
            ),
          ],
        ),
      ),
    );
  }
}