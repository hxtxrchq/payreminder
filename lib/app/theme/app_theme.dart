import 'package:flutter/material.dart';

class AppColors {
  static const pending = Color(0xFF111111);    // Negro
  static const near = Color(0xFFF4D03F);       // Amarillo
  static const due = Color(0xFFE74C3C);        // Rojo
  static const paid = Color(0xFF27AE60);       // Verde
}

class AppTheme {
  static ThemeData light() {
    final base = ThemeData(useMaterial3: true, colorSchemeSeed: AppColors.paid);
    return base.copyWith(
      appBarTheme: const AppBarTheme(centerTitle: false),
      visualDensity: VisualDensity.standard,
    );
  }

  static ThemeData dark() {
    final base = ThemeData.dark(useMaterial3: true);
    return base.copyWith(
      colorScheme: base.colorScheme.copyWith(secondary: AppColors.near),
      visualDensity: VisualDensity.standard,
    );
  }
}