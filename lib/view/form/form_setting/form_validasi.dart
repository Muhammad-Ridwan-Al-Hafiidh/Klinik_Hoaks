import 'package:flutter/material.dart';

extension extString on String? {
  bool get isValidLaporan {
    if (this == null) return false;
    final laporanRegExp = RegExp(r".+"); // Ensure not empty
    return laporanRegExp.hasMatch(this!);
  }

  bool get isValidEmail {
    if (this == null) return false;
    final emailRegExp = RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$");
    return emailRegExp.hasMatch(this!);
  }

  bool get isValidLink {
    if (this == null) return false;
    final linkRegExp = RegExp(r".+");
    return linkRegExp.hasMatch(this!);
  }

  bool get isValidName {
    if (this == null) return false;
    final nameRegExp = RegExp(r"^[a-zA-Z\s]+$");
    return nameRegExp.hasMatch(this!);
  }

  bool get isValidPhone {
    if (this == null) return false;
    final phoneRegExp = RegExp(r"^\+?0[0-9]{11,12}$");
    return phoneRegExp.hasMatch(this!);
  }
}

class ValidationModel {
  String? value;
  String? error;
  ValidationModel(this.value, this.error);
}

class FormValidasi extends ChangeNotifier {
  void validateLaporan(String? val) {
    if (val == null || val.isValidLaporan) {
      _laporan = ValidationModel(val, null);
    } else {
      _laporan = ValidationModel(null, "Laporan harus di isi");
    }
    notifyListeners();
  }

  void validateWebLink(String? val) {
    if (val == null || val.isValidLink) {
      _webLink = ValidationModel(val, null);
    } else {
      _webLink = ValidationModel(null, "Web link harus di isi yang valid dan jelas");
    }
    notifyListeners();
  }

  void validateEmail(String? val) {
    if (val != null && val.isValidEmail) {
      _email = ValidationModel(val, null);
    } else {
      _email = ValidationModel(null, 'Contoh: ***@gmail.com, dll');
    }
    notifyListeners();
  }

  void validateName(String? val) {
    if (val != null && val.isValidName) {
      _name = ValidationModel(val, null);
    } else {
      _name = ValidationModel(null, 'Nama harus di isi');
    }
    notifyListeners();
  }

  void validatePhone(String? val) {
    if (val != null && val.isValidPhone) {
      _phone = ValidationModel(val, null);
    } else {
      _phone = ValidationModel(null, 'Nomor telepon harus berjumlah 12 digits');
    }
    notifyListeners();
  }

  bool get validate {
    return _email.value != null &&
        _phone.value != null &&
        _name.value != null &&
        _laporan.value != null &&
        _webLink.value != null;
  }

  ValidationModel _name = ValidationModel(null, null);
  ValidationModel _email = ValidationModel(null, null);
  ValidationModel _phone = ValidationModel(null, null);
  ValidationModel _laporan = ValidationModel(null, null);
  ValidationModel _webLink = ValidationModel(null, null);

  // getters
  ValidationModel get name => _name;
  ValidationModel get email => _email;
  ValidationModel get phone => _phone;
  ValidationModel get laporan => _laporan;
  ValidationModel get webLink => _webLink;
}
