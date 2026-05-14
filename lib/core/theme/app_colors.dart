import 'package:flutter/material.dart';

class AppColors {
  static const white = Color(0xFFFFFFFF);
  static const snow = Color(0xFFF8F5FF);
  static const p50 = Color(0xFFF3EEFF);
  static const p100 = Color(0xFFE4D5FF);
  static const p200 = Color(0xFFC9AAFF);
  static const p400 = Color(0xFF9B6DFF);
  static const p500 = Color(0xFF7C3AED);
  static const p600 = Color(0xFF6D28D9);
  static const p700 = Color(0xFF5B21B6);
  static const ink = Color(0xFF1A0A2E);
  static const ink2 = Color(0xFF3D2060);

  static const homeBackground = LinearGradient(
    colors: [Color(0xFFFDFCFF), Color(0xFFF4EEFF), Color(0xFFEDE5FF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
