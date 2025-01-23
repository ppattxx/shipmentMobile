import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shipment_record/api/api_service.dart';
import 'package:shipment_record/constants/color.dart';
import 'package:shipment_record/view/login.dart';
import 'package:shipment_record/view/scanner.dart';

class ShipmentCode extends StatefulWidget {
  @override
  _ShipmentCodeState createState() => _ShipmentCodeState();
}

class _ShipmentCodeState extends State<ShipmentCode> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _settingController = TextEditingController();
  bool _isLoading = false;  // Untuk indikator loading

  // Menampilkan dialog error
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Menutup dialog
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => LoginScreen()),
            );
          },
        ),
        title: Padding(
          padding: EdgeInsets.only(top: 20),
          child: Center(
            child: Text(
              'Shipment Code',
              style: GoogleFonts.poppins(
                color: Colors.black,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: AppColors.backgroundGradient,
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _buildSettingField('Shipment Code', _settingController),
                    SizedBox(height: 20),
                    _isLoading 
                        ? Center(child: CircularProgressIndicator()) 
                        : SizedBox(
                      width: double.infinity,
                      child: Material(
                        borderRadius: BorderRadius.circular(6),
                        elevation: 5,
                        child: Ink(
                          decoration: BoxDecoration(
                            gradient: AppColors.buttonGradient,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: InkWell(
                            onTap: () {
                              if (_formKey.currentState?.validate() ?? false) {
                                _fetchShipmentData();
                              }
                            },
                            borderRadius: BorderRadius.circular(6),
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              alignment: Alignment.center,
                              child: Text(
                                'Apply',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

Future<void> _fetchShipmentData() async {
  setState(() {
    _isLoading = true; // Menampilkan indikator loading
  });

  // Mendapatkan token dari SharedPreferences
  final String? token = await ApiService().getToken();
  String shipmentCode = _settingController.text.trim();

  // Mendapatkan NIK yang sudah disimpan
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String? nik = prefs.getString('nik'); // Ambil NIK yang sudah disimpan

  // Pastikan NIK dan token ada sebelum mengirimkannya ke server
  if (nik != null && token != null) {
    // Kirim NIK dan shipmentCode ke server
    bool isNikPosted = await ApiService().submitNikData(token, nik, shipmentCode);

    if (isNikPosted) {
      print("NIK berhasil dikirim.");
      // Pindah ke layar scanner setelah berhasil
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ScannerScreen(shipmentCode: '', shipmentData: '',)),
      );
    } else {
      _showErrorDialog('Gagal mengirimkan NIK.');
    }
  } else {
    _showErrorDialog('NIK atau Token tidak ditemukan.');
  }

  // Pastikan token dan shipmentCode valid
  if (token != null && shipmentCode.isNotEmpty) {
    try {
      final shipmentData = await ApiService().getShipmentData(token, shipmentCode);

      print('Data Shipment yang diterima: $shipmentData');

      if (shipmentData != null) {
        // Ambil modelCode dari data shipment
        String modelCode = shipmentData['modelCode'];
        print('Model Code: $modelCode');

        if (modelCode != "") {
          // Data ditemukan, lakukan sesuatu dengan modelCode
        } else {
          _showErrorDialog('Model Code tidak ditemukan dalam data shipment.');
        }
      } else {
        _showErrorDialog('Shipment Code tidak ditemukan atau terjadi kesalahan.');
      }
    } catch (e) {
      _showErrorDialog('Terjadi kesalahan: $e');
    }
  } else {
    _showErrorDialog('Token tidak valid atau Shipment Code kosong.');
  }

  setState(() {
    _isLoading = false; // Sembunyikan indikator loading
  });
}


  Widget _buildSettingField(String label, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        filled: true,
        fillColor: Colors.white,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '$label tidak boleh kosong';
        }
        return null;
      },
    );
  }

  @override
  void dispose() {
    _settingController.dispose();
    super.dispose();
  }
}