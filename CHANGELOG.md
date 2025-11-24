# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

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

[0.2.0]: https://github.com/dhia-bechattaoui/multi_qr_tracker/releases/tag/v0.2.0
[0.1.1]: https://github.com/dhia-bechattaoui/multi_qr_tracker/releases/tag/v0.1.1
[0.1.0]: https://github.com/dhia-bechattaoui/multi_qr_tracker/releases/tag/v0.1.0
[0.0.1]: https://github.com/dhia-bechattaoui/multi_qr_tracker/releases/tag/v0.0.1
