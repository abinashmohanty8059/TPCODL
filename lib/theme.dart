import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ─── TPCODL Color Palette (from Stitch Design System: "Aether Utility") ───
class TPColors {
  // Primary
  static const Color primary = Color(0xFF003571);
  static const Color primaryContainer = Color(0xFF0F4C97);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color onPrimaryContainer = Color(0xFF9EBFFF);
  static const Color inversePrimary = Color(0xFFABC7FF);
  static const Color primaryFixed = Color(0xFFD7E3FF);
  static const Color primaryFixedDim = Color(0xFFABC7FF);

  // Secondary (Electric Blue)
  static const Color secondary = Color(0xFF006493);
  static const Color secondaryContainer = Color(0xFF25B2FE);
  static const Color onSecondary = Color(0xFFFFFFFF);
  static const Color onSecondaryContainer = Color(0xFF004162);
  static const Color secondaryFixed = Color(0xFFCAE6FF);
  static const Color secondaryFixedDim = Color(0xFF8DCDFF);

  // Tertiary (Gold)
  static const Color tertiary = Color(0xFF453400);
  static const Color tertiaryContainer = Color(0xFF614A00);
  static const Color onTertiary = Color(0xFFFFFFFF);
  static const Color onTertiaryContainer = Color(0xFFE5B939);
  static const Color tertiaryFixed = Color(0xFFFFDF92);
  static const Color tertiaryFixedDim = Color(0xFFEEC140);

  // Error
  static const Color error = Color(0xFFBA1A1A);
  static const Color errorContainer = Color(0xFFFFDAD6);
  static const Color onError = Color(0xFFFFFFFF);
  static const Color onErrorContainer = Color(0xFF93000A);

  // Surface / Background
  static const Color background = Color(0xFFF8F9FF);
  static const Color surface = Color(0xFFF8F9FF);
  static const Color surfaceBright = Color(0xFFF8F9FF);
  static const Color surfaceDim = Color(0xFFCCDBF4);
  static const Color surfaceContainer = Color(0xFFE5EEFF);
  static const Color surfaceContainerHigh = Color(0xFFDCE9FF);
  static const Color surfaceContainerHighest = Color(0xFFD4E4FC);
  static const Color surfaceContainerLow = Color(0xFFEFF4FF);
  static const Color surfaceContainerLowest = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFD4E4FC);
  static const Color surfaceTint = Color(0xFF2A5DA9);

  // On-Surface
  static const Color onBackground = Color(0xFF0D1C2E);
  static const Color onSurface = Color(0xFF0D1C2E);
  static const Color onSurfaceVariant = Color(0xFF424751);

  // Inverse
  static const Color inverseSurface = Color(0xFF223144);
  static const Color inverseOnSurface = Color(0xFFEAF1FF);

  // Outline
  static const Color outline = Color(0xFF737782);
  static const Color outlineVariant = Color(0xFFC3C6D3);

  // Splash screen
  static const Color splashBackground = Color(0xFF001B3F);

  // Background Gradient
  static const Gradient lightBlueGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFFE8F0FE),
      Color(0xFFF4F8FF),
    ],
  );
}

// ─── Theme Builder ───
class TPTheme {
  static ThemeData get lightTheme {
    final colorScheme = ColorScheme(
      brightness: Brightness.light,
      primary: TPColors.primary,
      onPrimary: TPColors.onPrimary,
      primaryContainer: TPColors.primaryContainer,
      onPrimaryContainer: TPColors.onPrimaryContainer,
      secondary: TPColors.secondary,
      onSecondary: TPColors.onSecondary,
      secondaryContainer: TPColors.secondaryContainer,
      onSecondaryContainer: TPColors.onSecondaryContainer,
      tertiary: TPColors.tertiary,
      onTertiary: TPColors.onTertiary,
      tertiaryContainer: TPColors.tertiaryContainer,
      onTertiaryContainer: TPColors.onTertiaryContainer,
      error: TPColors.error,
      onError: TPColors.onError,
      errorContainer: TPColors.errorContainer,
      onErrorContainer: TPColors.onErrorContainer,
      surface: TPColors.surface,
      onSurface: TPColors.onSurface,
      surfaceContainerHighest: TPColors.surfaceContainerHighest,
      outline: TPColors.outline,
      outlineVariant: TPColors.outlineVariant,
      inverseSurface: TPColors.inverseSurface,
      onInverseSurface: TPColors.inverseOnSurface,
      inversePrimary: TPColors.inversePrimary,
      surfaceTint: TPColors.surfaceTint,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: TPColors.background,
      textTheme: _textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: TPColors.surface.withValues(alpha: 0.8),
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.montserrat(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: TPColors.primary,
          letterSpacing: 3,
        ),
        iconTheme: const IconThemeData(color: TPColors.primary),
      ),
    );
  }

  static TextTheme get _textTheme {
    return TextTheme(
      // Display
      displayLarge: GoogleFonts.montserrat(
        fontSize: 48,
        fontWeight: FontWeight.w700,
        letterSpacing: -1,
        height: 56 / 48,
        color: TPColors.onSurface,
      ),
      // Headlines
      headlineLarge: GoogleFonts.montserrat(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.5,
        height: 40 / 32,
        color: TPColors.onSurface,
      ),
      headlineMedium: GoogleFonts.montserrat(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        height: 32 / 24,
        color: TPColors.onSurface,
      ),
      headlineSmall: GoogleFonts.montserrat(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        height: 28 / 20,
        color: TPColors.onSurface,
      ),
      // Body
      bodyLarge: GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.w400,
        height: 28 / 18,
        color: TPColors.onSurface,
      ),
      bodyMedium: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 24 / 16,
        color: TPColors.onSurface,
      ),
      bodySmall: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 20 / 14,
        color: TPColors.onSurfaceVariant,
      ),
      // Labels
      labelLarge: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        letterSpacing: 1,
        height: 16 / 14,
        color: TPColors.onSurface,
      ),
      labelMedium: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        letterSpacing: 1,
        height: 16 / 12,
        color: TPColors.onSurfaceVariant,
      ),
      labelSmall: GoogleFonts.inter(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        height: 16 / 13,
        color: TPColors.onSurfaceVariant,
      ),
    );
  }
}

// ─── Glassmorphism Decoration Helpers ───
class GlassDecoration {
  static BoxDecoration card({
    double borderRadius = 12,
    Color? borderColor,
  }) {
    return BoxDecoration(
      color: Colors.white.withValues(alpha: 0.7),
      borderRadius: BorderRadius.circular(borderRadius),
      border: Border.all(
        color: borderColor ?? Colors.white.withValues(alpha: 0.5),
        width: 1,
      ),
      boxShadow: [
        BoxShadow(
          color: TPColors.primaryContainer.withValues(alpha: 0.04),
          blurRadius: 20,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }

  static BoxDecoration navBar() {
    return BoxDecoration(
      color: Colors.black.withValues(alpha: 0.85),
      borderRadius: BorderRadius.circular(9999),
      border: Border.all(
        color: Colors.white.withValues(alpha: 0.7),
        width: 2.0,
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.3),
          blurRadius: 30,
          offset: const Offset(0, 15),
        ),
      ],
    );
  }

  static BoxDecoration glassTag({Color? color}) {
    final c = color ?? TPColors.secondaryContainer;
    return BoxDecoration(
      color: c.withValues(alpha: 0.1),
      borderRadius: BorderRadius.circular(9999),
      border: Border.all(
        color: c.withValues(alpha: 0.2),
        width: 1,
      ),
    );
  }
}
