import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'package:klinik_hoaks/models/formulir.dart';
import 'package:klinik_hoaks/view/main_screen/main_screen.dart';
import 'package:klinik_hoaks/view/form/form_setting/custom_form_field.dart';
import 'package:klinik_hoaks/view/form/form_setting/form_validasi.dart';
import 'package:provider/provider.dart';

class FormInfo extends StatefulWidget {
  const FormInfo({Key? key}) : super(key: key);

  @override
  State<FormInfo> createState() => _FormInfoState();
}

class _FormInfoState extends State<FormInfo> {
  final _formKey = GlobalKey<FormState>();
  File? _selectedFile;
  String? _fileType;
  late FormSubmission _formData;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _formData = FormSubmission(
      nama: '',
      email: '',
      nohp: '',
      uraian: '',
      createdAt: DateTime.now(), // Set createdAt to the current time
    );
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
          uraian: _formData.uraian,
          link: _formData.link,
          foto: _selectedFile?.path,
          createdAt: _formData.createdAt, // Retain the original createdAt
        );
      }
    });
  }

  Future<void> _captureImageFromCamera() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);

    if (image != null) {
      setState(() {
        _selectedFile = File(image.path);
        _fileType = 'jpg'; // Assume it's a jpg or jpeg from the camera
        _formData = FormSubmission(
          nama: _formData.nama,
          email: _formData.email,
          nohp: _formData.nohp,
          uraian: _formData.uraian,
          link: _formData.link,
          foto: _selectedFile?.path,
          createdAt: _formData.createdAt, // Retain the original createdAt
        );
      });
    }
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
        uraian: model.laporan.value ?? '',
        link: model.webLink.value,
        foto: _selectedFile?.path,
        createdAt: _formData.createdAt, // Retain the original createdAt
      );
    });
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      try {
        // Step 1: Submit form data (excluding image) to get the ticket number
        final ticketNo = await _generateTicketNumber();

        // Step 2: Upload the image with the ticket number
        if (_selectedFile != null) {
          await _uploadImageWithTicket(ticketNo);
        }

        // After successful submission, navigate or show success message
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Terima kasih telah melaporkan'),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    const Text('Mohon ditunggu dan berikut token Anda'),
                    Row(
                      children: [
                        Expanded(child: Text(ticketNo)),
                        IconButton(
                          icon: const Icon(Icons.copy),
                          onPressed: () {
                            Clipboard.setData(ClipboardData(text: ticketNo));
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Ticket number copied to clipboard')),
                            );
                          },
                        ),
                      ],
                    ),
                    const Text('Silahkan menuju menu tiket untuk melihat status klarifikasi Anda'),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (_) => const MainScreen()),
                    );
                  },
                ),
              ],
            );
          },
        );
      } catch (e) {
        print('Error submitting form: $e');
      }
    }
  }

  Future<String> _generateTicketNumber() async {
    final url = Uri.parse('https://demo-klinikhoaks.jatimprov.go.id/api/mobile/aduan');
    final request = http.MultipartRequest('POST', url);

    request.fields['nama'] = _formData.nama;
    request.fields['nohp'] = _formData.nohp;
    request.fields['email'] = _formData.email;
    request.fields['uraian'] = _formData.uraian;
    request.fields['link'] = _formData.link ?? '';

    final response = await request.send();

    if (response.statusCode == 200) {
      final responseBody = await response.stream.bytesToString();
      final responseData = json.decode(responseBody);

      if (responseData['result'] == 'true') {
        return responseData['data']['tiket_no'] ?? '';
      } else {
        throw Exception('Failed to generate ticket number');
      }
    } else {
      throw Exception('Failed to generate ticket number');
    }
  }

  Future<void> _uploadImageWithTicket(String ticketNo) async {
    final url = Uri.parse('https://demo-klinikhoaks.jatimprov.go.id/api/mobile/uploadfotoaduan');
    final request = http.MultipartRequest('POST', url);

    request.fields['tiket_no'] = ticketNo;

    if (_formData.foto != null) {
      final file = await http.MultipartFile.fromPath('foto', _formData.foto!);
      request.files.add(file);
    }

    final response = await request.send();

    if (response.statusCode == 200) {
      final responseBody = await response.stream.bytesToString();
      final responseData = json.decode(responseBody);

      if (responseData['result'] == 'true') {
        print('Image uploaded successfully');
      } else {
        throw Exception('Failed to upload image');
      }
    } else {
      throw Exception('Failed to upload image');
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    final _formProvider = Provider.of<FormValidasi>(context);

    return Scaffold(
      backgroundColor: const Color.fromRGBO(0, 131, 116, 1.000),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Text(
                'Permohonan Klarifikasi',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
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
                              color: const Color.fromRGBO(207, 244, 252, 1.000),
                              child: const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  'Kirimkan detail informasi yang kamu dapat, akan kami bantu cari klarifikasinya dalam 1x24 jam.',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.blue,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(left: 10),
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
                          const Padding(
                            padding: EdgeInsets.only(left: 10),
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
                          const Padding(
                            padding: EdgeInsets.only(left: 10),
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
                          const Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: Text('Uraian'),
                          ),
                          CustomFormField(
                            hintText: 'Detail information',
                            maxLines: 3,
                            onChanged: (value) {
                              _formProvider.validateLaporan(value);
                              _updateFormData(_formProvider);
                            },
                            errorText: _formProvider.laporan.error,
                          ),
                          const Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: Text('Link terkait'),
                          ),
                          CustomFormField(
                            hintText: 'Optional',
                            onChanged: (value) {
                              _formProvider.validateWebLink(value);
                              _updateFormData(_formProvider);
                            },
                            errorText: _formProvider.webLink.error,
                          ),
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text('Upload Image'),
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.upload_file),
                                onPressed: _pickFile,
                              ),
                              IconButton(
                                icon: const Icon(Icons.camera_alt),
                                onPressed: _captureImageFromCamera,
                              ),
                            ],
                          ),
                          _buildFilePreview(),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Center(
                              child: ElevatedButton(
                                onPressed: _submitForm,
                                child: const Text('Submit'),
                              ),
                            ),
                          ),
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
