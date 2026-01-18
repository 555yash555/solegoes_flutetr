import 'package:flutter/material.dart';

/// ===========================================
/// APP COLORS
/// Source: designs/modern_theme.css
/// ===========================================
class AppColors {
  AppColors._();

  // Core - Zinc Palette
  static const Color bgDeep = Color(0xFF09090B);      // --bg-deep (Zinc 950)
  static const Color bgSurface = Color(0xFF18181B);   // --bg-surface (Zinc 900)
  static const Color bgGlass = Color(0xB318181B);     // --bg-glass (70% opacity)
  static const Color bgGlassLight = Color(0x08FFFFFF); // rgba(255,255,255,0.03)
  static const Color bgCard = Color(0xFF111111);      // Card background

  // Text
  static const Color textPrimary = Color(0xFFFAFAFA);   // --text-primary (Zinc 50)
  static const Color textSecondary = Color(0xFFA1A1AA); // --text-secondary (Zinc 400)
  static const Color textTertiary = Color(0xFF52525B);  // --text-tertiary (Zinc 600)
  static const Color textPlaceholder = Color(0x4DFFFFFF); // rgba(255,255,255,0.3)

  // Accents
  static const Color primary = Color(0xFF6366F1);       // --primary (Indigo 500)
  static const Color violet = Color(0xFF8B5CF6);        // Violet 500
  static const Color accentBlue = Color(0xFF3B82F6);    // --accent-blue
  static const Color accentTeal = Color(0xFF14B8A6);    // --accent-teal
  static const Color accentRose = Color(0xFFF43F5E);    // --accent-rose
  static const Color accentGreen = Color(0xFF4CAF50);   // --accent-green

  // Error states
  static const Color error = Color(0xFFEF4444);         // Red 500
  static const Color errorBg = Color(0xFF1C1517);       // Dark red tint
  static const Color errorBorder = Color(0xFF7F1D1D);   // Red border
  static const Color errorIcon = Color(0xFFF87171);     // Red 400

  // Success states
  static const Color success = Color(0xFF10B981);       // Emerald 500
  static const Color successBg = Color(0xFF141C17);     // Dark green tint
  static const Color successBorder = Color(0xFF14532D); // Green border
  static const Color successIcon = Color(0xFF4ADE80);   // Green 400

  // Borders
  static const Color borderSubtle = Color(0x0FFFFFFF);  // 6% white
  static const Color borderGlass = Color(0x1AFFFFFF);   // 10% white
  static const Color borderFocus = Color(0x4DFFFFFF);   // 30% white

  // Surface Overlays (for hover, pressed states)
  static const Color surfaceOverlay = Color(0x08FFFFFF);    // 3% white - Cards, containers
  static const Color surfaceHover = Color(0x0DFFFFFF);      // 5% white - Hover state
  static const Color surfacePressed = Color(0x1AFFFFFF);    // 10% white - Pressed state
  static const Color surfaceSelected = Color(0x26FFFFFF);   // 15% white - Selected state
  
  // Dividers & Separators
  static const Color divider = Color(0x1AFFFFFF);           // 10% white
  static const Color dividerLight = Color(0x0DFFFFFF);      // 5% white
  
  // Overlays & Scrims
  static const Color overlay = Color(0x80000000);           // 50% black - Modal overlay
  static const Color scrim = Color(0xB3000000);             // 70% black - Image scrim
  static const Color scrimLight = Color(0x66000000);        // 40% black - Light scrim
  
  // Shimmer & Loading
  static const Color shimmer = Color(0x33FFFFFF);           // 20% white - Shimmer effect
  static const Color shimmerHighlight = Color(0x4DFFFFFF);  // 30% white - Shimmer highlight
  
  // Text Variations (additional alpha values)
  static const Color textMuted = Color(0x80FFFFFF);         // 50% white - Muted text
  static const Color textHint = Color(0x66FFFFFF);          // 40% white - Hint text
  static const Color textDisabled = Color(0x4DFFFFFF);      // 30% white - Disabled text
  
  // Icon Variations
  static const Color iconMuted = Color(0x4DFFFFFF);         // 30% white - Muted icons
  static const Color iconDisabled = Color(0x33FFFFFF);      // 20% white - Disabled icons
  
  // Category Pills (specific to design)
  static final Color pillActiveBg = primary.withValues(alpha: 0.15);  // 15% primary
  static const Color pillInactiveBg = Color(0x08FFFFFF);    // 3% white

  // Gradient
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Shadow colors
  static const Color shadowPrimary = Color(0x336366F1);  // primary with 20% opacity
}

/// ===========================================
/// APP SPACING
/// ===========================================
class AppSpacing {
  AppSpacing._();

  static const double xs = 8.0;
  static const double sm = 12.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;
}

/// ===========================================
/// APP RADIUS
/// Source: designs/modern_theme.css
/// ===========================================
class AppRadius {
  AppRadius._();

  static const double sm = 8.0;       // --radius-sm
  static const double md = 16.0;      // --radius-md
  static const double lg = 24.0;      // --radius-lg
  static const double full = 9999.0;  // --radius-full (pill shape)

  // BorderRadius instances for convenience
  static final BorderRadius smAll = BorderRadius.circular(sm);
  static final BorderRadius mdAll = BorderRadius.circular(md);
  static final BorderRadius lgAll = BorderRadius.circular(lg);
  static final BorderRadius fullAll = BorderRadius.circular(full);
}

/// ===========================================
/// APP SHADOWS
/// ===========================================
class AppShadows {
  AppShadows._();

  static const List<BoxShadow> sm = [
    BoxShadow(
      color: Color(0x1A000000),
      blurRadius: 4,
      offset: Offset(0, 2),
    ),
  ];

  static const List<BoxShadow> md = [
    BoxShadow(
      color: Color(0x26000000),
      blurRadius: 8,
      offset: Offset(0, 4),
    ),
  ];

  static const List<BoxShadow> lg = [
    BoxShadow(
      color: Color(0x33000000),
      blurRadius: 16,
      offset: Offset(0, 8),
    ),
  ];

  static const List<BoxShadow> primaryGlow = [
    BoxShadow(
      color: Color(0x336366F1), // primary with 20% opacity
      blurRadius: 6,
      offset: Offset(0, 4),
    ),
  ];

  static const List<BoxShadow> navIsland = [
    BoxShadow(
      color: Color(0x80000000), // 50% black
      blurRadius: 25,
      offset: Offset(0, 20),
    ),
  ];
}

/// ===========================================
/// APP TEXT STYLES
/// Font: Plus Jakarta Sans (configured in pubspec)
/// ===========================================
class AppTextStyles {
  AppTextStyles._();

  // Headings
  static const TextStyle h1 = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w800,
    color: AppColors.textPrimary,
    height: 1.2,
  );

  static const TextStyle h2 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    height: 1.3,
  );

  static const TextStyle h3 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.4,
  );

  // Body
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
    height: 1.5,
  );

  static const TextStyle body = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
    height: 1.5,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    height: 1.5,
  );

  // Labels
  static const TextStyle label = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static const TextStyle labelSmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
  );

  // Section title (uppercase)
  static const TextStyle sectionTitle = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w700,
    color: AppColors.textTertiary,
    letterSpacing: 0.5,
  );

  // Button text
  static const TextStyle button = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  static const TextStyle buttonSmall = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  // Caption
  static const TextStyle caption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textTertiary,
  );

  // Additional heading sizes
  static const TextStyle h4 = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.4,
  );

  static const TextStyle h5 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.4,
  );

  // Body variations with different weights
  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
    height: 1.5,
  );

  static const TextStyle bodyRegular = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
    height: 1.5,
  );

  // Label variations
  static const TextStyle labelLarge = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static const TextStyle labelMedium = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
  );

  // Overline (for category labels, etc)
  static const TextStyle overline = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w600,
    color: AppColors.textTertiary,
    letterSpacing: 1.5,
  );

  // Price text
  static const TextStyle price = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  static const TextStyle priceSmall = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  // Link text
  static const TextStyle link = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.primary,
    decoration: TextDecoration.underline,
  );

  static const TextStyle linkSmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.primary,
  );
}

/// ===========================================
/// APP DURATIONS
/// ===========================================
class AppDurations {
  AppDurations._();

  static const Duration fast = Duration(milliseconds: 150);
  static const Duration normal = Duration(milliseconds: 200);
  static const Duration slow = Duration(milliseconds: 300);
  static const Duration slower = Duration(milliseconds: 500);
}

/// ===========================================
/// APP THEME DATA
/// ===========================================
class AppTheme {
  AppTheme._();

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.bgDeep,
      primaryColor: AppColors.primary,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary,
        secondary: AppColors.violet,
        surface: AppColors.bgSurface,
        error: AppColors.error,
      ),
      fontFamily: 'Plus Jakarta Sans',
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: AppTextStyles.h3,
        iconTheme: IconThemeData(color: AppColors.textPrimary),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.bgGlassLight,
        border: OutlineInputBorder(
          borderRadius: AppRadius.mdAll,
          borderSide: const BorderSide(color: AppColors.borderSubtle),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppRadius.mdAll,
          borderSide: const BorderSide(color: AppColors.borderSubtle),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadius.mdAll,
          borderSide: const BorderSide(color: AppColors.primary),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppRadius.mdAll,
          borderSide: const BorderSide(color: AppColors.error),
        ),
        hintStyle: const TextStyle(color: AppColors.textPlaceholder),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.mdAll,
          ),
          textStyle: AppTextStyles.button,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          textStyle: AppTextStyles.buttonSmall,
        ),
      ),
      snackBarTheme: const SnackBarThemeData(
        backgroundColor: Colors.transparent,
        elevation: 0,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
