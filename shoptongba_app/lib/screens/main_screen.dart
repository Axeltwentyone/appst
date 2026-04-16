import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/colors.dart';
import '../widgets/glass_nav_bar.dart';
import 'home_screen.dart';
import 'search_screen.dart';
import 'bookings_screen.dart';
import 'profile_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  String? _pendingSearchQuery;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onSearch(String query) {
    setState(() {
      _pendingSearchQuery = query;
      _selectedIndex = 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _screens = [
      HomeScreen(
        onSearchTap: () => _onItemTapped(1),
        onBrandTap: _onSearch,
        onSeeAllTap: () => _onItemTapped(1),
      ),
      SearchScreen(initialQuery: _pendingSearchQuery),
      const BookingsScreen(),
      const ProfileScreen(),
    ];

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            // Shared Background Elements (can be moved to individual screens if needed)
            Positioned(
              top: -100,
              right: -100,
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary.withValues(alpha: 0.05),
                ),
              ),
            ),

            // Main Content
            IndexedStack(
              index: _selectedIndex,
              children: _screens,
            ),

            // Floating Navigation Bar
            GlassNavBar(
              currentIndex: _selectedIndex,
              onTap: _onItemTapped,
            ),
          ],
        ),
      ),
    );
  }
}
