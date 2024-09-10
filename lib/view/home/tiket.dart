import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:klinik_hoaks/animation/src/searchbar.dart';
import 'package:url_launcher/url_launcher.dart'; // Add this import for launching URLs

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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
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
                Stack(
                  alignment: Alignment.center,
                  children: [
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
                        if (!isSearchBarOpens && _ticketController.text.isNotEmpty) {
                          _fetchTicketData(_ticketController.text);
                        }
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
                SizedBox(height: 20),
                _isLoading
                    ? CircularProgressIndicator()
                    : _ticketData != null
                        ? Container(
                            width: screenWidth * 1.7,
                            height: screenHeight * 0.4, // Adjust height if necessary
                            child: Card(
                              color: const Color.fromARGB(255, 250, 252, 250).withOpacity(0.5),
                              child: Padding(
                                padding: EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('No Tiket: ${_ticketData!['tiket_no'] ?? 'Data tidak tersedia'}'),
                                    Text('Nama: ${_ticketData!['nama'] ?? 'Data tidak tersedia'}'),
                                    Text('Uraian: ${_ticketData!['uraian'] ?? 'Data tidak tersedia'}'),
                                    Text('Link: ${_ticketData!['link'] ?? 'Data tidak tersedia'}'),
                                    if (_ticketData!['foto'] != null)
                                      InkWell(
                                        onTap: () => _launchURL(_ticketData!['foto']),
                                        child: Text(
                                          'Lihat Foto Pendukung',
                                          style: TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
                                        ),
                                      )
                                    else
                                      Text('Tidak ada foto/gambar pendukung'),
                                    Text('Jawaban: ${_ticketData!['jawaban'] ?? 'Belum ada jawaban, mohon ditunggu 1x24 jam.'}'),
                                  ],
                                ),
                              ),
                            ),
                          )
                        : Text('Tidak ada data ditemukan'),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
