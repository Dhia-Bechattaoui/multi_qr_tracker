# multi_qr_tracker

[![pub package](https://img.shields.io/pub/v/multi_qr_tracker.svg)](https://pub.dev/packages/multi_qr_tracker)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

A powerful Flutter package for detecting and tracking multiple QR codes simultaneously with adaptive UI overlays.

![Platform Support](https://img.shields.io/badge/platform-android-blue)
![Orientation Support](https://img.shields.io/badge/orientation-portrait-green)

## 🎯 Why This Package?

This package was created to provide reliable multi-QR code detection with a **native Android implementation** using CameraX and ML Kit Barcode Scanning.

**Current Status**: 
- ✅ Android platform support
- ✅ Portrait orientation
- 🚧 iOS and landscape orientations coming in future updates

<p align="center">
  <img src="https://raw.githubusercontent.com/Dhia-Bechattaoui/multi_qr_tracker/main/example.gif" width="300" alt="Multi QR Tracker Demo">
</p>

## ✨ Features

- 🔍 **Multi-QR Code Detection**: Detect and track multiple QR codes simultaneously in real-time
- 📏 **Dynamic Borders**: Borders automatically adjust size as you move closer or further from QR codes
- 🎯 **Adaptive Scan Buttons**: Full buttons with icon and text for large QR codes, icon-only for small ones
- 🎯 **Optional Scan Frame**: Show corner indicators to guide users where to position QR codes
- 🎨 **Fully Customizable**: Colors, border width, padding, corner radius, scan frame style, and more
- 🚀 **High Performance**: Smooth real-time tracking with CameraX and ML Kit Barcode Scanning
- 🤖 **Native Android Implementation**: Direct CameraX integration for optimal performance
- 📱 **Current Support**: Android (API 21+) in portrait orientation
- 🔮 **Coming Soon**: iOS support and landscape orientation

## 📱 Screenshots

```
[Camera view with multiple QR codes detected, each with green borders and "SCAN ME" buttons]
```

## 🚀 Getting Started

### Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  multi_qr_tracker: ^0.0.1
```

Then run:

```bash
flutter pub get
```

### Platform Setup

#### Android

Add camera permission to your `AndroidManifest.xml`:

```xml
<uses-permission android:name="android.permission.CAMERA" />
<uses-feature android:name="android.hardware.camera" />
```

Set minimum SDK version to 21 in `android/app/build.gradle`:

```gradle
minSdkVersion 21
```

## 💡 Usage

### Basic Example

```dart
import 'package:flutter/material.dart';
import 'package:multi_qr_tracker/multi_qr_tracker.dart';

class QRScannerPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('QR Scanner')),
      body: MultiQrTrackerView(
        onQrCodeScanned: (String value) {
          print('Scanned: $value');
          // Handle scanned QR code
        },
      ),
    );
  }
}
```

### Advanced Example

```dart
MultiQrTrackerView(
  onQrCodeScanned: (String value) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Scanned: $value')),
    );
  },
  
  // Customize QR code borders
  borderColor: Colors.blue,
  borderWidth: 4.0,
  borderPadding: 12.0,
  cornerRadius: 20.0,
  
  // Customize scan buttons
  scanButtonColor: Colors.green,
  iconColor: Colors.white,
  
  // Optional scan frame with corner indicators
  showScanFrame: true,
  scanFrameColor: Colors.white,
  scanFrameSize: 250.0,
  scanFrameCornerLength: 40.0,
  scanFrameCornerWidth: 4.0,
  
  // Error handling
  onCameraError: (String error) {
    print('Camera error: $error');
  },
  onPermissionDenied: () {
    print('Camera permission denied');
  },
)
```

## 🎨 Customization

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `onQrCodeScanned` | `Function(String)` | **required** | Callback when QR code is scanned |
| `borderColor` | `Color` | `Colors.green` | Color of detection borders |
| `borderWidth` | `double` | `3.0` | Width of border lines |
| `borderPadding` | `double` | `8.0` | Extra padding around QR codes |
| `cornerRadius` | `double` | `12.0` | Border corner radius |
| `scanButtonColor` | `Color` | `Colors.blue` | Scan button background color |
| `iconColor` | `Color` | `Colors.white` | Scan button icon color |
| `showScanFrame` | `bool` | `false` | Show scan frame with corner indicators |
| `scanFrameColor` | `Color` | `Colors.white` | Color of scan frame corners |
| `scanFrameSize` | `double` | `250.0` | Size of scan frame (width and height) |
| `scanFrameCornerLength` | `double` | `40.0` | Length of corner lines |
| `scanFrameCornerWidth` | `double` | `4.0` | Thickness of corner lines |
| `onCameraError` | `Function(String)?` | `null` | Camera error callback |
| `onPermissionDenied` | `VoidCallback?` | `null` | Permission denied callback |

## 📊 How It Works

1. **Native Camera**: Uses CameraX for camera preview and image capture
2. **Detection**: ML Kit Barcode Scanning detects QR codes in real-time
3. **Coordinate Mapping**: Transforms camera coordinates to screen coordinates with BoxFit.cover
4. **Border Rendering**: Draws dynamic borders using `CustomPainter`
5. **Adaptive UI**: Automatically switches between full button and icon-only based on QR code size
6. **Scan Frame**: Optional corner indicators to guide user positioning

## 🔧 API Reference

### MultiQrTrackerView

The main widget for QR code detection.

```dart
MultiQrTrackerView({
  Key? key,
  required Function(String value) onQrCodeScanned,
  Color borderColor = Colors.green,
  double borderWidth = 3.0,
  double borderPadding = 8.0,
  double cornerRadius = 12.0,
  Color scanButtonColor = Colors.blue,
  Color iconColor = Colors.white,
  bool showScanFrame = false,
  Color scanFrameColor = Colors.white,
  double scanFrameSize = 250.0,
  double scanFrameCornerLength = 40.0,
  double scanFrameCornerWidth = 4.0,
  Function(String error)? onCameraError,
  VoidCallback? onPermissionDenied,
})
```

### QrCodeInfo

Model class containing QR code information:

```dart
class QrCodeInfo {
  final String value;
  final Rect boundingBox;
  final List<Offset> corners;
  
  Offset get center;
  double get width;
  double get height;
  bool get isLargeEnoughForFullButton;
}
```

## 📖 Example App

Check out the [example](example/) directory for a complete demo app showing:

- Multiple QR code detection
- Real-time orientation switching
- Dynamic color customization
- Scan history tracking
- Error handling

Run the example:

```bash
cd example
flutter run
```

## 🧪 Testing

The package includes comprehensive tests with >90% coverage:

```bash
flutter test --coverage
```

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 💖 Support

If you find this package helpful, please:

- ⭐ Star the repository
- 🐛 Report bugs and request features via [GitHub Issues](https://github.com/Dhia-Bechattaoui/multi_qr_tracker/issues)
- 💰 [Sponsor the project](https://github.com/sponsors/Dhia-Bechattaoui)

## 👨‍💻 Author

**Dhia Bechattaoui**

- GitHub: [@Dhia-Bechattaoui](https://github.com/Dhia-Bechattaoui)
- Sponsor: [github.com/sponsors/Dhia-Bechattaoui](https://github.com/sponsors/Dhia-Bechattaoui)

## 🙏 Acknowledgments

- Built with [CameraX](https://developer.android.com/training/camerax) for native Android camera integration
- Uses [ML Kit Barcode Scanning](https://developers.google.com/ml-kit/vision/barcode-scanning) for QR code detection
- Inspired by the need for reliable multi-QR code scanning in Flutter apps

## 📈 Changelog

See [CHANGELOG.md](CHANGELOG.md) for a list of changes.

## 🔮 Roadmap

- [ ] iOS platform support
- [ ] Landscape orientation support
- [ ] Auto-rotate support
- [ ] Barcode format detection (EAN, Code128, etc.)
- [ ] Flashlight control
- [ ] Zoom controls
- [ ] Image picker scanning
- [ ] Custom overlay widgets

---

Made with ❤️ by [Dhia Bechattaoui](https://github.com/Dhia-Bechattaoui)
