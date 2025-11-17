import 'package:flutter/material.dart';

class AppColors {
  static const maroon = Color(0xFF800000); // primária
  static const lightBlue = Color(0xFFADD8E6); // outline/detalhes
  static const wheat = Color(0xFFB0C4DE); // fundo/surface (RESTO DO APP)
  static const chocolate = Color(0xFFD2691E); // botões secundários (Elevated)
  static const saddle = Color(0xFF8B4513); // hover/focus/bordas fortes
}

class AppTheme {
  static ThemeData light() {
    const primary = AppColors.maroon;
    const secondary = AppColors.chocolate;

    final scheme = ColorScheme(
      brightness: Brightness.light,
      primary: primary,
      onPrimary: Colors.white,
      secondary: secondary,
      onSecondary: Colors.white,
      tertiary: AppColors.lightBlue,
      onTertiary: Colors.black,
      surface: AppColors.wheat, 
      onSurface: const Color(0xFF2A2A2A),
      background: AppColors.wheat, 
      onBackground: const Color(0xFF2A2A2A),
      error: Colors.red,
      onError: Colors.white,
      outline: AppColors.lightBlue,
      outlineVariant: AppColors.saddle,
      shadow: Colors.black26,
      scrim: Colors.black54,
      surfaceTint: primary,
      inverseSurface: primary,
      onInverseSurface: Colors.white,
      inversePrimary: secondary,
    );

    final base = ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: scheme.background,
    );

    return base.copyWith(
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.maroon,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      drawerTheme: DrawerThemeData(
        backgroundColor: scheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 1,
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.chocolate,
        foregroundColor: Colors.white,
        elevation: 1,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style:
            FilledButton.styleFrom(
              backgroundColor: AppColors.maroon,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ).copyWith(
              overlayColor: MaterialStatePropertyAll(
                AppColors.saddle.withOpacity(.14),
              ),
            ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style:
            ElevatedButton.styleFrom(
              backgroundColor: AppColors.chocolate,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ).copyWith(
              overlayColor: MaterialStatePropertyAll(
                AppColors.saddle.withOpacity(.16),
              ),
            ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.maroon,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.lightBlue),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.lightBlue),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(14)),
          borderSide: BorderSide(color: AppColors.maroon, width: 2),
        ),
        labelStyle: TextStyle(color: const Color(0xFF2A2A2A).withOpacity(.75)),
        hintStyle: TextStyle(color: const Color(0xFF2A2A2A).withOpacity(.45)),
      ),
      dividerTheme: DividerThemeData(
        color: AppColors.lightBlue.withOpacity(.9),
        thickness: 1,
      ),
      listTileTheme: ListTileThemeData(
        iconColor: AppColors.maroon,
        textColor: scheme.onSurface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.saddle,
        contentTextStyle: const TextStyle(color: Colors.white),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
