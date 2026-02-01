import 'package:pdf/widgets.dart' as pw;

/// PDF Text Styles — mirrors AppTextStyles for PDF generation
/// Used in payment_confirmation_screen.dart for receipt generation
class PdfTextStyles {
  PdfTextStyles._();

  // Headings
  static pw.TextStyle h1({pw.Font? font}) => pw.TextStyle(
        fontSize: 32,
        fontWeight: pw.FontWeight.bold,
        font: font,
      );

  static pw.TextStyle h2({pw.Font? font}) => pw.TextStyle(
        fontSize: 24,
        fontWeight: pw.FontWeight.bold,
        font: font,
      );

  static pw.TextStyle h3({pw.Font? font}) => pw.TextStyle(
        fontSize: 20,
        fontWeight: pw.FontWeight.bold,
        font: font,
      );

  static pw.TextStyle h4({pw.Font? font}) => pw.TextStyle(
        fontSize: 18,
        fontWeight: pw.FontWeight.bold,
        font: font,
      );

  // Body
  static pw.TextStyle body({pw.Font? font}) => pw.TextStyle(
        fontSize: 15,
        fontWeight: pw.FontWeight.normal,
        font: font,
      );

  static pw.TextStyle bodyMedium({pw.Font? font}) => pw.TextStyle(
        fontSize: 14,
        fontWeight: pw.FontWeight.normal,
        font: font,
      );

  static pw.TextStyle bodySmall({pw.Font? font}) => pw.TextStyle(
        fontSize: 12,
        fontWeight: pw.FontWeight.normal,
        font: font,
      );

  // Labels
  static pw.TextStyle label({pw.Font? font}) => pw.TextStyle(
        fontSize: 14,
        fontWeight: pw.FontWeight.bold,
        font: font,
      );

  static pw.TextStyle labelSmall({pw.Font? font}) => pw.TextStyle(
        fontSize: 12,
        fontWeight: pw.FontWeight.normal,
        font: font,
      );

  static pw.TextStyle labelMedium({pw.Font? font}) => pw.TextStyle(
        fontSize: 13,
        fontWeight: pw.FontWeight.normal,
        font: font,
      );

  // Caption
  static pw.TextStyle caption({pw.Font? font}) => pw.TextStyle(
        fontSize: 12,
        fontWeight: pw.FontWeight.normal,
        font: font,
      );

  // Badge text
  static pw.TextStyle badgeText({pw.Font? font}) => pw.TextStyle(
        fontSize: 12,
        fontWeight: pw.FontWeight.bold,
        font: font,
      );

  // Price
  static pw.TextStyle price({pw.Font? font}) => pw.TextStyle(
        fontSize: 18,
        fontWeight: pw.FontWeight.bold,
        font: font,
      );

  // Overline (uppercase labels)
  static pw.TextStyle overline({pw.Font? font}) => pw.TextStyle(
        fontSize: 10,
        fontWeight: pw.FontWeight.bold,
        font: font,
        letterSpacing: 1.5,
      );

  // Monospace (for receipt numbers, codes)
  static pw.TextStyle monospace({pw.Font? fontMono}) => pw.TextStyle(
        fontSize: 11,
        fontWeight: pw.FontWeight.bold,
        font: fontMono,
      );
}
