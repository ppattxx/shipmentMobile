import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Sidebar extends StatelessWidget {
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
            title: Text('Home', style: GoogleFonts.poppins()),
            onTap: () {
              // Tindakan untuk menu Home
              Navigator.pop(context); // Menutup sidebar
            },
          ),
          ListTile(
            title: Text('Shipment Input', style: GoogleFonts.poppins()),
            onTap: () {
              // Tindakan untuk menu Shipment Input
              Navigator.pop(context); // Menutup sidebar
            },
          ),
          ListTile(
            title: Text('Settings', style: GoogleFonts.poppins()),
            onTap: () {
              // Tindakan untuk menu Settings
              Navigator.pop(context); // Menutup sidebar
            },
          ),
        ],
      ),
    );
  }
}
