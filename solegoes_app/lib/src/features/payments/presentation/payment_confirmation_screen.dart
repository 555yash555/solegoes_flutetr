import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../theme/app_theme.dart';

/// Payment confirmation screen with booking details
/// Reference: designs/option15_payment_confirmation.html
class PaymentConfirmationScreen extends ConsumerWidget {
  final String bookingId;

  const PaymentConfirmationScreen({
    super.key,
    required this.bookingId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.bgDeep,
      body: Center(
        child: Text(
          'Payment Confirmation Screen\nBooking ID: $bookingId\n(To be implemented)',
          textAlign: TextAlign.center,
          style: const TextStyle(color: AppColors.textSecondary),
        ),
      ),
    );
  }
}
