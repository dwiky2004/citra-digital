import 'dart:math';
import 'dart:typed_data';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';

class ImageMetricsResult {
  final double mse;
  final double psnr;
  final int originalSize;
  final int compressedSize;
  final String compressedImagePath;
  
  ImageMetricsResult({
    required this.mse,
    required this.psnr,
    required this.originalSize,
    required this.compressedSize,
    required this.compressedImagePath,
  });
  
  double get compressionRatio {
    if (originalSize == 0) return 0;
    return (1 - (compressedSize / originalSize)) * 100;
  }
}

class ProcessImageParams {
  final Uint8List originalBytes;
  final int quality;
  final String tempDirPath;

  ProcessImageParams({
    required this.originalBytes,
    required this.quality,
    required this.tempDirPath,
  });
}

class ImageUtils {
  /// Calculate Mean Squared Error (MSE) between two images.
  /// Formula: MSE = 1/MN * sum([I(i,j) - K(i,j)]^2)
  static double calculateMSE(img.Image original, img.Image compressed) {
    if (original.width != compressed.width || original.height != compressed.height) {
      compressed = img.copyResize(compressed, width: original.width, height: original.height);
    }

    double sumSquaredError = 0.0;
    int m = original.width;
    int n = original.height;

    for (int y = 0; y < n; y++) {
      for (int x = 0; x < m; x++) {
        final pixel1 = original.getPixel(x, y);
        final pixel2 = compressed.getPixel(x, y);

        final num r1 = pixel1.r;
        final num g1 = pixel1.g;
        final num b1 = pixel1.b;

        final num r2 = pixel2.r;
        final num g2 = pixel2.g;
        final num b2 = pixel2.b;

        final double rDiff = (r1 - r2).toDouble();
        final double gDiff = (g1 - g2).toDouble();
        final double bDiff = (b1 - b2).toDouble();

        sumSquaredError += (rDiff * rDiff + gDiff * gDiff + bDiff * bDiff) / 3.0;
      }
    }

    return sumSquaredError / (m * n);
  }

  /// Calculate Peak Signal-to-Noise Ratio (PSNR) in decibels (dB).
  /// Formula: PSNR = 10 * log10(MAX^2 / MSE)
  static double calculatePSNR(double mse) {
    if (mse == 0) return double.infinity;
    const double maxPixelValue = 255.0;
    return 10.0 * (log((maxPixelValue * maxPixelValue) / mse) / ln10);
  }

  /// Compress image and compute metrics inside an isolate
  static Future<ImageMetricsResult> _processImageInIsolate(ProcessImageParams params) async {
    final img.Image? originalImage = img.decodeImage(params.originalBytes);
    if (originalImage == null) throw Exception("Failed to decode image");

    final Uint8List compressedBytes = Uint8List.fromList(img.encodeJpg(originalImage, quality: params.quality));
    
    final img.Image? compressedImage = img.decodeImage(compressedBytes);
    if (compressedImage == null) throw Exception("Failed to decode compressed image");

    final double mse = calculateMSE(originalImage, compressedImage);
    final double psnr = calculatePSNR(mse);

    // Save to temp file
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final String tempFilePath = '${params.tempDirPath}/compressed_$timestamp.jpg';
    final File compressedFile = File(tempFilePath);
    await compressedFile.writeAsBytes(compressedBytes);

    return ImageMetricsResult(
      mse: mse,
      psnr: psnr,
      originalSize: params.originalBytes.lengthInBytes,
      compressedSize: compressedBytes.lengthInBytes,
      compressedImagePath: tempFilePath,
    );
  }

  /// Compress an image and compute metrics using compute()
  static Future<ImageMetricsResult> processImage({
    required Uint8List originalBytes,
    required int quality,
  }) async {
    final Directory tempDir = await getTemporaryDirectory();
    final params = ProcessImageParams(
      originalBytes: originalBytes,
      quality: quality,
      tempDirPath: tempDir.path,
    );
    return compute(_processImageInIsolate, params);
  }
}
