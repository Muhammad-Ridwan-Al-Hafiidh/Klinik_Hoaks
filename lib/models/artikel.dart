class Artikel {
  final int id;
  final String title;
  final int jumlahPengunjung;
  final String createdAt;
  final String webLink;
  final String uraian;
  final String image;

  Artikel({
    required this.id,
    required this.title,
    required this.jumlahPengunjung,
    required this.createdAt,
    required this.webLink,
    required this.uraian,
    required this.image,
  });

  factory Artikel.fromJson(Map<String, dynamic> json) {
    return Artikel(
      id: json['id'],
      title: json['title'],
      jumlahPengunjung: json['jumlah_pengunjung'],
      createdAt: json['created_at'],
      webLink: json['web_link'],
      uraian: json['uraian'],
      image: json['image'],
    );
  }
}