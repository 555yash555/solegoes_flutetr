import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../theme/app_theme.dart';

/// Payment method selection screen
/// Reference: designs/option15_payment_method.html
class PaymentMethodScreen extends ConsumerWidget {
  final String tripId;

  const PaymentMethodScreen({
    super.key,
    required this.tripId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.bgDeep,
      body: Center(
        child: Text(
          'Payment Method Screen\nTrip ID: $tripId\n(To be implemented)',
          textAlign: TextAlign.center,
          style: const TextStyle(color: AppColors.textSecondary),
        ),
      ),
    );
  }
}
