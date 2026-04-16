import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/car.dart';
import '../utils/colors.dart';

class FeaturedCarCard extends StatelessWidget {
  final Car car;
  final VoidCallback onTap;

  const FeaturedCarCard({
    super.key,
    required this.car,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 280,
        margin: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: isDark ? AppColors.surfaceDark : Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.08),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image container
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Hero(
                      tag: 'featured-${car.id}',
                      child: Image.network(
                        car.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: isDark ? Colors.grey[800] : Colors.grey[200],
                          child: Icon(Icons.car_rental, size: 50, color: isDark ? Colors.grey[600] : Colors.grey),
                        ),
                      ),
                    ),
                    // Gradient overlay
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withValues(alpha: 0.6),
                            ],
                            stops: const [0.6, 1.0],
                          ),
                        ),
                      ),
                    ),
                    // Price tag
                    Positioned(
                      top: 12,
                      right: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: (isDark ? Colors.grey[900] : Colors.white)!.withValues(alpha: 0.9),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '${car.pricePerDay.toInt()} FCFA/j',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Info
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    car.category.toUpperCase(),
                    style: GoogleFonts.poppins(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: isDark ? AppColors.textGreyDark : AppColors.textLight,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    car.name,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isDark ? AppColors.textLight : AppColors.textDark,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _buildFeatureIcon(Icons.event_seat_outlined, '${car.seats} places', isDark),
                      const SizedBox(width: 16),
                      _buildFeatureIcon(
                        Icons.settings_outlined,
                        car.isAutomatic ? 'Auto' : 'Manuel',
                        isDark,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureIcon(IconData icon, String label, bool isDark) {
    return Row(
      children: [
        Icon(icon, size: 16, color: isDark ? AppColors.textGreyDark : AppColors.textLight),
        const SizedBox(width: 4),
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 12,
            color: isDark ? AppColors.textGreyDark : AppColors.textLight,
          ),
        ),
      ],
    );
  }
}
