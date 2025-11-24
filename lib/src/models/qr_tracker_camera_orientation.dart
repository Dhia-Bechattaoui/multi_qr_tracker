/// Enum representing the camera orientation options for QR code scanning.
///
/// This allows you to control whether the camera should follow device rotation
/// or stay locked in a specific orientation.
enum QrTrackerCameraOrientation {
  /// Camera stays in portrait mode regardless of device rotation
  portrait,

  /// Camera stays in landscape left mode regardless of device rotation
  landscapeLeft,

  /// Camera stays in landscape right mode regardless of device rotation
  landscapeRight,

  /// Camera orientation follows device rotation automatically
  auto,
}
