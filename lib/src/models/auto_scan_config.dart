/// Configuration for automatic QR code scanning behavior.
///
/// Determines whether the scanner should automatically start scanning
/// after a specified delay without requiring a manual button press.
class AutoScanConfig {
  /// Creates an [AutoScanConfig] with the specified settings.
  ///
  /// [enabled] - Whether automatic scanning is enabled. Defaults to `true`.
  /// [scanDelay] - Duration to wait before starting automatic scan.
  /// Defaults to 2 seconds.
  const AutoScanConfig({
    this.enabled = true,
    this.scanDelay = const Duration(seconds: 2),
  });

  /// Whether automatic scanning is enabled.
  ///
  /// When `true`, scanning will start automatically after [scanDelay].
  /// When `false`, scanning only starts when the scan button is pressed.
  final bool enabled;

  /// The delay before automatic scanning starts.
  ///
  /// This duration is measured from when the camera preview is ready.
  /// Only applies when [enabled] is `true`.
  final Duration scanDelay;
}
