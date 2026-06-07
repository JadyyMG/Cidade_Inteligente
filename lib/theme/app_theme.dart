// lib/theme/app_theme.dart
// Define o tema principal do aplicativo usando Material Design 3

import 'package:flutter/material.dart';

class AppTheme {
  // ── Paleta de cores ──────────────────────────────────────────────────────
  static const Color primary = Color(0xFF1565C0);      // Azul prefeitura
  static const Color primaryLight = Color(0xFF1E88E5);
  static const Color primaryDark = Color(0xFF0D47A1);
  static const Color secondary = Color(0xFF00897B);    // Verde ação
  static const Color error = Color(0xFFD32F2F);        // Vermelho alerta
  static const Color warning = Color(0xFFF57C00);      // Laranja atenção
  static const Color success = Color(0xFF388E3C);      // Verde resolvido
  static const Color surface = Color(0xFFF5F7FA);
  static const Color cardBg = Color(0xFFFFFFFF);

  // ── Status das denúncias ────────────────────────────────────────────────
  static const Map<String, Color> statusColors = {
    'aberta': Color(0xFFF57C00),
    'em_andamento': Color(0xFF1565C0),
    'resolvida': Color(0xFF388E3C),
    'cancelada': Color(0xFF757575),
  };

  static Color statusColor(String status) =>
      statusColors[status] ?? const Color(0xFF757575);

  // ── Tema claro ──────────────────────────────────────────────────────────
  static ThemeData get lightTheme {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: primary,
      brightness: Brightness.light,
      primary: primary,
      secondary: secondary,
      error: error,
      surface: surface,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: surface,

      // AppBar
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 1,
        backgroundColor: cardBg,
        foregroundColor: primary,
        titleTextStyle: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: primary,
        ),
      ),

      // Cards
      cardTheme: CardThemeData(
        elevation: 0,
        color: cardBg,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: Color(0xFFE8EDF2), width: 1),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      ),

      // Botões primários
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 0,
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // Botões outline
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primary,
          minimumSize: const Size.fromHeight(48),
          side: const BorderSide(color: primary),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // Campos de texto
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: cardBg,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFDDE2E9)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFDDE2E9)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: error),
        ),
        labelStyle: const TextStyle(color: Color(0xFF6B7280)),
        hintStyle: const TextStyle(color: Color(0xFF9CA3AF)),
      ),

      // Chips
      chipTheme: ChipThemeData(
        backgroundColor: const Color(0xFFEFF3F8),
        selectedColor: primary.withOpacity(0.15),
        labelStyle: const TextStyle(fontSize: 13),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        side: BorderSide.none,
      ),

      // BottomNav
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: cardBg,
        elevation: 8,
        shadowColor: Colors.black12,
        indicatorColor: primary.withOpacity(0.12),
        labelTextStyle: WidgetStateProperty.all(
          const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
        ),
      ),

      // Divisores
      dividerTheme: const DividerThemeData(
        color: Color(0xFFEAEDF0),
        thickness: 1,
        space: 1,
      ),

      // Tipografia
      textTheme: const TextTheme(
        displaySmall: TextStyle(
            fontSize: 28, fontWeight: FontWeight.w700, color: Color(0xFF111827)),
        headlineMedium: TextStyle(
            fontSize: 22, fontWeight: FontWeight.w700, color: Color(0xFF111827)),
        headlineSmall: TextStyle(
            fontSize: 18, fontWeight: FontWeight.w600, color: Color(0xFF111827)),
        titleLarge: TextStyle(
            fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF111827)),
        titleMedium: TextStyle(
            fontSize: 15, fontWeight: FontWeight.w500, color: Color(0xFF374151)),
        bodyLarge: TextStyle(fontSize: 15, color: Color(0xFF374151)),
        bodyMedium: TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
        bodySmall: TextStyle(fontSize: 12, color: Color(0xFF9CA3AF)),
        labelLarge: TextStyle(
            fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF374151)),
      ),
    );
  }
}

// ── Constantes de espaçamento ──────────────────────────────────────────────
class AppSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
}

// ── Constantes de bordas ───────────────────────────────────────────────────
class AppRadius {
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double full = 999;
}
