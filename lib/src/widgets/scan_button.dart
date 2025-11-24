import 'package:flutter/material.dart';
import '../models/qr_code_info.dart';

/// Adaptive scan button that appears in the center of detected QR codes.
///
/// Shows a full button with icon and text for large QR codes,
/// and only an icon for smaller QR codes.
class ScanButton extends StatelessWidget {
  /// Creates a [ScanButton] with the given QR code information and callback.
  const ScanButton({
    required this.qrCode,
    required this.onPressed,
    this.fullButtonColor = Colors.blue,
    this.iconOnlyColor = Colors.white,
    super.key,
  });

  /// The QR code information to determine button size and position
  final QrCodeInfo qrCode;

  /// Callback when the scan button is pressed
  final VoidCallback onPressed;

  /// Background color for the full button (with text)
  final Color fullButtonColor;

  /// Color for the icon-only button
  final Color iconOnlyColor;

  @override
  Widget build(final BuildContext context) => Positioned(
    left: qrCode.center.dx - (qrCode.isLargeEnoughForFullButton ? 60 : 20),
    top: qrCode.center.dy - (qrCode.isLargeEnoughForFullButton ? 24 : 20),
    child: qrCode.isLargeEnoughForFullButton
        ? _buildFullButton()
        : _buildIconOnlyButton(),
  );

  Widget _buildFullButton() => ElevatedButton.icon(
    onPressed: onPressed,
    style: ElevatedButton.styleFrom(
      backgroundColor: fullButtonColor,
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      elevation: 4,
      shadowColor: Colors.black.withValues(alpha: 0.3),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
    ),
    icon: const Icon(Icons.qr_code_scanner, size: 20),
    label: const Text(
      'SCAN ME',
      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
    ),
  );

  Widget _buildIconOnlyButton() => Container(
    width: 40,
    height: 40,
    decoration: BoxDecoration(
      color: fullButtonColor,
      shape: BoxShape.circle,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.3),
          blurRadius: 6,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: IconButton(
      onPressed: onPressed,
      padding: EdgeInsets.zero,
      icon: Icon(Icons.qr_code_scanner, size: 24, color: iconOnlyColor),
    ),
  );
}
