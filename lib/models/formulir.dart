import 'dart:math';

import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

class FormSubmission {
  final int? id;
  final int? jenisId;
  final String nama;
  final String email;
  final String nohp;
  final String deskripsi;
  final String? webLink;
  final String? upload;
  final String? status;
  final String tiketNo;
final DateTime createdAt;

  FormSubmission({
    this.id,
    this.jenisId,
    required this.nama,
    required this.email,
    required this.nohp,
    required this.deskripsi,
    this.webLink,
    this.upload,
    this.status,
    required this.tiketNo,
   required this.createdAt,
  });

  factory FormSubmission.fromJson(Map<String, dynamic> json) {
    return FormSubmission(
      id: json['id'],
      jenisId: json['jenis_id'],
      nama: json['nama'],
      email: json['email'],
      nohp: json['nohp'],
      deskripsi: json['deskripsi'],
      webLink: json['web_link'],
      upload: json['upload'],
      status: json['status'],
      tiketNo: json['tiket_no'],
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : DateTime.now(), // Default to now if null
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'jenis_id': jenisId,
      'nama': nama,
      'email': email,
      'nohp': nohp,
      'deskripsi': deskripsi,
      'web_link': webLink,
      'upload': upload,
      'status': status,
      'tiket_no': tiketNo,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'FormSubmission(id: $id, jenisId: $jenisId, nama: $nama, email: $email, nohp: $nohp, deskripsi: $deskripsi, webLink: $webLink, upload: $upload, status: $status, tiketNo: $tiketNo, createdAt: ${DateFormat('yyyy-MM-dd HH:mm:ss').format(createdAt)})';
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
