import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shipment_record/view/forms.dart';

class Sidebar extends StatelessWidget {
  final List<Map<String, String>> scannedData;
  final String modelCode;

  Sidebar({required this.scannedData, required this.modelCode});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Color(0xFF4A628A), // Background color
            ),
            child: Text(
              'Menu',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ListTile(
            title: Text('Form', style: GoogleFonts.poppins()),
            onTap: () {
              Navigator.pushReplacement(
                context, 
                MaterialPageRoute(
                  builder: (context) => FormsScreen(
                    scannedData: scannedData, 
                    modelCode: modelCode
                  ),
                ),
              );
            },
          ),
          ListTile(
            title: Text('Settings', style: GoogleFonts.poppins()),
            onTap: () {
              Navigator.pop(context); // Menutup sidebar
            },
          ),
          ListTile(
            title: Text('Logout', style: GoogleFonts.poppins()),
            onTap: () {
              Navigator.pop(context); // Menutup sidebar
            },
          ),
        ],
      ),
    );
  }
}

