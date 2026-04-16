import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../main.dart';
import '../models/car.dart';
import '../utils/colors.dart';
import '../widgets/car_card.dart';
import '../widgets/featured_car_card.dart';
import '../widgets/fade_in_animation.dart';
import 'car_details_screen.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback? onSearchTap;
  final Function(String)? onBrandTap;
  final VoidCallback? onSeeAllTap;

  const HomeScreen({super.key, this.onSearchTap, this.onBrandTap, this.onSeeAllTap});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _selectedCategory = 'Tous';
  
  final List<Map<String, dynamic>> _categoryData = [
    {'name': 'Tous', 'icon': Icons.grid_view_rounded},
    {'name': 'SUV', 'icon': Icons.directions_car_filled_rounded},
    {'name': 'Berline', 'icon': Icons.directions_car_rounded},
    {'name': '4x4', 'icon': Icons.terrain_rounded},
    {'name': 'Luxe', 'icon': Icons.diamond_rounded},
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top + 20,
            left: 24,
            right: 24,
            bottom: 24,
          ),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Bonjour,',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: isDark ? AppColors.textGreyDark : AppColors.textDark,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        'Trouvez votre\nvéhicule idéal',
                        style: GoogleFonts.poppins(
                          fontSize: 26,
                          color: isDark ? AppColors.textLight : AppColors.textDark,
                          fontWeight: FontWeight.bold,
                          height: 1.2,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          themeNotifier.value = isDark ? ThemeMode.light : ThemeMode.dark;
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: isDark ? AppColors.surfaceDark : Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Icon(
                            isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                            color: isDark ? Colors.amber : AppColors.textDark,
                            size: 24,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.primary, width: 2),
                        ),
                        child: const CircleAvatar(
                          radius: 24,
                          backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=12'),
                          backgroundColor: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 30),

              // Search Bar
              GestureDetector(
                onTap: widget.onSearchTap,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.surfaceDark : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: TextField(
                    enabled: false,
                    style: GoogleFonts.poppins(color: isDark ? AppColors.textLight : AppColors.textDark),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Rechercher une marque, un modèle...',
                      hintStyle: GoogleFonts.poppins(
                        color: isDark ? AppColors.textGreyDark : Colors.grey[400],
                        fontSize: 14
                      ),
                      icon: Icon(Icons.search, color: isDark ? AppColors.textLight : AppColors.textDark),
                      suffixIcon: Container(
                        margin: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.tune, color: Colors.white, size: 20),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // Categories
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                clipBehavior: Clip.none,
                child: Row(
                  children: _categoryData.map((category) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: _buildCategoryItem(
                        category['name'],
                        category['icon'],
                        _selectedCategory == category['name'],
                        isDark,
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 30),

              // Featured Title
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Populaires',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: isDark ? AppColors.textLight : AppColors.textDark,
                    ),
                  ),
                  Text(
                    'Voir tout',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isDark ? AppColors.textLight : AppColors.textDark,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Featured Carousel
              SizedBox(
                height: 320,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  clipBehavior: Clip.none,
                  itemCount: dummyCars.length,
                  itemBuilder: (context, index) {
                    return FadeInAnimation(
                      delay: index * 100,
                      child: FeaturedCarCard(
                        car: dummyCars[index],
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CarDetailsScreen(
                              car: dummyCars[index],
                              isFeatured: true,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 30),

              // Recent Title
              Text(
                'Récemment ajoutés',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: isDark ? AppColors.textLight : AppColors.textDark,
                ),
              ),
              const SizedBox(height: 20),
            ]),
          ),
        ),

        // Vertical List
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return FadeInAnimation(
                  delay: (index + 2) * 100, // Offset to start after horizontal list
                  child: CarCard(
                    car: dummyCars[index],
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CarDetailsScreen(car: dummyCars[index]),
                      ),
                    ),
                  ),
                );
              },
              childCount: dummyCars.length,
            ),
          ),
        ),

        // Bottom padding for GlassNavBar
        const SliverPadding(padding: EdgeInsets.only(bottom: 120)),
      ],
    );
  }

  Widget _buildBrandItem(String name, bool isDark) {
    return GestureDetector(
      onTap: () {
        if (widget.onBrandTap != null) {
          widget.onBrandTap!(name);
        }
      },
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: isDark ? AppColors.surfaceDark : Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
              border: Border.all(
                color: isDark ? Colors.white.withValues(alpha: 0.1) : Colors.grey[200]!,
              ),
            ),
            child: Center(
              child: Text(
                name[0],
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: isDark ? AppColors.textLight : AppColors.textDark,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            name,
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: isDark ? AppColors.textGreyDark : AppColors.textDark,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryItem(String label, IconData icon, bool isSelected, bool isDark) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCategory = label;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : (isDark ? AppColors.surfaceDark : Colors.white),
          borderRadius: BorderRadius.circular(16),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  )
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  )
                ],
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : (isDark ? AppColors.textLight : AppColors.textDark),
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : (isDark ? AppColors.textLight : AppColors.textDark),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
