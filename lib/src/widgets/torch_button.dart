import 'package:flutter/material.dart';

/// A button widget for toggling the torch (flashlight) on/off.
class TorchButton extends StatelessWidget {
  /// Creates a [TorchButton] widget.
  const TorchButton({
    required this.isEnabled,
    required this.onPressed,
    this.backgroundColor = Colors.black54,
    this.iconColor = Colors.white,
    super.key,
  });

  /// Whether the torch is currently enabled.
  final bool isEnabled;

  /// Callback invoked when the button is pressed.
  final VoidCallback onPressed;

  /// Background color of the button.
  final Color backgroundColor;

  /// Color of the icon.
  final Color iconColor;

  @override
  Widget build(final BuildContext context) => Container(
    width: 56,
    height: 56,
    decoration: BoxDecoration(
      color: backgroundColor,
      shape: BoxShape.circle,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: .3),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        customBorder: const CircleBorder(),
        child: Icon(
          isEnabled ? Icons.flash_on : Icons.flash_off,
          color: isEnabled ? Colors.yellow : iconColor,
          size: 28,
        ),
      ),
    ),
  );
}
