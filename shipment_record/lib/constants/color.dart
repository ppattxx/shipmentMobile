import 'package:flutter/material.dart';

class AppColors {
  static const Color primaryDark = Color(0xFF4A628A);  
  static const Color primaryMedium = Color(0xFF7AB2D3); 
  static const Color primaryLight = Color(0xFFB9E5E8);  

  // Gradient background
  static const LinearGradient backgroundGradient = LinearGradient(
    colors: [
      primaryDark, 
      primaryMedium, 
      primaryLight
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // Gradient button
  static const LinearGradient buttonGradient = LinearGradient(
    colors: [
      primaryLight, 
      primaryMedium, 
      primaryDark
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
