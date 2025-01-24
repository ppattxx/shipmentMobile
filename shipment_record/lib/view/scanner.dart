import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shipment_record/constants/color.dart';
import 'package:shipment_record/api/api_service.dart';
import 'package:shipment_record/view/forms.dart';
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
  Map<String, dynamic> shipmentDetails = {};
  bool isLoading = true;
  String? modelCode;

void initState() {
  super.initState();
  _fetchShipmentData();
}


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
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
              color: AppColors.primaryDark,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Menu",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.table_chart,
              ),
              title: Text(
                "Forms",
              ),
              onTap: (){
                Navigator.pushReplacement(
                  context, 
                  MaterialPageRoute(builder: (context) => FormsScreen(scannedData: [], modelCode: '')),
                );
              },
            ),
            ListTile(
              leading: Icon(
                Icons.settings,
              ),
              title: Text(
                "Settings",
              ),
              onTap: (){
                Navigator.pushReplacement(
                  context, 
                  MaterialPageRoute(builder: (context) => SettingsPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(
                Icons.logout,
                color: Colors.red,
              ),
              title: Text(
                "Logout",
              ),
              onTap: (){
                Navigator.pushReplacement(
                  context, 
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
            )
          ],
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
                _buildShipmentDetails(),
                SizedBox(height: 20),
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
              ],
            ),
          ),
        ),
      ),
    );
  }

      Widget _buildShipmentDetails() {
        return Container(
          padding: EdgeInsets.all(10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Kolom kiri
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDetailRow("Date of Shipment", _formatDate(shipmentDetails['date'])),
                    _buildDetailRow("Model", shipmentDetails['model'] ?? 'N/A'),
                    _buildDetailRow("Quantity Shipment", shipmentDetails['quantity'].toString()),
                    _buildDetailRow("Destination", shipmentDetails['destination'] ?? 'N/A'),
                  ],
                ),
              ),
              // Kolom kanan
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDetailRow("Truck Police No.", shipmentDetails['truckNo'] ?? 'N/A'),
                    _buildDetailRow("Urutan Container.", shipmentDetails['containerOrder'] ?? 'N/A'),
                    _buildDetailRow("Container No.", shipmentDetails['containerNo'] ?? 'N/A'),
                    _buildDetailRow("Seal No.", shipmentDetails['sealNo'] ?? 'N/A'),
                  ],
                ),
              ),
            ],
          ),
        );
      }

// Fungsi untuk memformat DateTime ke string
String _formatDate(dynamic date) {
  if (date == null) return 'N/A';

  if (date is String) {
    // Jika formatnya sudah dalam bentuk string ISO8601
    try {
      DateTime parsedDate = DateTime.parse(date);
      return DateFormat('dd-MM-yyyy').format(parsedDate);
    } catch (e) {
      return 'Invalid Date';
    }
  }

  if (date is DateTime) {
    return DateFormat('dd-MM-yyyy').format(date);
  }

  return 'Invalid Date';
}

Widget _buildDetailRow(String label, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "$label : ",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(color: Colors.black),
          ),
        ),
      ],
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
        _codeController.clear();
      });

      // Ambil token sebelum mengirim data
      String? token = await ApiService().getToken();

      // Kirim data ke API jika token valid
      if (token != null) {
        await _submitScannedData(inputCode, token);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Token atau Model Code tidak ditemukan')),
        );
      }
      

      // Clear the scanned data list after submission
      setState(() {
        _scannedData.clear();
      });
    }
  }
}

Future<void> _fetchShipmentData() async {
  String? token = await ApiService().getToken();
  if (token != null) {
    var data = await ApiService().getShipmentData(token, widget.shipmentCode);
    if (data != null) {
      setState(() {
        shipmentDetails = data;  // Simpan data ke dalam state
      });
    }
  }
}

  Future<void> _submitScannedData(String serialNumber, String token) async {
  try {
    DateTime currentDate = DateTime.now();

    bool success = await ApiService().submitScanData(
      serialNumber,
      widget.shipmentCode,
      widget.shipmentData,
      currentDate,  // Tambahkan parameter date sesuai API
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