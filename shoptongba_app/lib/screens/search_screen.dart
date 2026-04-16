import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/car.dart';
import '../utils/colors.dart';
import '../widgets/car_card.dart';
import '../widgets/fade_in_animation.dart';
import 'car_details_screen.dart';

class SearchScreen extends StatefulWidget {
  final String? initialQuery;

  const SearchScreen({super.key, this.initialQuery});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String _searchQuery = '';
  String _selectedCategory = 'Tous';
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, dynamic>> _categoryData = [
    {'name': 'Tous', 'icon': Icons.grid_view_rounded},
    {'name': 'SUV', 'icon': Icons.directions_car_filled_rounded},
    {'name': 'Berline', 'icon': Icons.directions_car_rounded},
    {'name': '4x4', 'icon': Icons.terrain_rounded},
    {'name': 'Luxe', 'icon': Icons.diamond_rounded},
    {'name': 'Sport', 'icon': Icons.speed_rounded},
  ];

  @override
  void initState() {
    super.initState();
    if (widget.initialQuery != null) {
      _searchQuery = widget.initialQuery!;
      _searchController.text = _searchQuery;
    }
  }

  @override
  void didUpdateWidget(SearchScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialQuery != oldWidget.initialQuery &&
        widget.initialQuery != null) {
      setState(() {
        _searchQuery = widget.initialQuery!;
        _searchController.text = _searchQuery;
      });
    }
  }

  List<Car> get _filteredCars {
    return dummyCars.where((car) {
      final matchesSearch =
          car.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              car.category.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesCategory =
          _selectedCategory == 'Tous' || car.category == _selectedCategory;
      return matchesSearch && matchesCategory;
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final filtered = _filteredCars;

    return Scaffold(
      backgroundColor:
          isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Header Section
            Container(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
              decoration: BoxDecoration(
                color: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isDark ? 0.0 : 0.02),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Explorer',
                            style: GoogleFonts.poppins(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: isDark
                                  ? AppColors.textLight
                                  : AppColors.textDark,
                            ),
                          ),
                          Text(
                            'Trouvez votre véhicule idéal',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: isDark
                                  ? AppColors.textGreyDark
                                  : AppColors.textGrey,
                            ),
                          ),
                        ],
                      ),
                      // Optional: Filter Button or Profile Icon
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.surfaceDark : Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isDark
                                ? Colors.white.withValues(alpha: 0.1)
                                : Colors.grey[200]!,
                          ),
                        ),
                        child: Icon(
                          Icons.tune_rounded,
                          color:
                              isDark ? AppColors.textLight : AppColors.textDark,
                          size: 24,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // Search Bar
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.surfaceDark : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black
                              .withValues(alpha: isDark ? 0.2 : 0.05),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ],
                      border: Border.all(
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.05)
                            : Colors.grey[100]!,
                      ),
                    ),
                    child: TextField(
                      controller: _searchController,
                      onChanged: (value) {
                        setState(() {
                          _searchQuery = value;
                        });
                      },
                      style: GoogleFonts.poppins(
                        color:
                            isDark ? AppColors.textLight : AppColors.textDark,
                        fontSize: 16,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Marque, modèle, catégorie...',
                        hintStyle: GoogleFonts.poppins(
                          color: isDark
                              ? AppColors.textGreyDark
                              : Colors.grey[400],
                          fontSize: 14,
                        ),
                        border: InputBorder.none,
                        icon: Icon(
                          Icons.search_rounded,
                          color: isDark
                              ? AppColors.textGreyDark
                              : AppColors.primary,
                        ),
                        suffixIcon: _searchQuery.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear_rounded),
                                color: isDark
                                    ? AppColors.textGreyDark
                                    : Colors.grey,
                                onPressed: () {
                                  _searchController.clear();
                                  setState(() {
                                    _searchQuery = '';
                                  });
                                },
                              )
                            : null,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Categories
            Container(
              height: 60,
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                scrollDirection: Axis.horizontal,
                itemCount: _categoryData.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final category = _categoryData[index];
                  final isSelected = _selectedCategory == category['name'];
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedCategory = category['name'];
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primary
                            : (isDark
                                ? AppColors.surfaceDark
                                : Colors.white),
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.primary
                              : (isDark
                                  ? Colors.white.withValues(alpha: 0.1)
                                  : Colors.grey[200]!),
                        ),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: AppColors.primary.withValues(alpha: 0.4),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                )
                              ]
                            : null,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            category['icon'],
                            size: 18,
                            color: isSelected
                                ? Colors.white
                                : (isDark
                                    ? AppColors.textGreyDark
                                    : AppColors.textGrey),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            category['name'],
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.w500,
                              color: isSelected
                                  ? Colors.white
                                  : (isDark
                                      ? AppColors.textLight
                                      : AppColors.textDark),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // Results Count & Grid
            Expanded(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${filtered.length} résultats',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: isDark ? AppColors.textLight : AppColors.textDark,
                          ),
                        ),
                        // Optional: Sort button text
                        if (filtered.isNotEmpty)
                          Text(
                            'Trier par',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: AppColors.primary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: filtered.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    color: isDark
                                        ? AppColors.surfaceDark
                                        : Colors.grey[100],
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.search_off_rounded,
                                    size: 48,
                                    color: isDark
                                        ? AppColors.textGreyDark
                                        : Colors.grey[400],
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Aucun véhicule trouvé',
                                  style: GoogleFonts.poppins(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: isDark
                                        ? AppColors.textLight
                                        : AppColors.textDark,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Essayez d\'autres mots-clés ou filtres',
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    color: isDark
                                        ? AppColors.textGreyDark
                                        : Colors.grey[500],
                                  ),
                                ),
                              ],
                            ),
                          )
                        : GridView.builder(
                            padding: const EdgeInsets.fromLTRB(
                                24, 8, 24, 100), // Bottom padding for nav bar
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.75,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                            ),
                            itemCount: filtered.length,
                            itemBuilder: (context, index) {
                              final car = filtered[index];
                              return FadeInAnimation(
                                delay: index * 50,
                                child: CarCard(
                                  car: car,
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            CarDetailsScreen(car: car),
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                          ),
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
