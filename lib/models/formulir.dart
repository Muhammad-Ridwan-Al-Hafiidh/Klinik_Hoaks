import 'dart:math';

import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

class FormSubmission {
  final String nama;
  final String email;
  final String nohp;
  final String uraian;
  final String? link;
  final String? foto;
  final String? tiket_no;
final DateTime createdAt;

  FormSubmission({
    required this.nama,
    required this.email,
    required this.nohp,
    required this.uraian,
    this.link,
    this.foto,
    this.tiket_no,
   required this.createdAt,
  });

  factory FormSubmission.fromJson(Map<String, dynamic> json) {
    return FormSubmission(
      nama: json['nama'],
      email: json['email'],
      nohp: json['nohp'],
      uraian: json['uraian'],
      link: json['web_link'],
      foto: json['foto'],
      tiket_no: json['tiket_no'],
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : DateTime.now(), // Default to now if null
    );
  }

  Map<String, dynamic> toJson() {
    return {
  
      'nama': nama,
      'email': email,
      'nohp': nohp,
      'uraian': uraian,
      'web_link': link,
      'foto': foto,
      'tiket_no': tiket_no,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'FormSubmission(nama: $nama, email: $email, nohp: $nohp, uraian: $uraian, link: $link, foto: $foto, tiket_no: $tiket_no, createdAt: ${DateFormat('yyyy-MM-dd HH:mm:ss').format(createdAt)})';
  }
}

Future<void> insertFormData(FormSubmission formData) async {
  try {
    var json = formData.toJson();
    json.remove('id');  // Remove the 'id' field

    final response = await Supabase.instance.client
        .from('form')
        .insert(json);

    if (response.error != null) {
      throw response.error!;
    }

    print('Data inserted successfully');
  } catch (e) {
    print('Error inserting data: $e');
    rethrow;
  }
}


String _generateTicketNumber() {
  // Generate a unique ticket number using UUID combined with a random number
  final random = Random();
  final randomNumber = random.nextInt(1000000); // Generates a random number between 0 and 999999
  return '${Uuid().v4()}-$randomNumber';
}
