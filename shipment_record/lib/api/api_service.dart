import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl = 'http://10.83.34.43/ShipApi/api/';

  // Fungsi untuk login dan menyimpan token dan NIK di SharedPreferences
Future<bool> login(BuildContext context, String nik, String password) async {
  final url = Uri.parse('${baseUrl}User/Login');
  try {
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({"nik": nik, "password": password}),
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

      if (data['token'] != null) {
        // Simpan token dan NIK di SharedPreferences
        String token = data['token'];
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', token);
        await prefs.setString('nik', nik);

        return true;
      } else {
        _showLoginError(context, 'Token tidak ditemukan. Login gagal.');
        return false;
      }
    } else if (response.statusCode == 401) {
      _showLoginError(context, 'NIK atau password salah.');
      return false;
    } else {
      _showLoginError(context, 'Terjadi kesalahan pada server.');
      return false;
    }
  } catch (e) {
    print('Error: $e');
    _showLoginError(context, 'Tidak dapat terhubung ke server.');
    return false;
  }
}


// Fungsi untuk mengirimkan NIK ke server
Future<bool> submitNikData(String token, String nik, String shipmentCode) async {
  final url = Uri.parse('${baseUrl}Shipment/ShipUserPost');

  try {
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "id": 0,
        "userNik": nik,
        "shipmentCode": shipmentCode,
      }),
    ).timeout(Duration(seconds: 10), onTimeout: () {
      throw TimeoutException("Koneksi ke server timeout.");
    });

    if (response.statusCode == 200) {
      print("NIK berhasil dikirim!");
      return true;
    } else {
      print("Error: ${response.statusCode} - ${response.body}");
      return false; 
    }
  } catch (e) {
    print("Error: $e");
    return false; 
  }
}

  // Fungsi untuk mendapatkan token dari SharedPreferences
  Future<String?> getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token'); 
  }

  // Fungsi untuk POST data dari ScannerScreen
  Future<bool> submitScanData(String serialNumber, String shipmentCode, String modelCode) async {
    final url = Uri.parse('${baseUrl}SerialNum/CreateSerialNum');

    try {
      final requestBody = {
        "id": 0,
        "SerialNumber": serialNumber.trim(),
        "ShipmentCode": shipmentCode.trim(),
        "ModelCode": modelCode.trim(),
      };

      print('Sending Data: ${jsonEncode(requestBody)}');

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestBody),
      ).timeout(Duration(seconds: 10), onTimeout: () {
        throw TimeoutException("Koneksi ke server timeout.");
      });

      if (response.statusCode == 200) {
        print("Data berhasil dikirim!");
        return true;
      } else {
        print("Error: ${response.statusCode} - ${response.body}");
        return false;
      }
    } catch (e) {
      print("Error: $e");
      return false;
    }
  }

  // Fungsi untuk GET data dengan token
  Future<Map<String, dynamic>?> getShipmentData(String token, String shipmentCode) async {
    final url = Uri.parse('${baseUrl}Shipment/GetShipmentByCode?code=${Uri.encodeComponent(shipmentCode)}');
    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        print('Data diterima: ${response.body}');
        var data = jsonDecode(response.body);

        // Extract data yang diperlukan
        String code = data['code'];  
        String modelCode = data['modelCode'];  

        print('Shipment Code: $code');
        print('Model Code: $modelCode');

        // Return data yang dibutuhkan
        return data;
      } else {
        print('Error: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  // Fungsi untuk menampilkan dialog kesalahan login
  void _showLoginError(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Login Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
