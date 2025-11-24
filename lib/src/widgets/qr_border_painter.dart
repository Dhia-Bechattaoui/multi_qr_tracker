import 'package:flutter/material.dart';
import '../models/qr_code_info.dart';

/// Custom painter that draws borders around detected QR codes.
///
/// The borders are slightly larger than the actual QR code and adapt
/// dynamically as the user moves closer or further from the QR code.
class QrBorderPainter extends CustomPainter {
  /// Creates a [QrBorderPainter] with the given QR codes and styling options.
  QrBorderPainter({
    required this.qrCodes,
    this.borderColor = Colors.green,
    this.borderWidth = 3.0,
    this.borderPadding = 8.0,
    this.cornerRadius = 12.0,
  });

  /// List of detected QR codes to draw borders around
  final List<QrCodeInfo> qrCodes;

  /// Default color of the border (used if not generating unique colors)
  final Color borderColor;

  /// Width of the border line
  final double borderWidth;

  /// Extra padding around the QR code (makes border slightly bigger)
  final double borderPadding;

  /// Radius for rounded corners
  final double cornerRadius;

  /// Generate a unique color for a QR code value
  Color _getColorForQrValue(final String value) {
    // Generate hash from QR code value
    final hash = value.hashCode;

    // Use hash to generate HSL color with good visibility
    final hue = (hash % 360).toDouble();
    const saturation = 0.7;
    const lightness = 0.5;

    return HSLColor.fromAHSL(1, hue, saturation, lightness).toColor();
  }

  @override
  void paint(final Canvas canvas, final Size size) {
    // Track colors used for each unique QR value
    final colorMap = <String, Color>{};

    for (final qrCode in qrCodes) {
      // Get or generate color for this QR value
      final color = colorMap.putIfAbsent(
        qrCode.value,
        () => _getColorForQrValue(qrCode.value),
      );

      final paint = Paint()
        ..color = color
        ..strokeWidth = borderWidth
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round;

      // Create a rounded rectangle that's slightly larger than the QR code
      final borderRect = RRect.fromRectAndRadius(
        Rect.fromLTRB(
          qrCode.boundingBox.left - borderPadding,
          qrCode.boundingBox.top - borderPadding,
          qrCode.boundingBox.right + borderPadding,
          qrCode.boundingBox.bottom + borderPadding,
        ),
        Radius.circular(cornerRadius),
      );

      canvas.drawRRect(borderRect, paint);

      // Draw corner highlights for better visibility
      _drawCornerHighlights(canvas, borderRect, paint, color);
    }
  }

  void _drawCornerHighlights(
    final Canvas canvas,
    final RRect rect,
    final Paint paint,
    final Color color,
  ) {
    const cornerLength = 20.0;
    final cornerPaint = Paint()
      ..color = color
      ..strokeWidth = borderWidth + 1.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // Top-left corner
    canvas
      ..drawLine(
        Offset(rect.left, rect.top + cornerLength),
        Offset(rect.left, rect.top),
        cornerPaint,
      )
      ..drawLine(
        Offset(rect.left, rect.top),
        Offset(rect.left + cornerLength, rect.top),
        cornerPaint,
      )
      // Top-right corner
      ..drawLine(
        Offset(rect.right - cornerLength, rect.top),
        Offset(rect.right, rect.top),
        cornerPaint,
      )
      ..drawLine(
        Offset(rect.right, rect.top),
        Offset(rect.right, rect.top + cornerLength),
        cornerPaint,
      )
      // Bottom-left corner
      ..drawLine(
        Offset(rect.left, rect.bottom - cornerLength),
        Offset(rect.left, rect.bottom),
        cornerPaint,
      )
      ..drawLine(
        Offset(rect.left, rect.bottom),
        Offset(rect.left + cornerLength, rect.bottom),
        cornerPaint,
      )
      // Bottom-right corner
      ..drawLine(
        Offset(rect.right - cornerLength, rect.bottom),
        Offset(rect.right, rect.bottom),
        cornerPaint,
      )
      ..drawLine(
        Offset(rect.right, rect.bottom),
        Offset(rect.right, rect.bottom - cornerLength),
        cornerPaint,
      );
  }

  @override
  bool shouldRepaint(final QrBorderPainter oldDelegate) =>
      qrCodes != oldDelegate.qrCodes ||
      borderColor != oldDelegate.borderColor ||
      borderWidth != oldDelegate.borderWidth ||
      borderPadding != oldDelegate.borderPadding ||
      cornerRadius != oldDelegate.cornerRadius;
}
