import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/main_screen.dart';
import 'utils/colors.dart';

// Global theme notifier to allow toggling from anywhere
final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.system);

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, currentMode, _) {
        return MaterialApp(
          title: 'Shoptongba',
          debugShowCheckedModeBanner: false,
          themeMode: currentMode,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: AppColors.primary,
              primary: AppColors.primary,
              secondary: AppColors.secondary,
              surface: AppColors.surfaceLight,
              onSurface: AppColors.textDark,
            ),
            useMaterial3: true,
            textTheme: GoogleFonts.poppinsTextTheme(),
            scaffoldBackgroundColor: AppColors.backgroundLight,
          ),
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            colorScheme: ColorScheme.fromSeed(
              brightness: Brightness.dark,
              seedColor: AppColors.primary,
              primary: AppColors.primary,
              secondary: AppColors.white,
              surface: AppColors.surfaceDark,
              onSurface: AppColors.textLight,
            ),
            useMaterial3: true,
            textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme),
            scaffoldBackgroundColor: AppColors.backgroundDark,
          ),
          home: const MainScreen(),
        );
      },
    );
  }
}
