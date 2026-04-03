import 'package:flutter/material.dart';
import '../../../../theme/app_theme.dart';

class AgencyMessagesScreen extends StatelessWidget {
  const AgencyMessagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.bgDeep,
      body: Center(
        child: Text(
          'Messages\n(Phase 8)',
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
