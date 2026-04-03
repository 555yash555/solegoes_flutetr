import 'package:flutter/material.dart';
import '../../../../theme/app_theme.dart';

class AgencyTripsScreen extends StatelessWidget {
  const AgencyTripsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.bgDeep,
      body: Center(
        child: Text(
          'My Trips\n(Phase 5)',
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
