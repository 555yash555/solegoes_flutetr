import 'package:flutter/material.dart';
import '../../../../theme/app_theme.dart';

class AgencyBookingsScreen extends StatelessWidget {
  const AgencyBookingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.bgDeep,
      body: Center(
        child: Text(
          'Bookings\n(Phase 6)',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
