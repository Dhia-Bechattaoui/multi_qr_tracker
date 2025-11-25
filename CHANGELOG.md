# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.4.0] - 2025-11-25

### Added
- **Camera Lifecycle Control**: New `MultiQrTrackerController` for managing camera state
  - `start()` method to resume camera and QR code detection
  - `stop()` method to pause camera and conserve battery
  - `toggleTorch()` and `setTorch()` for programmatic torch control
  - Optional `controller` parameter in `MultiQrTrackerView` (backward compatible)
  - Automatic controller creation when not provided
- **Native Android Implementation**: Efficient camera pause/resume
  - `startCamera()` and `stopCamera()` platform methods
  - Unbinds/rebinds camera use cases without full reinitialization
  - State tracking with `isCameraRunning` flag in Kotlin
  - Keeps Preview use case in memory for fast resume
- **App Lifecycle Integration**: Automatic camera management
  - Camera pauses when app goes to background (inactive, paused, hidden, detached)
  - Camera resumes when app returns to foreground
  - Prevents camera resource waste during app switching
- **Enhanced Example App**: Settings screen to test camera lifecycle
  - Demonstrates proper stop/start sequence during navigation
  - Shows camera state management best practices

### Changed
- Improved camera resource management with proper lifecycle handling
- Better performance: no QR processing when scanner in background or hidden
- Enhanced documentation with controller usage examples and benefits
- Black screen display when camera is stopped for clear visual feedback

### Fixed
- Camera continuing to run when navigating away from scanner screen
- Battery drain from continuous camera operation in background
- `PlatformException` (NO_FLASH) when torch enabled during navigation
- Torch control errors when camera is closed - now gracefully handled
- Resource leaks from camera running during app lifecycle transitions

### Technical Details
- **Platform Interface**: Added `startCamera()` and `stopCamera()` to `MultiQrTrackerPlatform`
- **Error Handling**: Silently catches `NO_FLASH` and `CAMERA_CLOSED` errors
- **State Management**: Controller follows Flutter's `ChangeNotifier` pattern
- **Native**: CameraX bind/unbind for efficient pause/resume
- **Lifecycle**: Torch automatically disabled before camera stop to prevent errors

## [0.3.0] - 2025-11-24

### Added
- Automatic scanning feature that triggers after a configurable delay
- `AutoScanConfig` class with `enabled` flag and `scanDelay` duration
- Default auto-scan enabled after 2 seconds (can be customized or disabled)
- Per-QR code timer management for accurate auto-scan triggering
- Automatic timer cleanup when QR codes leave detection area

### Changed
- Scanning behavior: now auto-scans by default (can be disabled with `autoScanConfig`)
- Improved user experience by eliminating need to manually press scan button for most use cases

## [0.2.0] - 2025-11-24

### Added
- Torch button position control with `torchButtonPosition` parameter
- Four position options: topLeft, topRight, bottomLeft, bottomRight (default)
- `TorchButtonPosition` enum for type-safe position selection

## [0.1.1] - 2025-11-24

### Added
- Smart border coloring: `borderColor` parameter now nullable for auto-color mode
- When `borderColor` is null, QR codes with same value get same color
- Added visual examples in README showing both color modes

### Fixed
- QR code border colors now properly respect the `borderColor` parameter
- Fixed random color generation that was overriding user-specified border colors

## [0.1.0] - 2025-11-24

### Added
- Automatic runtime camera permission handling on Android
- Camera permissions are now requested automatically by the plugin when needed
- No manual AndroidManifest.xml permission setup required
- Torch (flashlight) control with three modes:
  - `TorchMode.off`: Torch always off
  - `TorchMode.auto`: Automatically turns on in low light (< 10 lux)
  - `TorchMode.manual`: User-controlled torch button in bottom right corner
- Light sensor integration for automatic torch control
- Customizable torch button colors

### Changed
- Updated README to reflect automatic permission handling
- Improved plugin lifecycle management with proper permission listener cleanup
- Added torch control parameters to `MultiQrTrackerView`

## [0.0.1] - 2025-11-24

### Added
- Initial release of multi_qr_tracker package
- Native Android implementation using CameraX and ML Kit Barcode Scanning
- Multi-QR code detection and tracking with real-time camera preview
- Dynamic border rendering that adjusts based on distance (QR code size)
- Adaptive scan button overlay (full button with icon and text for large QR codes, icon-only for small ones)
- Optional scan frame with customizable corner indicators
- Portrait orientation support for Android (API 21+)
- Accurate coordinate transformation with BoxFit.cover scaling
- Automatic camera resolution selection based on device screen size
- Smooth tracking of QR codes as they move in the camera view
- Comprehensive callback system for scan events and error handling
- Full API documentation with examples
- Customizable colors, borders, padding, and scan frame appearance

### Technical Details
- Camera outputs square resolution (3072x3072) for optimal detection
- ML Kit provides pre-rotated coordinates for display orientation
- Uses CameraX ImageAnalysis for continuous barcode scanning
- Implements proper surface texture handling for camera preview
- Supports multiple QR codes side-by-side detection

### Current Limitations
- Android platform only (iOS support planned)
- Portrait orientation only (landscape support planned)
- No auto-rotate support yet (planned for future release)

### Known Issues
- None

[0.4.0]: https://github.com/dhia-bechattaoui/multi_qr_tracker/releases/tag/v0.4.0
[0.3.0]: https://github.com/dhia-bechattaoui/multi_qr_tracker/releases/tag/v0.3.0
[0.2.0]: https://github.com/dhia-bechattaoui/multi_qr_tracker/releases/tag/v0.2.0
[0.1.1]: https://github.com/dhia-bechattaoui/multi_qr_tracker/releases/tag/v0.1.1
[0.1.0]: https://github.com/dhia-bechattaoui/multi_qr_tracker/releases/tag/v0.1.0
[0.0.1]: https://github.com/dhia-bechattaoui/multi_qr_tracker/releases/tag/v0.0.1
