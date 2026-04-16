import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/colors.dart';

class GlassNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const GlassNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(40),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20.0, sigmaY: 20.0),
          child: Container(
            height: 80,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            decoration: BoxDecoration(
              color: isDark 
                  ? const Color(0xFF1C1C1E).withValues(alpha: 0.85) 
                  : Colors.white.withValues(alpha: 0.85),
              borderRadius: BorderRadius.circular(40),
              border: Border.all(
                color: isDark 
                    ? Colors.white.withValues(alpha: 0.1)
                    : Colors.white.withValues(alpha: 0.5),
                width: 0.5,
              ),
              boxShadow: [
                 if (!isDark)
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildNavItem(context, 0, Icons.home_rounded, 'Accueil', isDark),
                _buildNavItem(context, 1, Icons.search_rounded, 'Recherche', isDark),
                _buildNavItem(context, 2, Icons.calendar_today_rounded, 'Réservations', isDark),
                _buildNavItem(context, 3, Icons.person_rounded, 'Profil', isDark),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, int index, IconData icon, String label, bool isDark) {
    final bool isSelected = currentIndex == index;
    
    return GestureDetector(
      onTap: () => onTap(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        padding: EdgeInsets.symmetric(
          horizontal: isSelected ? 20 : 12,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected 
                  ? Colors.white 
                  : (isDark ? Colors.grey[400] : Colors.grey[600]),
              size: 24,
            ),
            if (isSelected) ...[
              const SizedBox(height: 4),
              Text(
                label,
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ] else ...[
               const SizedBox(height: 4),
               Text(
                label,
                style: GoogleFonts.poppins(
                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
