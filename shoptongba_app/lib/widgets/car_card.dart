import 'package:flutter/material.dart';
import '../models/car.dart';
import '../utils/colors.dart';
import 'package:google_fonts/google_fonts.dart';

class CarCard extends StatelessWidget {
  final Car car;
  final VoidCallback onTap;

  const CarCard({super.key, required this.car, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceDark : Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              child: Hero(
                tag: 'car-${car.id}',
                child: Image.network(
                  car.imageUrl,
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 180,
                    color: isDark ? Colors.grey[800] : Colors.grey[200],
                    child: Center(child: Icon(Icons.car_rental, size: 50, color: isDark ? Colors.grey[600] : Colors.grey)),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        car.name,
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isDark ? AppColors.textLight : AppColors.textDark,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.secondary.withValues(alpha: isDark ? 0.3 : 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          car.category,
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: isDark ? AppColors.textLight : AppColors.secondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.people_outline, size: 16, color: isDark ? AppColors.textGreyDark : AppColors.textLight),
                      const SizedBox(width: 4),
                      Text('${car.seats} places', style: TextStyle(color: isDark ? AppColors.textGreyDark : AppColors.textLight)),
                      const SizedBox(width: 16),
                      Icon(Icons.settings, size: 16, color: isDark ? AppColors.textGreyDark : AppColors.textLight),
                      const SizedBox(width: 4),
                      Text(car.isAutomatic ? 'Auto' : 'Manuel', style: TextStyle(color: isDark ? AppColors.textGreyDark : AppColors.textLight)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${car.pricePerDay.toStringAsFixed(0)} FCFA / jour',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward,
                        color: AppColors.primary,
                        size: 20,
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
}
