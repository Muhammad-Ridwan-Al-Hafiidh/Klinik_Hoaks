import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:file_picker/file_picker.dart';
import 'package:klinik_hoaks/models/formulir.dart';
import 'dart:io';
import 'package:provider/provider.dart';
import 'package:klinik_hoaks/view/main_screen/main_screen.dart';
import 'package:klinik_hoaks/view/form/form_setting/custom_form_field.dart';
import 'package:klinik_hoaks/view/form/form_setting/form_validasi.dart';

class FormInfo extends StatefulWidget {
  const FormInfo({Key? key}) : super(key: key);

  @override
  State<FormInfo> createState() => _FormInfoState();
}

class _FormInfoState extends State<FormInfo> {
  final _formKey = GlobalKey<FormState>();
  File? _selectedFile;
  String? _fileType;
  bool isCaptchaVerified = false;

  late FormSubmission _formData;

  @override
  void initState() {
    super.initState();
    _formData = FormSubmission(
      nama: '',
      email: '',
      nohp: '',
      deskripsi: '',
      tiketNo: _generateTicketNumber(),
      createdAt: DateTime.now(), // Set createdAt to the current time
    );
  }

  String _generateTicketNumber() {
    // Implement your ticket number generation logic here
    return DateTime.now().millisecondsSinceEpoch.toString();
  }

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
    );

    setState(() {
      if (result != null) {
        _selectedFile = File(result.files.single.path!);
        _fileType = result.files.single.extension?.toLowerCase();
        _formData = FormSubmission(
          nama: _formData.nama,
          email: _formData.email,
          nohp: _formData.nohp,
          deskripsi: _formData.deskripsi,
          webLink: _formData.webLink,
          upload: _selectedFile?.path,
          tiketNo: _formData.tiketNo,
          createdAt: _formData.createdAt, // Retain the original createdAt
        );
      }
    });
  }

  Widget _buildFilePreview() {
    if (_selectedFile == null) {
      return const Text('No file selected');
    }

    if (_fileType == 'pdf') {
      return Text('PDF file selected: ${_selectedFile!.path.split('/').last}');
    } else {
      return Image.file(_selectedFile!, height: 200);
    }
  }

  void _updateFormData(FormValidasi model) {
    setState(() {
      _formData = FormSubmission(
        nama: model.name.value ?? '',
        email: model.email.value ?? '',
        nohp: model.phone.value ?? '',
        deskripsi: model.laporan.value ?? '',
        webLink: model.webLink.value,
        upload: _selectedFile?.path,
        tiketNo: _formData.tiketNo,
        createdAt: _formData.createdAt, // Retain the original createdAt
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    final _formProvider = Provider.of<FormValidasi>(context);

    return Scaffold(
      backgroundColor: Color.fromRGBO(0, 131, 116, 1.000),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                'Permohonan Klarifikasi',
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  elevation: 20,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.white,
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Card(
                              color: Color.fromRGBO(207, 244, 252, 1.000),
                              child: const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  'Kirimkan detail informasi yang kamu dapat, akan kami bantu cari klarifikasinya dalam 1x24 jam.',
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.blue),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text('Nama'),
                          ),
                          CustomFormField(
                            hintText: 'Name',
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                RegExp(r"[a-zA-Z]+|\s"),
                              )
                            ],
                            onChanged: (value) {
                              _formProvider.validateName(value);
                              _updateFormData(_formProvider);
                            },
                            errorText: _formProvider.name.error,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text('Email'),
                          ),
                          CustomFormField(
                            hintText: 'Email',
                            onChanged: (value) {
                              _formProvider.validateEmail(value);
                              _updateFormData(_formProvider);
                            },
                            errorText: _formProvider.email.error,
                            validator: (val) {
                              if (!val.isValidEmail) return 'Enter valid email';
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text('Nomor telepon'),
                          ),
                          CustomFormField(
                            hintText: 'Phone',
                            onChanged: (value) {
                              _formProvider.validatePhone(value);
                              _updateFormData(_formProvider);
                            },
                            errorText: _formProvider.phone.error,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                RegExp(r"[0-9]"),
                              )
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text('Masukkan laporan'),
                          ),
                          CustomFormField(
                            hintText: 'Isi Laporan',
                            maxLines: 5,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                RegExp(r".+"),
                              )
                            ],
                            onChanged: (value) {
                              _formProvider.validateLaporan(value);
                              _updateFormData(_formProvider);
                            },
                            errorText: _formProvider.laporan.error,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text('Link Web'),
                          ),
                          CustomFormField(
                            hintText: 'Web Link',
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                RegExp(r".+"),
                              )
                            ],
                            onChanged: (value) {
                              _formProvider.validateWebLink(value);
                              _updateFormData(_formProvider);
                            },
                            errorText: _formProvider.webLink.error,
                          ),
                          const SizedBox(height: 20),
                          Center(
                            child: ElevatedButton(
                              onPressed: _pickFile,
                              child: const Text('Choose Image or PDF File'),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Center(child: _buildFilePreview()),
                          const SizedBox(height: 20),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: screenWidth * 0.3,
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStatePropertyAll(
                                      Colors.white,
                                    ),
                                    shape: MaterialStatePropertyAll(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8))),
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MainScreen()));
                                  },
                                  child: Text('Cancel',
                                      style: TextStyle(color: Colors.black)),
                                ),
                              ),
                              Consumer<FormValidasi>(
                                builder: (context, model, child) {
                                  return SizedBox(
                                    width: screenWidth * 0.3,
                                    child: ElevatedButton(
                                      style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStatePropertyAll(
                                                  Colors.blue)),
                                      onPressed: () async {
                                        if (model.validate) {
                                          try {
                                            await insertFormData(_formData);

                                            showDialog(
                                              context: context,
                                              barrierDismissible: false,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: const Text(
                                                      'Terima kasih telah melaporkan'),
                                                  content:
                                                      SingleChildScrollView(
                                                    child: ListBody(
                                                      children: <Widget>[
                                                        Text(
                                                            'Mohon ditunggu dan berikut token Anda'),
                                                        Text(_formData.tiketNo),
                                                        Text(
                                                            'Silahkan menuju menu tiket untuk melihat status klarifikasi Anda')
                                                      ],
                                                    ),
                                                  ),
                                                  actions: <Widget>[
                                                    TextButton(
                                                      child: const Text('OK'),
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                        Navigator.of(context)
                                                            .pushReplacement(
                                                          MaterialPageRoute(
                                                            builder: (_) =>
                                                                const MainScreen(),
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          } catch (e) {
                                            // Handle the error, maybe show an error dialog
                                            print('Error saving data: $e');
                                            // Show error dialog
                                          }
                                        } else {
                                          // Show validation error dialog as before
                                        }
                                      },
                                      child: const Text('Submit',
                                          style:
                                              TextStyle(color: Colors.white)),
                                    ),
                                  );
                                },
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
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
