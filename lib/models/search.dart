import 'package:http/http.dart' as http;
import 'dart:convert';


class Artikel {
  final String judul;
  final String slugPath;
  final String image;

  Artikel({
    required this.judul,
    required this.slugPath,
    required this.image,
  });

  factory Artikel.fromJson(Map<String, dynamic> json) {
    return Artikel(
      judul: json['judul'],
      slugPath: json['slug_path'],
      image: json['image'],
    );
  }
}



class ArtikelService {
  final String apiUrl = 'https://demo-klinikhoaks.jatimprov.go.id/api/mobile/cari';

  Future<List<Artikel>> fetchArticles({String keywords = ''}) async {
    final response = await http.post(
      Uri.parse(apiUrl),
      body: {'keywords': keywords},
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonResponse = json.decode(response.body)['data'];
      return jsonResponse.map((json) => Artikel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load articles');
    }
  }
}