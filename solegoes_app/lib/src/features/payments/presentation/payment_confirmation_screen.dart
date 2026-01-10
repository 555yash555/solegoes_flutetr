import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';
import '../../../theme/app_theme.dart';
import '../../bookings/data/booking_repository.dart';
import '../../bookings/domain/booking.dart';

/// Payment confirmation screen with booking details
/// Reference: designs/option15_payment_confirmation.html
class PaymentConfirmationScreen extends ConsumerWidget {
  final String bookingId;

  const PaymentConfirmationScreen({
    super.key,
    required this.bookingId,
  });

  String _formatDate(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    final hour =
        date.hour > 12 ? date.hour - 12 : (date.hour == 0 ? 12 : date.hour);
    final amPm = date.hour >= 12 ? 'PM' : 'AM';
    final minute = date.minute.toString().padLeft(2, '0');
    return '${months[date.month - 1]} ${date.day}, ${date.year}, $hour:$minute $amPm';
  }

  String _formatAmount(double amount) {
    return amount.toStringAsFixed(0).replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]},',
        );
  }

  void _shareReceipt(BuildContext context, Booking booking) {
    final receiptText = '''
🎉 SoleGoes Booking Confirmation

Trip: ${booking.tripTitle}
Location: ${booking.tripLocation}
Duration: ${booking.tripDuration} Days

💰 Amount Paid: ₹${_formatAmount(booking.amount)}
📅 Booking Date: ${_formatDate(booking.bookingDate)}
🔖 Booking ID: ${booking.bookingId}
💳 Payment ID: ${booking.paymentId}

Thank you for booking with SoleGoes!
Your adventure awaits! 🌍✨
''';

    Share.share(receiptText, subject: 'SoleGoes Booking Receipt');
  }

  void _copyToClipboard(BuildContext context, Booking booking) {
    final receiptText = '''
SoleGoes Booking Receipt
------------------------
Trip: ${booking.tripTitle}
Location: ${booking.tripLocation}
Duration: ${booking.tripDuration} Days
Amount: ₹${_formatAmount(booking.amount)}
Date: ${_formatDate(booking.bookingDate)}
Booking ID: ${booking.bookingId}
Payment ID: ${booking.paymentId}
Status: ${booking.status.name.toUpperCase()}
''';

    Clipboard.setData(ClipboardData(text: receiptText));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text(
          'Receipt copied to clipboard',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  Future<void> _generateAndSharePdf(BuildContext context, Booking booking) async {
    // Load a font that supports Unicode (including ₹ symbol)
    final font = await PdfGoogleFonts.notoSansRegular();
    final fontBold = await PdfGoogleFonts.notoSansBold();

    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        theme: pw.ThemeData.withFont(
          base: font,
          bold: fontBold,
        ),
        build: (pw.Context ctx) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Header
              pw.Container(
                width: double.infinity,
                padding: const pw.EdgeInsets.all(20),
                decoration: pw.BoxDecoration(
                  color: PdfColor.fromHex('#6366F1'),
                  borderRadius: pw.BorderRadius.circular(8),
                ),
                child: pw.Column(
                  children: [
                    pw.Text(
                      'SoleGoes',
                      style: pw.TextStyle(
                        fontSize: 28,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.white,
                      ),
                    ),
                    pw.SizedBox(height: 4),
                    pw.Text(
                      'Booking Confirmation',
                      style: const pw.TextStyle(
                        fontSize: 14,
                        color: PdfColors.white,
                      ),
                    ),
                  ],
                ),
              ),
              pw.SizedBox(height: 30),

              // Success message
              pw.Center(
                child: pw.Column(
                  children: [
                    pw.Container(
                      width: 60,
                      height: 60,
                      decoration: pw.BoxDecoration(
                        shape: pw.BoxShape.circle,
                        border: pw.Border.all(
                          color: PdfColor.fromHex('#4CAF50'),
                          width: 3,
                        ),
                      ),
                      child: pw.Center(
                        child: pw.Text(
                          'OK',
                          style: pw.TextStyle(
                            fontSize: 20,
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColor.fromHex('#4CAF50'),
                          ),
                        ),
                      ),
                    ),
                    pw.SizedBox(height: 12),
                    pw.Text(
                      'Payment Successful!',
                      style: pw.TextStyle(
                        fontSize: 22,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              pw.SizedBox(height: 30),

              // Trip Details Section
              pw.Container(
                width: double.infinity,
                padding: const pw.EdgeInsets.all(20),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: PdfColors.grey300),
                  borderRadius: pw.BorderRadius.circular(8),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'TRIP DETAILS',
                      style: pw.TextStyle(
                        fontSize: 12,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.grey600,
                        letterSpacing: 1,
                      ),
                    ),
                    pw.SizedBox(height: 16),
                    _buildPdfRow('Trip Name', booking.tripTitle, font, fontBold),
                    pw.SizedBox(height: 10),
                    _buildPdfRow('Location', booking.tripLocation, font, fontBold),
                    pw.SizedBox(height: 10),
                    _buildPdfRow('Duration', '${booking.tripDuration} Days', font, fontBold),
                  ],
                ),
              ),
              pw.SizedBox(height: 20),

              // Payment Details Section
              pw.Container(
                width: double.infinity,
                padding: const pw.EdgeInsets.all(20),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: PdfColors.grey300),
                  borderRadius: pw.BorderRadius.circular(8),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'PAYMENT DETAILS',
                      style: pw.TextStyle(
                        fontSize: 12,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.grey600,
                        letterSpacing: 1,
                      ),
                    ),
                    pw.SizedBox(height: 16),
                    _buildPdfRow(
                      'Amount Paid',
                      'INR ${_formatAmount(booking.amount)}',
                      font,
                      fontBold,
                      valueColor: PdfColor.fromHex('#4CAF50'),
                      isBold: true,
                    ),
                    pw.SizedBox(height: 10),
                    _buildPdfRow('Booking ID', booking.bookingId, font, fontBold),
                    pw.SizedBox(height: 10),
                    _buildPdfRow('Payment ID', booking.paymentId, font, fontBold),
                    pw.SizedBox(height: 10),
                    _buildPdfRow('Date', _formatDate(booking.bookingDate), font, fontBold),
                    pw.SizedBox(height: 10),
                    _buildPdfRow(
                      'Status',
                      booking.status.name.toUpperCase(),
                      font,
                      fontBold,
                      valueColor: PdfColor.fromHex('#4CAF50'),
                    ),
                  ],
                ),
              ),
              pw.SizedBox(height: 30),

              // Footer
              pw.Container(
                width: double.infinity,
                padding: const pw.EdgeInsets.all(16),
                decoration: pw.BoxDecoration(
                  color: PdfColors.grey100,
                  borderRadius: pw.BorderRadius.circular(8),
                ),
                child: pw.Column(
                  children: [
                    pw.Text(
                      'Thank you for booking with SoleGoes!',
                      style: pw.TextStyle(
                        fontSize: 14,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.SizedBox(height: 4),
                    pw.Text(
                      'Your adventure awaits!',
                      style: const pw.TextStyle(
                        fontSize: 12,
                        color: PdfColors.grey700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );

    // Save PDF to temp directory and share
    final pdfBytes = await pdf.save();
    final tempDir = await getTemporaryDirectory();
    final filename = 'SoleGoes_Receipt_${booking.bookingId}.pdf';
    final file = File('${tempDir.path}/$filename');
    await file.writeAsBytes(pdfBytes);

    // Share the file using share_plus (not printing)
    await Share.shareXFiles(
      [XFile(file.path)],
      subject: 'SoleGoes Booking Receipt',
    );
  }

  pw.Widget _buildPdfRow(
    String label,
    String value,
    pw.Font font,
    pw.Font fontBold, {
    PdfColor? valueColor,
    bool isBold = false,
  }) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          label,
          style: pw.TextStyle(
            font: font,
            fontSize: 12,
            color: PdfColors.grey700,
          ),
        ),
        pw.Expanded(
          child: pw.Text(
            value,
            style: pw.TextStyle(
              font: isBold ? fontBold : font,
              fontSize: 12,
              color: valueColor ?? PdfColors.black,
            ),
            textAlign: pw.TextAlign.right,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Try to fetch booking from Firebase
    final bookingAsync = ref.watch(bookingProvider(bookingId));

    return Scaffold(
      backgroundColor: AppColors.bgDeep,
      body: SafeArea(
        child: bookingAsync.when(
          data: (booking) {
            if (booking == null) {
              // Fallback for legacy payment IDs (before Firebase integration)
              return _buildFallbackContent(context);
            }
            return _buildContent(context, booking);
          },
          loading: () => const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          ),
          error: (_, __) => _buildFallbackContent(context),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, Booking booking) {
    final formattedDate = _formatDate(booking.bookingDate);
    final isFailed = booking.paymentStatus == PaymentStatus.failed;
    final isPending = booking.paymentStatus == PaymentStatus.pending;

    return Column(
      children: [
        // Scrollable content
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
            child: Column(
              children: [
                // Close button
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: GestureDetector(
                      onTap: () => context.go('/'),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.05),
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.borderSubtle),
                        ),
                        child: const Icon(
                          LucideIcons.x,
                          size: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Status icon
                _buildStatusIcon(booking.paymentStatus),

                const SizedBox(height: 16),

                // Status text
                Text(
                  isFailed
                      ? 'Payment Failed'
                      : isPending
                          ? 'Payment Pending'
                          : 'Payment Successful!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: isFailed
                        ? const Color(0xFFEF4444)
                        : isPending
                            ? const Color(0xFFEAB308)
                            : Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  isFailed
                      ? booking.failureReason ?? 'Your payment could not be processed'
                      : isPending
                          ? 'Your payment is being processed'
                          : 'Your booking has been confirmed',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withValues(alpha: 0.5),
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 20),

                // Receipt card
                _buildReceiptCard(booking, formattedDate),
              ],
            ),
          ),
        ),

        // Fixed bottom buttons
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDownloadButton(context, booking),
              const SizedBox(height: 12),
              _buildViewTripButton(context, booking.tripId),
              const SizedBox(height: 12),
              _buildBackToHomeButton(context),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFallbackContent(BuildContext context) {
    final now = DateTime.now();
    final formattedDate = _formatDate(now);

    return Column(
      children: [
        // Scrollable content
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
            child: Column(
              children: [
                // Close button
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: GestureDetector(
                      onTap: () => context.go('/'),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.05),
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.borderSubtle),
                        ),
                        child: const Icon(
                          LucideIcons.x,
                          size: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                _buildSuccessIcon(),

                const SizedBox(height: 16),

                const Text(
                  'Payment Successful!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Your booking has been confirmed',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withValues(alpha: 0.5),
                  ),
                ),

                const SizedBox(height: 20),

                // Simple receipt card with just payment ID
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.03),
                    borderRadius: BorderRadius.circular(AppRadius.md),
                    border: Border.all(color: AppColors.borderSubtle),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'TRANSACTION DETAILS',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: Colors.white.withValues(alpha: 0.4),
                          letterSpacing: 1,
                        ),
                      ),
                      const SizedBox(height: 20),
                      _buildDetailRow(
                        'Transaction ID',
                        bookingId,
                        valueStyle: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'monospace',
                          color: Colors.white70,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildDetailRow('Date', formattedDate),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        // Fixed bottom buttons
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildViewTripButton(context, null),
              const SizedBox(height: 12),
              _buildBackToHomeButton(context),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatusIcon(PaymentStatus status) {
    final isFailed = status == PaymentStatus.failed;
    final isPending = status == PaymentStatus.pending;

    final color = isFailed
        ? const Color(0xFFEF4444)
        : isPending
            ? const Color(0xFFEAB308)
            : const Color(0xFF4CAF50);

    final icon = isFailed
        ? LucideIcons.x
        : isPending
            ? LucideIcons.clock
            : LucideIcons.check;

    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        shape: BoxShape.circle,
        border: Border.all(
          color: color,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.2),
            blurRadius: 20,
          ),
        ],
      ),
      child: Icon(
        icon,
        size: 48,
        color: color,
      ),
    );
  }

  // Keep for fallback content
  Widget _buildSuccessIcon() {
    return _buildStatusIcon(PaymentStatus.success);
  }

  Widget _buildReceiptCard(Booking booking, String formattedDate) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'TRANSACTION DETAILS',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: Colors.white.withValues(alpha: 0.4),
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 20),

          // Trip name
          _buildDetailRow('Trip Name', booking.tripTitle),
          const SizedBox(height: 16),

          // Location & Duration
          _buildDetailRow('Location', booking.tripLocation),
          const SizedBox(height: 16),
          _buildDetailRow('Duration', '${booking.tripDuration} Days'),
          const SizedBox(height: 16),

          // Amount paid
          _buildDetailRow(
            'Amount Paid',
            '₹${_formatAmount(booking.amount)}',
            valueColor: const Color(0xFF4ADE80),
          ),

          const SizedBox(height: 16),

          // Divider
          Container(
            height: 1,
            color: Colors.white.withValues(alpha: 0.1),
          ),

          const SizedBox(height: 16),

          // Booking ID
          _buildDetailRow(
            'Booking ID',
            booking.bookingId,
            valueStyle: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              fontFamily: 'monospace',
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 16),

          // Payment ID
          _buildDetailRow(
            'Payment ID',
            booking.paymentId,
            valueStyle: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              fontFamily: 'monospace',
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 16),

          // Date
          _buildDetailRow('Date', formattedDate),
        ],
      ),
    );
  }

  Widget _buildDetailRow(
    String label,
    String value, {
    Color? valueColor,
    TextStyle? valueStyle,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.white.withValues(alpha: 0.6),
          ),
        ),
        const SizedBox(width: 16),
        Flexible(
          child: Text(
            value,
            style: valueStyle ??
                TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: valueColor ?? Colors.white,
                ),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }

  Widget _buildDownloadButton(BuildContext context, Booking booking) {
    return GestureDetector(
      onTap: () {
        // Show options: Share or Copy
        showModalBottomSheet(
          context: context,
          backgroundColor: AppColors.bgSurface,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          builder: (ctx) => SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Download Receipt',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Download PDF option
                  ListTile(
                    leading: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        LucideIcons.fileText,
                        color: AppColors.primary,
                      ),
                    ),
                    title: const Text(
                      'Download PDF',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Text(
                      'Save or share as PDF document',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.5),
                        fontSize: 12,
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(ctx);
                      _generateAndSharePdf(context, booking);
                    },
                  ),
                  const SizedBox(height: 8),
                  // Share text option
                  ListTile(
                    leading: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        LucideIcons.share2,
                        color: Colors.white,
                      ),
                    ),
                    title: const Text(
                      'Share as Text',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Text(
                      'Share via WhatsApp, Email, etc.',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.5),
                        fontSize: 12,
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(ctx);
                      _shareReceipt(context, booking);
                    },
                  ),
                  const SizedBox(height: 8),
                  // Copy option
                  ListTile(
                    leading: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        LucideIcons.copy,
                        color: Colors.white,
                      ),
                    ),
                    title: const Text(
                      'Copy to Clipboard',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Text(
                      'Copy receipt details as text',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.5),
                        fontSize: 12,
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(ctx);
                      _copyToClipboard(context, booking);
                    },
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        );
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(AppRadius.full),
          border: Border.all(color: AppColors.borderSubtle),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              LucideIcons.download,
              size: 20,
              color: Colors.white,
            ),
            SizedBox(width: 8),
            Text(
              'Download Receipt',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildViewTripButton(BuildContext context, String? tripId) {
    return GestureDetector(
      onTap: () {
        if (tripId != null) {
          context.push('/trip/$tripId');
        } else {
          context.go('/');
        }
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
          borderRadius: BorderRadius.circular(AppRadius.full),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.4),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Text(
          'View Trip Details',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildBackToHomeButton(BuildContext context) {
    return GestureDetector(
      onTap: () => context.go('/'),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Text(
          'Back to Home',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.white.withValues(alpha: 0.5),
          ),
        ),
      ),
    );
  }
}
