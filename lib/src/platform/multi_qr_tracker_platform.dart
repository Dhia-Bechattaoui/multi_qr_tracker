/// The interface that platform-specific implementations must extend.
abstract class MultiQrTrackerPlatform {
  /// Initializes the camera with the given orientation mode.
  Future<Map<String, dynamic>> initialize(final String orientation);

  /// Disposes the camera resources.
  Future<void> dispose();

  /// Sets the callback for barcode detection.
  void setDetectionCallback(final void Function(Map<String, dynamic>) callback);

  /// Enables or disables the torch (flashlight).
  Future<bool> enableTorch(final bool enabled);

  /// Gets the current ambient light level from the device sensor.
  /// Returns the light level in lux (0 = dark, higher = brighter).
  Future<double> getLightLevel();
}
