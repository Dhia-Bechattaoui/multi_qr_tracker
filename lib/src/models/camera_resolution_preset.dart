/// Camera resolution presets for image analysis.
enum CameraResolutionPreset {
  /// 240p resolution
  low,

  /// 480p resolution
  medium,

  /// 720p resolution
  high,

  /// 1080p resolution
  veryHigh,

  /// 2160p resolution
  ultraHigh,
}

/// Extension to get resolution dimensions
extension CameraResolutionPresetExtension on CameraResolutionPreset {
  /// Returns the width and height for this resolution preset
  (int width, int height) get dimensions {
    switch (this) {
      case CameraResolutionPreset.low:
        return (320, 240);
      case CameraResolutionPreset.medium:
        return (640, 480);
      case CameraResolutionPreset.high:
        return (1280, 720);
      case CameraResolutionPreset.veryHigh:
        return (1920, 1080);
      case CameraResolutionPreset.ultraHigh:
        return (3840, 2160);
    }
  }
}
