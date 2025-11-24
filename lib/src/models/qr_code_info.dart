import 'package:flutter/material.dart';

/// Information about a detected QR code including its position and dimensions.
///
/// This class holds data about a QR code detected in the camera view,
/// including its screen position, size, and decoded value.
@immutable
class QrCodeInfo {
  /// Creates a [QrCodeInfo] instance.
  const QrCodeInfo({
    required this.value,
    required this.boundingBox,
    required this.corners,
  });

  /// The decoded value/content of the QR code
  final String value;

  /// The bounding box rectangle containing the QR code
  final Rect boundingBox;

  /// The four corner points of the QR code
  final List<Offset> corners;

  /// The center point of the QR code
  Offset get center => boundingBox.center;

  /// The width of the QR code bounding box
  double get width => boundingBox.width;

  /// The height of the QR code bounding box
  double get height => boundingBox.height;

  /// Returns true if the QR code is large enough to display a full button
  /// (icon + text). Otherwise, only an icon should be shown.
  bool get isLargeEnoughForFullButton {
    // Consider "large enough" if the smaller dimension is at least 120 pixels
    const minSizeForFullButton = 120;
    return width >= minSizeForFullButton && height >= minSizeForFullButton;
  }

  @override
  bool operator ==(final Object other) =>
      identical(this, other) ||
      other is QrCodeInfo &&
          runtimeType == other.runtimeType &&
          value == other.value &&
          boundingBox == other.boundingBox;

  @override
  int get hashCode => value.hashCode ^ boundingBox.hashCode;

  @override
  String toString() =>
      'QrCodeInfo{value: $value, boundingBox: $boundingBox, corners: $corners}';
}
