import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shipment_record/constants/color.dart';
import 'package:shipment_record/api/api_service.dart';
import 'package:shipment_record/view/login.dart';
import 'package:shipment_record/view/settings.dart';

class ScannerScreen extends StatefulWidget {
  final int maxLength;
  final String shipmentCode;
  // final Map<String, dynamic> shipmentData;
  final String shipmentData;


  ScannerScreen({this.maxLength = 0, required this.shipmentCode, required this.shipmentData});

  @override
  _ScannerScreenState createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _codeController = TextEditingController();
  List<Map<String, String>> _scannedData = [];
  int _totalSubmitted = 0;
  String? modelCode;


  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    int inputMaxLength = widget.maxLength > 0 ? widget.maxLength : 10;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.logout_sharp, color: Colors.redAccent),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => LoginScreen()),
            );
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => SettingsPage()),
              );
            },
          ),
        ],
        title: Padding(
          padding: EdgeInsets.only(top: 20),
          child: Center(
            child: Text(
              'SHIPMENT RECORD',
              style: GoogleFonts.poppins(
                color: Colors.black,
                fontSize: screenHeight * 0.03,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
      body: Container(
        width: screenWidth,
        height: screenHeight,
        decoration: BoxDecoration(
          gradient: AppColors.backgroundGradient,
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.1,
            vertical: screenHeight * 0.1,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 80),
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      _buildTextField('Code', _codeController, inputMaxLength),
                      SizedBox(height: 10),
                      SizedBox(
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
                              onTap: _handleSubmit,
                              borderRadius: BorderRadius.circular(6),
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 10),
                                alignment: Alignment.center,
                                child: Text(
                                  'Submit',
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
                      SizedBox(height: 20),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    'Total Submitted: $_totalSubmitted',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                _scannedData.isNotEmpty
                    ? Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Nomor',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                'Serial Number',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          SizedBox(
                            height: screenHeight * 0.3,
                            child: ListView.builder(
                              itemCount: _scannedData.length,
                              itemBuilder: (context, index) {
                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('${index + 1}'),
                                    Text(_scannedData[index]['serialNumber']!),
                                  ],
                                );
                              },
                            ),
                          ),
                        ],
                      )
                    : Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, int? maxLength) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      maxLength: maxLength != null && maxLength > 0 ? maxLength : null,
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

  void _handleSubmit() async {
    if (_formKey.currentState?.validate() ?? false) {
      String inputCode = _codeController.text;

      bool isDuplicate = _scannedData.any((item) => item['serialNumber'] == inputCode);

      if (isDuplicate) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Kode ini sudah pernah disubmit!')),
        );
      } else {
        setState(() {
          _scannedData.add({'serialNumber': inputCode});
          _totalSubmitted++;
          _codeController.clear();
        });

        // Ambil token sebelum mengirim data
        String? token = await ApiService().getToken();

        // Kirim data ke API jika token valid
        if (token != null) {
          _submitScannedData(inputCode, token);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Token atau Model Code tidak ditemukan')),
          );
        }
      }
    }
  }

  Future<void> _submitScannedData(String serialNumber, String token) async {
    try {
      bool success = await ApiService().submitScanData(
        serialNumber,
        widget.shipmentCode,
        widget.shipmentData,
      );

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Data berhasil disubmit!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal mengirim data!')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Terjadi kesalahan: $e')),
      );
    }
  }
}