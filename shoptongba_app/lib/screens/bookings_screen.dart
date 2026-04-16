import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/car.dart';
import '../utils/colors.dart';
import 'car_details_screen.dart';

enum BookingStatus { upcoming, completed, cancelled }

class Booking {
  final Car car;
  final DateTime startDate;
  final DateTime endDate;
  final BookingStatus status;
  final double totalPrice;

  Booking({
    required this.car,
    required this.startDate,
    required this.endDate,
    required this.status,
    required this.totalPrice,
  });
}

class BookingsScreen extends StatefulWidget {
  const BookingsScreen({super.key});

  @override
  State<BookingsScreen> createState() => _BookingsScreenState();
}

class _BookingsScreenState extends State<BookingsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Mock Data
  final List<Booking> _bookings = [
    Booking(
      car: dummyCars[0], // Range Rover
      startDate: DateTime.now().add(const Duration(days: 2)),
      endDate: DateTime.now().add(const Duration(days: 5)),
      status: BookingStatus.upcoming,
      totalPrice: 450000,
    ),
    Booking(
      car: dummyCars[1], // Mercedes
      startDate: DateTime.now().subtract(const Duration(days: 10)),
      endDate: DateTime.now().subtract(const Duration(days: 7)),
      status: BookingStatus.completed,
      totalPrice: 300000,
    ),
    Booking(
      car: dummyCars[3], // Hyundai
      startDate: DateTime.now().subtract(const Duration(days: 20)),
      endDate: DateTime.now().subtract(const Duration(days: 18)),
      status: BookingStatus.cancelled,
      totalPrice: 120000,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    final upcomingBookings = _bookings.where((b) => b.status == BookingStatus.upcoming).toList();
    final pastBookings = _bookings.where((b) => b.status != BookingStatus.upcoming).toList();

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Mes Réservations',
                    style: GoogleFonts.poppins(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: isDark ? AppColors.textLight : AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    height: 50,
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.surfaceDark : Colors.grey[200],
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: TabBar(
                      controller: _tabController,
                      indicator: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(21),
                      ),
                      labelColor: Colors.white,
                      unselectedLabelColor: isDark ? AppColors.textGreyDark : AppColors.textGrey,
                      labelStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                      tabs: const [
                        Tab(text: 'En cours'),
                        Tab(text: 'Historique'),
                      ],
                      dividerColor: Colors.transparent,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildBookingsList(upcomingBookings, isDark),
                  _buildBookingsList(pastBookings, isDark),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookingsList(List<Booking> bookings, bool isDark) {
    if (bookings.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.calendar_today_outlined,
              size: 64,
              color: isDark ? AppColors.textGreyDark : Colors.grey[300],
            ),
            const SizedBox(height: 16),
            Text(
              'Aucune réservation',
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: isDark ? AppColors.textGreyDark : Colors.grey[500],
              ),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 100),
      itemCount: bookings.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        return _buildBookingCard(bookings[index], isDark);
      },
    );
  }

  Widget _buildBookingCard(Booking booking, bool isDark) {
    Color statusColor;
    String statusText;

    switch (booking.status) {
      case BookingStatus.upcoming:
        statusColor = Colors.blue;
        statusText = 'Confirmé';
        break;
      case BookingStatus.completed:
        statusColor = Colors.green;
        statusText = 'Terminé';
        break;
      case BookingStatus.cancelled:
        statusColor = Colors.red;
        statusText = 'Annulé';
        break;
    }

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CarDetailsScreen(car: booking.car),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceDark : Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    booking.car.imageUrl,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: statusColor.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              statusText,
                              style: GoogleFonts.poppins(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: statusColor,
                              ),
                            ),
                          ),
                          Text(
                            '${booking.totalPrice.toInt()} F',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        booking.car.name,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isDark ? AppColors.textLight : AppColors.textDark,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today,
                            size: 12,
                            color: isDark ? AppColors.textGreyDark : AppColors.textGrey,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${booking.startDate.day}/${booking.startDate.month} - ${booking.endDate.day}/${booking.endDate.month}',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: isDark ? AppColors.textGreyDark : AppColors.textGrey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (booking.status == BookingStatus.upcoming) ...[
              const SizedBox(height: 16),
              Divider(color: isDark ? Colors.white.withValues(alpha: 0.1) : Colors.grey[200]),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildActionButton(Icons.map, 'Itinéraire', isDark),
                  _buildActionButton(Icons.chat_bubble_outline, 'Message', isDark),
                  _buildActionButton(Icons.phone, 'Appeler', isDark),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String label, bool isDark) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.grey[100],
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            size: 20,
            color: isDark ? AppColors.textLight : AppColors.textDark,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 10,
            color: isDark ? AppColors.textGreyDark : AppColors.textGrey,
          ),
        ),
      ],
    );
  }
}
