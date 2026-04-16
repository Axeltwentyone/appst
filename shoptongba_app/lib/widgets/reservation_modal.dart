import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../utils/colors.dart';
import '../models/car.dart';

class ReservationModal extends StatefulWidget {
  final Car car;

  const ReservationModal({super.key, required this.car});

  @override
  State<ReservationModal> createState() => _ReservationModalState();
}

class _ReservationModalState extends State<ReservationModal> {
  DateTime? _startDate;
  DateTime? _endDate;
  TimeOfDay _pickupTime = const TimeOfDay(hour: 10, minute: 0);
  TimeOfDay _returnTime = const TimeOfDay(hour: 10, minute: 0);

  Future<void> _selectDateRange() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      initialDateRange: (_startDate != null && _endDate != null)
          ? DateTimeRange(start: _startDate!, end: _endDate!)
          : null,
      builder: (context, child) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: isDark
                ? const ColorScheme.dark(
                    primary: AppColors.primary,
                    onPrimary: Colors.white,
                    surface: AppColors.surfaceDark,
                    onSurface: AppColors.textLight,
                  )
                : const ColorScheme.light(
                    primary: AppColors.primary,
                    onPrimary: Colors.white,
                    surface: Colors.white,
                    onSurface: AppColors.textDark,
                  ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
      });
    }
  }

  Future<void> _selectTime(bool isPickup) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isPickup ? _pickupTime : _returnTime,
      builder: (context, child) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return Theme(
          data: Theme.of(context).copyWith(
            timePickerTheme: TimePickerThemeData(
              backgroundColor:
                  isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
              hourMinuteTextColor:
                  isDark ? AppColors.textLight : AppColors.textDark,
              dayPeriodTextColor:
                  isDark ? AppColors.textLight : AppColors.textDark,
              dialHandColor: AppColors.primary,
              dialBackgroundColor:
                  isDark ? AppColors.backgroundDark : Colors.grey[200],
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primary,
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        if (isPickup) {
          _pickupTime = picked;
        } else {
          _returnTime = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final int days = (_startDate != null && _endDate != null)
        ? _endDate!.difference(_startDate!).inDays + 1
        : 0;
    final double totalPrice = days * widget.car.pricePerDay;

    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag Handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.2)
                    : Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Title
          Text(
            'Planifier votre location',
            style: GoogleFonts.poppins(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: isDark ? AppColors.textLight : AppColors.textDark,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Sélectionnez vos dates et heures',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: isDark ? AppColors.textGreyDark : AppColors.textGrey,
            ),
          ),
          const SizedBox(height: 32),

          // Date & Time Selection Row
          Row(
            children: [
              // Pickup Section
              Expanded(
                child: _buildDateTimeCard(
                  context,
                  title: 'Départ',
                  date: _startDate,
                  time: _pickupTime,
                  isDark: isDark,
                  onDateTap: _selectDateRange,
                  onTimeTap: () => _selectTime(true),
                  icon: Icons.flight_takeoff_rounded,
                ),
              ),
              const SizedBox(width: 16),
              // Return Section
              Expanded(
                child: _buildDateTimeCard(
                  context,
                  title: 'Retour',
                  date: _endDate,
                  time: _returnTime,
                  isDark: isDark,
                  onDateTap: _selectDateRange,
                  onTimeTap: () => _selectTime(false),
                  icon: Icons.flight_land_rounded,
                ),
              ),
            ],
          ),

          const SizedBox(height: 32),

          // Receipt / Summary
          if (days > 0)
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.backgroundDark
                    : const Color(0xFFF8F9FD),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.05)
                      : Colors.grey[200]!,
                ),
              ),
              child: Column(
                children: [
                  _buildReceiptRow(
                    'Durée',
                    '$days jours',
                    isDark,
                  ),
                  const SizedBox(height: 12),
                  _buildReceiptRow(
                    'Prix par jour',
                    '${NumberFormat('#,###').format(widget.car.pricePerDay)} F',
                    isDark,
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Divider(height: 1),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color:
                              isDark ? AppColors.textLight : AppColors.textDark,
                        ),
                      ),
                      Text(
                        '${NumberFormat('#,###').format(totalPrice)} F',
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

          const SizedBox(height: 32),

          // Confirm Button
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: (days > 0)
                  ? () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Réservation confirmée pour ${NumberFormat('#,###').format(totalPrice)} F',
                            style: GoogleFonts.poppins(),
                          ),
                          backgroundColor: Colors.green,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      );
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                elevation: 8,
                shadowColor: AppColors.primary.withValues(alpha: 0.4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                disabledBackgroundColor:
                    isDark ? Colors.white.withValues(alpha: 0.1) : Colors.grey[300],
              ),
              child: Text(
                'Confirmer la réservation',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
        ],
      ),
    );
  }

  Widget _buildDateTimeCard(
    BuildContext context, {
    required String title,
    required DateTime? date,
    required TimeOfDay time,
    required bool isDark,
    required VoidCallback onDateTap,
    required VoidCallback onTimeTap,
    required IconData icon,
  }) {
    final dateFormat = DateFormat('dd MMM yyyy', 'fr_FR');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title.toUpperCase(),
          style: GoogleFonts.poppins(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.2,
            color: isDark ? AppColors.textGreyDark : AppColors.textGrey,
          ),
        ),
        const SizedBox(height: 12),
        // Date Box
        GestureDetector(
          onTap: onDateTap,
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.1)
                    : Colors.grey[200]!,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(icon, color: AppColors.primary, size: 20),
                const SizedBox(height: 8),
                Text(
                  date != null ? dateFormat.format(date) : 'Date',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color:
                        isDark ? AppColors.textLight : AppColors.textDark,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        // Time Box
        GestureDetector(
          onTap: onTimeTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.1)
                    : Colors.grey[200]!,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.access_time_rounded,
                  size: 16,
                  color: isDark ? AppColors.textGreyDark : AppColors.textGrey,
                ),
                const SizedBox(width: 8),
                Text(
                  time.format(context),
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color:
                        isDark ? AppColors.textLight : AppColors.textDark,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildReceiptRow(String label, String value, bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: isDark ? AppColors.textGreyDark : AppColors.textGrey,
          ),
        ),
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
