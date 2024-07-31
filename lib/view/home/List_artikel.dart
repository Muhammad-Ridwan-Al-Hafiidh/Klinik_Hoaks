import 'package:flutter/material.dart';
import 'package:klinik_hoaks/animation/src/searchbar.dart';

class ListArtikel extends StatefulWidget {
  const ListArtikel({super.key});

  @override
  State<ListArtikel> createState() => ListArtikeState();
}

class ListArtikeState extends State<ListArtikel> {
  bool _isSearchBarOpen = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cek Hoaks atau Fakta ?'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              // Text layer
              Positioned(
                top: 10, // Adjust this value as needed
                child: AnimatedOpacity(
                  opacity: _isSearchBarOpen ? 0.0 : 1.0,
                  duration: Duration(milliseconds: 200),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8, left: 16 ),
                    child: Text(
                      'Masukkan Kata Kunci Anda',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ),
              // SearchBar layer
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: SearchBarAnimation(
                  textEditingController: TextEditingController(),
                  isOriginalAnimation: true,
                  enableKeyboardFocus: true,
                  onExpansionComplete: () {
                    setState(() {
                      _isSearchBarOpen = true;
                    });
                    debugPrint('do something just after searchbox is opened.');
                  },
                  onCollapseComplete: () {
                    setState(() {
                      _isSearchBarOpen = false;
                    });
                    debugPrint('do something just after searchbox is closed.');
                  },
                  onPressButton: (isSearchBarOpens) {
                    debugPrint(
                        'do something before animation started. It\'s the ${isSearchBarOpens ? 'opening' : 'closing'} animation');
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
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}