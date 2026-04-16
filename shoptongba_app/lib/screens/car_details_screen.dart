import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/car.dart';
import '../utils/colors.dart';
import '../widgets/reservation_modal.dart';

class CarDetailsScreen extends StatelessWidget {
  final Car car;
  final bool isFeatured;

  const CarDetailsScreen({
    super.key,
    required this.car,
    this.isFeatured = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light, // White icons for dark image bg
        statusBarBrightness: Brightness.dark, // For iOS
      ),
      child: Scaffold(
        backgroundColor: isDark ? AppColors.backgroundDark : const Color(0xFFF8F9FD),
        body: Stack(
          children: [
            CustomScrollView(
              slivers: [
                SliverAppBar(
                  expandedHeight: 400,
                  pinned: true,
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  leading: Container(), // Custom leading in Stack
                  flexibleSpace: FlexibleSpaceBar(
                    background: Stack(
                      fit: StackFit.expand,
                      children: [
                        Hero(
                          tag: isFeatured ? 'featured-${car.id}' : 'car-${car.id}',
                          child: Image.network(
                            car.imageUrl,
                            fit: BoxFit.cover,
                          ),
                        ),
                        // Gradient Overlay for text readability
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.black.withValues(alpha: 0.3),
                                Colors.transparent,
                                Colors.black.withValues(alpha: 0.6),
                              ],
                              stops: const [0.0, 0.5, 1.0],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Transform.translate(
                    offset: const Offset(0, -30),
                    child: Container(
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.backgroundDark : const Color(0xFFF8F9FD),
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(24, 40, 24, 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Title and Rating
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 5,
                                        ),
                                        decoration: BoxDecoration(
                                          color: AppColors.primary.withValues(alpha: 0.1),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          car.category.toUpperCase(),
                                          style: GoogleFonts.poppins(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.primary,
                                            letterSpacing: 1.2,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        car.name,
                                        style: GoogleFonts.poppins(
                                          fontSize: 26,
                                          fontWeight: FontWeight.bold,
                                          color: isDark ? AppColors.textLight : AppColors.textDark,
                                          height: 1.2,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isDark ? AppColors.surfaceDark : Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(alpha: 0.05),
                                        blurRadius: 10,
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.star, color: Colors.amber, size: 18),
                                      const SizedBox(width: 4),
                                      Text(
                                        '4.8',
                                        style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                          color: isDark ? AppColors.textLight : AppColors.textDark,
                                        ),
                                      ),
                                      Text(
                                        ' (52)',
                                        style: GoogleFonts.poppins(
                                          color: isDark ? AppColors.textGreyDark : AppColors.textLight,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 30),

                            // Specs Grid
                            Text(
                              'Caractéristiques',
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: isDark ? AppColors.textLight : AppColors.textDark,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _buildSpecItem(Icons.speed, 'Vitesse', '220 km/h', isDark),
                                _buildSpecItem(Icons.settings_outlined, 'Boîte', car.isAutomatic ? 'Auto' : 'Manuel', isDark),
                                _buildSpecItem(Icons.airline_seat_recline_extra_outlined, 'Sièges', '${car.seats} places', isDark),
                                _buildSpecItem(Icons.local_gas_station_outlined, 'Carburant', 'Essence', isDark),
                              ],
                            ),
                            const SizedBox(height: 30),

                            // Description
                            Text(
                              'Description',
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: isDark ? AppColors.textLight : AppColors.textDark,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Vivez une expérience de conduite inégalée avec ce modèle d\'exception. Alliant confort premium, technologie de pointe et performances remarquables, c\'est le choix idéal pour vos déplacements d\'affaires ou vos escapades.',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: isDark ? AppColors.textLight : AppColors.textDark,
                                height: 1.6,
                              ),
                            ),
                            const SizedBox(height: 30),

                            // Owner Profile
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: isDark ? AppColors.surfaceDark : Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: (isDark ? Colors.white : Colors.grey).withValues(alpha: 0.1)),
                              ),
                              child: Row(
                                children: [
                                  const CircleAvatar(
                                    radius: 24,
                                    backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=60'),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              'CB LOCATION',
                                              style: GoogleFonts.poppins(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                                color: isDark ? AppColors.textLight : AppColors.textDark,
                                              ),
                                            ),
                                            const SizedBox(width: 4),
                                            const Icon(Icons.verified, color: Colors.blue, size: 16),
                                          ],
                                        ),
                                        Text(
                                          'Loueur certifié',
                                          style: GoogleFonts.poppins(
                                            color: isDark ? AppColors.textGreyDark : AppColors.textLight,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: AppColors.primary.withValues(alpha: 0.1),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(Icons.chat_bubble_outline, color: AppColors.primary, size: 20),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 100), // Bottom padding for sticky bar
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Custom Back Button
            Positioned(
              top: MediaQuery.of(context).padding.top + 10,
              left: 20,
              child: _buildGlassButton(
                icon: Icons.arrow_back,
                onTap: () => Navigator.pop(context),
              ),
            ),
            
            // Favorite Button
            Positioned(
              top: MediaQuery.of(context).padding.top + 10,
              right: 20,
              child: _buildGlassButton(
                icon: Icons.favorite_border,
                onTap: () {},
              ),
            ),

            // Bottom Sticky Bar
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.only(
                  left: 24,
                  right: 24,
                  bottom: MediaQuery.of(context).padding.bottom + 20,
                  top: 20,
                ),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.surfaceDark : Colors.white,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 20,
                      offset: const Offset(0, -5),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Prix',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: isDark ? AppColors.textGreyDark : AppColors.textLight,
                          ),
                        ),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: '${car.pricePerDay.toInt()}',
                                style: GoogleFonts.poppins(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: isDark ? AppColors.textLight : AppColors.textDark,
                                ),
                              ),
                              TextSpan(
                                text: ' F/jr',
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: isDark ? AppColors.textGreyDark : AppColors.textLight,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 24),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (context) => ReservationModal(car: car),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          'Réserver',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGlassButton({required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
            ),
            child: Icon(icon, color: Colors.white, size: 24),
          ),
        ),
      ),
    );
  }

  Widget _buildSpecItem(IconData icon, String label, String value, bool isDark) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isDark ? AppColors.backgroundDark : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: (isDark ? Colors.white : Colors.grey).withValues(alpha: 0.1)),
          ),
          child: Icon(icon, color: AppColors.primary, size: 24),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 12,
            color: isDark ? AppColors.textGreyDark : AppColors.textLight,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isDark ? AppColors.textLight : AppColors.textDark,
          ),
        ),
      ],
    );
  }
}
