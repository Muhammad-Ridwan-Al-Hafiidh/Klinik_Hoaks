import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:klinik_hoaks/animation/src/searchbar.dart';
import 'package:url_launcher/url_launcher.dart';

class Tiket extends StatefulWidget {
  const Tiket({super.key});

  @override
  State<Tiket> createState() => _TiketState();
}

class _TiketState extends State<Tiket> {
  bool _isSearchBarOpen = false;
  TextEditingController _ticketController = TextEditingController();
  Map<String, dynamic>? _ticketData;
  bool _isLoading = false;

  Future<void> _fetchTicketData(String ticketNo) async {
    setState(() {
      _isLoading = true;
    });

    final response = await http.post(
      Uri.parse('https://demo-klinikhoaks.jatimprov.go.id/api/mobile/lacak'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'tiket': ticketNo}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['result'] == "true") {
        setState(() {
          _ticketData = data['data'];
          _ticketData!['tiket_no'] = ticketNo;
        });
      } else {
        setState(() {
          _ticketData = null;
        });
      }
    } else {
      setState(() {
        _ticketData = null;
      });
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Pelacakan Tiket Permohonan Anda',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(16),
                  color: Colors.blue.withOpacity(0.5),
                  child: Text(
                    'Hasil Pelacakan Permohonan Anda',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  padding: EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color:  Color.fromARGB(255, 0, 131, 116).withOpacity(0.9),
                    borderRadius: BorderRadius.circular(10)
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      AnimatedOpacity(
                        opacity: _isSearchBarOpen ? 0.0 : 1.0,
                        duration: Duration(milliseconds: 200),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 2, left: 16),
                          child: Text(
                            'Masukkan No Tiket Anda',
                            style: TextStyle(fontSize: 16,color: Colors.white),
                          ),
                        ),
                      ),
                      SearchBarAnimation(
                        textEditingController: _ticketController,
                        isOriginalAnimation: true,
                        enableKeyboardFocus: true,
                        onExpansionComplete: () {
                          setState(() {
                            _isSearchBarOpen = true;
                          });
                        },
                        onCollapseComplete: () {
                          setState(() {
                            _isSearchBarOpen = false;
                          });
                        },
                        onPressButton: (isSearchBarOpens) {
                          // Trigger search only if search bar is closed and there is text to search
                          if (!isSearchBarOpens &&
                              _ticketController.text.isNotEmpty) {
                            _fetchTicketData(_ticketController.text);
                          }
                        },
                        onFieldSubmitted: (value) {
                          // Trigger search on keyboard submission
                          if (value.isNotEmpty) {
                            _fetchTicketData(value);
                          }
                        },
                        trailingWidget: GestureDetector(
                          onTap: () {
                            _ticketController.clear();
                          },
                          child: const Icon(
                            Icons.close,
                            size: 20,
                            color: Colors.black,
                          ),
                        ),
                        secondaryButtonWidget: const Icon(
                          Icons.arrow_back,
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
                ),
                SizedBox(height: 20),
                _isLoading
                    ? CircularProgressIndicator()
                    : _ticketData != null
                        ? Container(
                            width: screenWidth * 1.7,
                            height: screenHeight * 0.4, // Adjust height if necessary
                            child: Card(
                              color: const Color.fromARGB(255, 250, 252, 250)
                                  .withOpacity(0.5),
                              child: Padding(
                                padding: EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        'No Tiket: ${_ticketData!['tiket_no'] ?? 'Data tidak tersedia'}'),
                                    Text(
                                        'Nama: ${_ticketData!['nama'] ?? 'Data tidak tersedia'}'),
                                    Text(
                                        'Uraian: ${_ticketData!['uraian'] ?? 'Data tidak tersedia'}'),
                                    Text(
                                        'Link: ${_ticketData!['link'] ?? 'Data tidak tersedia'}'),
                                    if (_ticketData!['foto'] != null)
                                      InkWell(
                                        onTap: () =>
                                            _launchURL(_ticketData!['foto']),
                                        child: Text(
                                          'Lihat Foto Pendukung',
                                          style: TextStyle(
                                              color: Colors.blue,
                                              decoration:
                                                  TextDecoration.underline),
                                        ),
                                      )
                                    else
                                      Text('Tidak ada foto/gambar pendukung'),
                                    Text(
                                        'Jawaban: ${_ticketData!['jawaban'] ?? 'Belum ada jawaban, mohon ditunggu 1x24 jam.'}'),
                                  ],
                                ),
                              ),
                            ),
                          )
                        : Column(
                          children: [
                            Lottie.asset('assets/vector/tiket_handle.json',repeat: false,),
                          ],
                        ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
