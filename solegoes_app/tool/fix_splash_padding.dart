import 'dart:io';
import 'package:image/image.dart';

void main() async {
  // 1. Load the original high-quality logo (Black background)
  final inputPath = 'assets/images/logo_original.png';
  
  // We'll update the foreground image used by splash and adaptive icons
  final outPathForeground = 'assets/images/logo_foreground.png'; 
  final outPathIOS = 'assets/images/logo_ios.png'; // Black bg version

  final file = File(inputPath);
  if (!file.existsSync()) {
    print('Error: $inputPath not found');
    exit(1);
  }

  final bytes = await file.readAsBytes();
  var image = decodeImage(bytes);
  if (image == null) {
    print('Failed to decode image');
    exit(1);
  }

  print('Original size: ${image.width}x${image.height}');

  // 2. Remove Black Background -> Transparent
  final p = image.getBytes();
  for (var i = 0; i < p.length; i += 4) {
    final r = p[i];
    final g = p[i + 1];
    final b = p[i + 2];
    // Simple "is black/dark" check
    if (r < 25 && g < 25 && b < 25) {
      p[i + 3] = 0; // Set Alpha to 0
    }
  }

  // 3. Trim transparent edges
  image = trim(image, mode: TrimMode.transparent);
  print('Trimmed size: ${image.width}x${image.height}');

  // 4. Create output canvas (Standard 1024x1024)
  final size = 1024;
  final finalForeground = Image(width: size, height: size); // Transparent
  
  // 5. RESIZE Logic - Aggressive Padding
  // Android Safe Zone is ~66% (circle within square).
  // Previous attempt: 70% (Too big, passing safe zone).
  // New attempt: 50% (0.5) of canvas.
  // This ensures the logo stays well within the central circle.
  final maxDim = (size * 0.50).round();
  
  final resizedLogo = copyResize(image, 
    width: image.width > image.height ? maxDim : null,
    height: image.height >= image.width ? maxDim : null,
    interpolation: Interpolation.linear // Better quality for shrinking
  );
  
  // Center it
  final x = (size - resizedLogo.width) ~/ 2;
  final y = (size - resizedLogo.height) ~/ 2;
  
  compositeImage(finalForeground, resizedLogo, dstX: x, dstY: y);

  // Save Foreground (for Android Splash & Adaptive Icon)
  await File(outPathForeground).writeAsBytes(encodePng(finalForeground));
  print('Saved $outPathForeground (Scaled to ~50% of canvas)');
  
  // 6. Generate iOS/Legacy (Black background)
  // Reuse the same padded logo, but put black behind it.
  final finalIOS = Image(width: size, height: size);
   for (var pixel in finalIOS) {
    pixel.setRgb(0, 0, 0); // Black
    pixel.a = 255;
  }
  compositeImage(finalIOS, finalForeground); // Overlay the centered logo
  
  await File(outPathIOS).writeAsBytes(encodePng(finalIOS));
  print('Saved $outPathIOS');
}
