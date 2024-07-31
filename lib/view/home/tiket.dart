import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:klinik_hoaks/animation/searchbar_animation.dart';
import 'package:klinik_hoaks/animation/src/searchbar.dart';
import 'package:klinik_hoaks/view/article/lacak_tiket.dart';

class Tiket extends StatefulWidget {
  const Tiket({super.key});

  @override
  State<Tiket> createState() => _TiketState();
}

class _TiketState extends State<Tiket> {
  bool _isSearchBarOpen = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Pelacakan Tiket Permohonan Anda',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Widget above SearchBarAnimation
                Container(
                  padding: EdgeInsets.all(16),
                  color: Colors.blue.withOpacity(0.5),
                  child: Text(
                    'This is a new widget above the search bar',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                SizedBox(height: 20), // Add spacing between the widgets
                Stack(
                  alignment: Alignment.center,
                  children: [
                    // Widget below SearchBarAnimation
                    AnimatedOpacity(
                      opacity: _isSearchBarOpen ? 0.0 : 1.0,
                      duration: Duration(milliseconds: 200),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8, left: 16),
                        child: Text(
                          'Masukkan No Tiket Anda',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                    // SearchBar layer
                    SearchBarAnimation(
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
                      hintText: 'Masukkan Tiket Valid',
                    ),
                  ],
                ),
                SizedBox(height: 20), // Add spacing between the widgets
                Container(
                  padding: EdgeInsets.all(16),
                  color: Colors.red.withOpacity(0.5),
                  child: Text(
                    'This is a new widget below the search bar',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
