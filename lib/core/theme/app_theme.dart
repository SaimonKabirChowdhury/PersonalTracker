import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

class AppTheme {
  static ThemeData light() {
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.p500,
        brightness: Brightness.light,
      ),
      scaffoldBackgroundColor: AppColors.snow,
    );

    return base.copyWith(
      textTheme: GoogleFonts.rajdhaniTextTheme(base.textTheme).copyWith(
        headlineMedium: GoogleFonts.orbitron(
          fontWeight: FontWeight.w900,
          color: AppColors.ink,
        ),
        titleMedium: GoogleFonts.orbitron(
          fontWeight: FontWeight.w700,
          color: AppColors.ink,
        ),
        bodyMedium: GoogleFonts.exo2(
          fontSize: 14,
          color: AppColors.ink2,
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.p100, width: 1.2),
        ),
      ),
    );
  }
}
