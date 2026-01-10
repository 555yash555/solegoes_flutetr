import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

/// Razorpay payment service for handling payments
/// Uses test mode credentials - replace with live keys for production
class RazorpayService {
  // Test mode API key - replace with live key for production
  static const String _apiKey = 'rzp_test_S2GhOyIr6IJXfP';

  late Razorpay _razorpay;

  // Callbacks
  Function(PaymentSuccessResponse)? onPaymentSuccess;
  Function(PaymentFailureResponse)? onPaymentError;
  Function(ExternalWalletResponse)? onExternalWallet;

  RazorpayService() {
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    debugPrint('Payment Success: ${response.paymentId}');
    onPaymentSuccess?.call(response);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    debugPrint('Payment Error: ${response.code} - ${response.message}');
    onPaymentError?.call(response);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    debugPrint('External Wallet: ${response.walletName}');
    onExternalWallet?.call(response);
  }

  /// Open Razorpay checkout
  /// [amount] should be in INR (will be converted to paise)
  /// [tripTitle] - Name of the trip for display
  /// [userEmail] - User's email for receipt
  /// [userPhone] - User's phone number
  void openCheckout({
    required double amount,
    required String tripTitle,
    required String userEmail,
    String? userPhone,
    String? orderId,
  }) {
    // Convert to paise (Razorpay expects amount in smallest currency unit)
    final amountInPaise = (amount * 100).toInt();

    var options = {
      'key': _apiKey,
      'amount': amountInPaise,
      'name': 'SoleGoes',
      'description': tripTitle,
      'prefill': {
        'email': userEmail,
        if (userPhone != null) 'contact': userPhone,
      },
      'theme': {
        'color': '#6366F1', // Primary indigo color
      },
      // For test mode, we don't need order_id
      // In production, generate order_id from backend
      if (orderId != null) 'order_id': orderId,
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error opening Razorpay: $e');
      onPaymentError?.call(PaymentFailureResponse(
        Razorpay.UNKNOWN_ERROR,
        'Failed to open payment gateway',
        null,
      ));
    }
  }

  /// Dispose the Razorpay instance
  void dispose() {
    _razorpay.clear();
  }
}

/// Extension to create PaymentFailureResponse for custom errors
extension PaymentFailureResponseExt on PaymentFailureResponse {
  static PaymentFailureResponse create(int code, String message) {
    return PaymentFailureResponse(code, message, null);
  }
}
