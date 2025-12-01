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
    this.borderColor,
    this.borderWidth = 3.0,
    this.borderPadding = 8.0,
    this.cornerRadius = 12.0,
  });

  /// List of detected QR codes to draw borders around
  final List<QrCodeInfo> qrCodes;

  /// Color of the border. If null, random colors will be generated
  /// for each unique QR value.
  final Color? borderColor;

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
    // (only when borderColor is null)
    final colorMap = <String, Color>{};

    for (final qrCode in qrCodes) {
      // Use provided borderColor if set, otherwise generate
      // unique color per QR value
      final color =
          borderColor ??
          colorMap.putIfAbsent(
            qrCode.value,
            () => _getColorForQrValue(qrCode.value),
          );

      final paint = Paint()
        ..color = color
        ..strokeWidth = borderWidth
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round;

      // Draw border using actual corner points to match QR rotation
      if (qrCode.corners.length == 4) {
        // Calculate center of QR code
        final center = qrCode.center;

        // Expand corners outward from center for padding
        final expandedCorners = qrCode.corners.map((final corner) {
          final direction = corner - center;
          final distance = direction.distance;
          if (distance > 0) {
            final normalized = direction / distance;
            return corner + (normalized * borderPadding);
          }
          return corner;
        }).toList();

        // Draw the quadrilateral border
        final path = Path()
          ..moveTo(expandedCorners[0].dx, expandedCorners[0].dy);
        for (var i = 1; i < expandedCorners.length; i++) {
          path.lineTo(expandedCorners[i].dx, expandedCorners[i].dy);
        }
        path.close();

        canvas.drawPath(path, paint);

        // Draw corner highlights for better visibility
        _drawCornerHighlights(canvas, expandedCorners, paint, color);
      }
    }
  }

  void _drawCornerHighlights(
    final Canvas canvas,
    final List<Offset> corners,
    final Paint paint,
    final Color color,
  ) {
    const cornerLength = 20.0;
    final cornerPaint = Paint()
      ..color = color
      ..strokeWidth = borderWidth + 1.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // Draw L-shaped highlights at each corner
    for (var i = 0; i < corners.length; i++) {
      final current = corners[i];
      final next = corners[(i + 1) % corners.length];
      final prev = corners[(i - 1 + corners.length) % corners.length];

      // Calculate direction vectors to adjacent corners
      final toNext = next - current;
      final toPrev = prev - current;

      final nextLength = toNext.distance;
      final prevLength = toPrev.distance;

      if (nextLength > 0 && prevLength > 0) {
        final nextDir = toNext / nextLength;
        final prevDir = toPrev / prevLength;

        // Draw short lines along each edge from the corner
        final lineLength = cornerLength.clamp(0.0, nextLength / 3);
        final lineLengthPrev = cornerLength.clamp(0.0, prevLength / 3);

        canvas
          ..drawLine(current, current + (nextDir * lineLength), cornerPaint)
          ..drawLine(
            current,
            current + (prevDir * lineLengthPrev),
            cornerPaint,
          );
      }
    }
  }

  @override
  bool shouldRepaint(final QrBorderPainter oldDelegate) =>
      qrCodes != oldDelegate.qrCodes ||
      borderColor != oldDelegate.borderColor ||
      borderWidth != oldDelegate.borderWidth ||
      borderPadding != oldDelegate.borderPadding ||
      cornerRadius != oldDelegate.cornerRadius;
}
