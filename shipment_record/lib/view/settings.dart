import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shipment_record/constants/color.dart';
import 'package:shipment_record/view/forms.dart';
import 'package:shipment_record/view/login.dart';
import 'package:shipment_record/view/scanner.dart'; // Pastikan import yang benar

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _settingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Padding(
          padding: EdgeInsets.only(top: 20),
          child: Center(
            child: Text(
              'Settings',
              style: GoogleFonts.poppins(
                color: Colors.black,
                fontSize: 30,
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
                        Icons.qr_code,
                      ),
                      title: Text(
                        "Shipment Record",
                      ),
                      onTap: (){
                        Navigator.pushReplacement(
                          context, 
                          MaterialPageRoute(builder: (context) => ScannerScreen(shipmentCode: '', shipmentData: '',)),
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
                    _buildSettingField('Character', _settingController),
                    SizedBox(height: 20),
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
                            onTap: () {
                              if (_settingController.text.isNotEmpty) {
                                // Kirim nilai settingan ke halaman Scanner
                                int maxLength = int.tryParse(_settingController.text) ?? 0;
                                maxLength = maxLength > 0 ? maxLength : 10;
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ScannerScreen(maxLength: maxLength, shipmentCode: '', shipmentData: '',),
                                  ),
                                );
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

  Widget _buildSettingField(String label, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
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

        if (int.tryParse(value) == null) {
          return 'Hanya angka yang diperbolehkan';
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
