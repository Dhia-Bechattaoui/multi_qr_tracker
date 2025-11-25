import 'package:flutter/foundation.dart';

/// Controls the [MultiQrTrackerView] camera and scanning behavior.
///
/// This controller provides methods to start, stop, and control the torch
/// (flashlight) of the camera. It follows the standard Flutter controller
/// pattern (similar to video player controllers and animation controllers).
///
/// Example:
/// ```dart
/// class _ScannerScreenState extends State<ScannerScreen> {
///   final _controller = MultiQrTrackerController();
///
///   @override
///   void dispose() {
///     _controller.dispose();
///     super.dispose();
///   }
///
///   void _onNavigateAway() {
///     _controller.stop(); // Stops camera when navigating away
///   }
///
///   void _onReturn() {
///     _controller.start(); // Resumes camera when returning
///   }
///
///   @override
///   Widget build(BuildContext context) {
///     return MultiQrTrackerView(
///       controller: _controller,
///       onQrCodeScanned: (code) => print(code),
///     );
///   }
/// }
/// ```
class MultiQrTrackerController extends ChangeNotifier {
  /// Creates a [MultiQrTrackerController].
  ///
  /// The camera starts in the scanning state by default.
  MultiQrTrackerController({bool initiallyScanning = true})
    : _isScanning = initiallyScanning;

  bool _isScanning;
  bool _torchEnabled = false;

  /// Whether the camera is currently scanning for QR codes.
  ///
  /// When `false`, the camera is paused and no QR code detection occurs.
  bool get isScanning => _isScanning;

  /// Whether the torch (flashlight) is currently enabled.
  bool get torchEnabled => _torchEnabled;

  /// Stops the camera and QR code scanning.
  ///
  /// Call this when:
  /// - Navigating away from the scanner screen
  /// - The scanner is in a background tab
  /// - A modal is shown over the scanner
  /// - You want to pause scanning temporarily
  ///
  /// This saves battery and processing power.
  void stop() {
    if (!_isScanning) return;
    _isScanning = false;
    notifyListeners();
  }

  /// Starts or resumes the camera and QR code scanning.
  ///
  /// Call this when:
  /// - Returning to the scanner screen
  /// - The scanner tab becomes active
  /// - A modal is dismissed
  /// - You want to resume scanning
  void start() {
    if (_isScanning) return;
    _isScanning = true;
    notifyListeners();
  }

  /// Toggles the torch (flashlight) on or off.
  ///
  /// Note: This only works when [TorchMode.manual] is set in
  /// [MultiQrTrackerView]. For [TorchMode.auto], the torch is
  /// controlled automatically by ambient light levels.
  void toggleTorch() {
    _torchEnabled = !_torchEnabled;
    notifyListeners();
  }

  /// Sets the torch (flashlight) state explicitly.
  ///
  /// [enabled] - `true` to turn on the torch, `false` to turn it off.
  ///
  /// Note: This only works when [TorchMode.manual] is set in
  /// [MultiQrTrackerView]. For [TorchMode.auto], the torch is
  /// controlled automatically by ambient light levels.
  void setTorch(bool enabled) {
    if (_torchEnabled == enabled) return;
    _torchEnabled = enabled;
    notifyListeners();
  }

  /// Resets the controller to its initial state.
  ///
  /// This stops scanning and turns off the torch.
  void reset() {
    _isScanning = true;
    _torchEnabled = false;
    notifyListeners();
  }
}
