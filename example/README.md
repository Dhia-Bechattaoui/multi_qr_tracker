# Multi QR Tracker Example

This example app demonstrates all features of the `multi_qr_tracker` package.

## Features Demonstrated

1. **Multi-QR Code Detection**: Detect and track multiple QR codes simultaneously
2. **Dynamic Borders**: Borders that adjust size based on QR code distance
3. **Adaptive Scan Buttons**: Full buttons with text for large QR codes, icon-only for small ones
4. **Camera Orientation Control**: Switch between auto, portrait, landscape left/right
5. **Customizable Styling**: Change border colors and button colors in real-time
6. **Scan History**: View list of scanned QR codes

## Running the Example

```bash
cd example
flutter pub get
flutter run
```

## Usage

1. Point your camera at QR codes
2. Green borders will appear around detected QR codes
3. Tap the "SCAN ME" button (or icon for small QR codes) to scan
4. View scanned codes in the history section
5. Try changing camera orientations and colors using the controls

## Platform Support

This example works on:
- Android
