import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'models/camera_resolution_preset.dart';
import 'models/qr_code_info.dart';
import 'models/qr_tracker_camera_orientation.dart';
import 'models/torch_mode.dart';
import 'platform/method_channel_multi_qr_tracker.dart';
import 'widgets/qr_border_painter.dart';
import 'widgets/scan_button.dart';
import 'widgets/torch_button.dart';

/// A widget that displays a camera view and detects multiple QR codes
/// simultaneously.
///
/// **Currently supports:**
/// - Android platform only
/// - Portrait orientation only
///
/// **Future updates will include:**
/// - iOS support
/// - Landscape orientation support
/// - Additional platform support
///
/// Features:
/// - Real-time multi-QR code detection and tracking
/// - Dynamic borders that adjust to QR code distance
/// - Adaptive scan buttons (full button or icon-only based on size)
///
/// Example:
/// ```dart
/// MultiQrTrackerView(
///   onQrCodeScanned: (String value) {
///     print('Scanned: $value');
///   },
///   borderColor: Colors.green,
/// )
/// ```
class MultiQrTrackerView extends StatefulWidget {
  /// Creates a [MultiQrTrackerView] widget.
  const MultiQrTrackerView({
    required this.onQrCodeScanned,
    this.cameraOrientation = QrTrackerCameraOrientation.portrait,
    this.cameraResolutionPreset,
    this.torchMode = TorchMode.off,
    this.showScanFrame = false,
    this.scanFrameColor = Colors.white,
    this.scanFrameCornerLength = 40.0,
    this.scanFrameCornerWidth = 4.0,
    this.scanFrameSize = 250.0,
    this.borderColor = Colors.green,
    this.borderWidth = 3.0,
    this.borderPadding = 8.0,
    this.cornerRadius = 12.0,
    this.scanButtonColor = Colors.blue,
    this.iconColor = Colors.white,
    this.torchButtonBackgroundColor = Colors.black54,
    this.torchButtonIconColor = Colors.white,
    this.onCameraError,
    this.onPermissionDenied,
    super.key,
  });

  /// Callback invoked when a QR code is successfully scanned.
  ///
  /// The [String] parameter contains the decoded QR code value.
  final void Function(String value) onQrCodeScanned;

  /// Controls the camera orientation behavior.
  ///
  /// **Currently only portrait orientation is supported.**
  /// Other orientations are reserved for future updates.
  ///
  /// Options:
  /// - [QrTrackerCameraOrientation.portrait]: Lock to portrait
  ///   (default and only supported)
  /// - [QrTrackerCameraOrientation.landscapeLeft]: Not yet implemented
  /// - [QrTrackerCameraOrientation.landscapeRight]: Not yet implemented
  /// - [QrTrackerCameraOrientation.auto]: Not yet implemented
  final QrTrackerCameraOrientation cameraOrientation;

  /// Camera resolution preset for image analysis.
  ///
  /// If null (default), automatically selects resolution based on device
  /// physical screen size:
  /// - Physical width/height >= 2160px → ultraHigh (3840x2160)
  /// - Physical width/height >= 1080px → veryHigh (1920x1080)
  /// - Physical width/height >= 720px → high (1280x720)
  /// - Physical width/height >= 480px → medium (640x480)
  /// - Physical width/height < 480px → low (320x240)
  ///
  /// Example:
  /// ```dart
  /// // Auto-detect (recommended)
  /// MultiQrTrackerView(
  ///   onQrCodeScanned: (value) => print(value),
  /// )
  ///
  /// // Custom resolution
  /// MultiQrTrackerView(
  ///   onQrCodeScanned: (value) => print(value),
  ///   cameraResolutionPreset: CameraResolutionPreset.high,
  /// )
  /// ```
  ///
  /// Note: This parameter is currently for future use. The camera uses
  /// default resolution.
  final CameraResolutionPreset? cameraResolutionPreset;

  /// Controls the torch (flashlight) behavior.
  ///
  /// Options:
  /// - [TorchMode.off]: Torch is always off (default)
  /// - [TorchMode.auto]: Torch automatically turns on in low light
  /// - [TorchMode.manual]: Shows a torch button for manual control
  final TorchMode torchMode;

  /// Whether to show a scan frame with corner indicators. Defaults to false.
  final bool showScanFrame;

  /// Color of the scan frame corners. Defaults to white.
  final Color scanFrameColor;

  /// Length of each corner line in the scan frame. Defaults to 40.0.
  final double scanFrameCornerLength;

  /// Width/thickness of the corner lines. Defaults to 4.0.
  final double scanFrameCornerWidth;

  /// Size of the scan frame (width and height). Defaults to 250.0.
  final double scanFrameSize;

  /// Color of the QR code detection borders. Defaults to green.
  final Color borderColor;

  /// Width of the border lines in pixels. Defaults to 3.0.
  final double borderWidth;

  /// Extra padding around QR codes to make borders slightly larger.
  /// Defaults to 8.0.
  final double borderPadding;

  /// Radius for rounded corners of the borders. Defaults to 12.0.
  final double cornerRadius;

  /// Background color for scan buttons. Defaults to blue.
  final Color scanButtonColor;

  /// Color for icons in the scan buttons. Defaults to white.
  final Color iconColor;

  /// Background color for the torch button. Defaults to black54.
  final Color torchButtonBackgroundColor;

  /// Icon color for the torch button. Defaults to white.
  final Color torchButtonIconColor;

  /// Callback invoked when a camera error occurs.
  final void Function(String error)? onCameraError;

  /// Callback invoked when camera permission is denied.
  final VoidCallback? onPermissionDenied;

  @override
  State<MultiQrTrackerView> createState() => _MultiQrTrackerViewState();
}

class _MultiQrTrackerViewState extends State<MultiQrTrackerView> {
  final MethodChannelMultiQrTracker _platform = MethodChannelMultiQrTracker();
  List<QrCodeInfo> _detectedQrCodes = <QrCodeInfo>[];
  final Set<String> _scannedValues = <String>{};
  int? _textureId;
  double _cameraWidth = 1920;
  double _cameraHeight = 1080;
  bool _isInitialized = false;
  bool _isTorchEnabled = false;
  Timer? _lightSensorTimer;

  @override
  void initState() {
    super.initState();
    unawaited(_initializeCamera());
  }

  Future<void> _initializeTorchMode() async {
    if (widget.torchMode == TorchMode.auto) {
      // Check light level periodically
      _lightSensorTimer = Timer.periodic(const Duration(seconds: 2), (_) async {
        if (!mounted || !_isInitialized) return;
        try {
          final lightLevel = await _platform.getLightLevel();
          // Turn on torch if light level is below 10 lux (dark environment)
          final shouldEnable = lightLevel < 10;
          if (shouldEnable != _isTorchEnabled) {
            await _toggleTorch(shouldEnable);
          }
        } catch (e) {
          // Ignore sensor errors
        }
      });
    }
  }

  Future<void> _toggleTorch(bool enabled) async {
    try {
      await _platform.enableTorch(enabled);
      if (mounted) {
        setState(() {
          _isTorchEnabled = enabled;
        });
      }
    } catch (e) {
      // Ignore torch errors (device may not have flash)
    }
  }

  Future<void> _initializeCamera() async {
    _applyOrientation();

    _platform.setDetectionCallback((final data) {
      final barcodes = data['barcodes'] as List<dynamic>?;
      final imageWidth = data['imageWidth'] as int?;
      final imageHeight = data['imageHeight'] as int?;

      if (barcodes != null && imageWidth != null && imageHeight != null) {
        // Update camera dimensions from image analysis size
        _cameraWidth = imageWidth.toDouble();
        _cameraHeight = imageHeight.toDouble();

        final convertedBarcodes = barcodes
            .map((final barcode) => Map<String, dynamic>.from(barcode as Map))
            .toList();
        _onBarcodesDetected(convertedBarcodes);
      }
    });

    try {
      final result = await _platform.initialize(_getOrientationString());
      setState(() {
        _textureId = result['textureId'] as int?;
        _cameraWidth = (result['width'] as int?)?.toDouble() ?? 1920;
        _cameraHeight = (result['height'] as int?)?.toDouble() ?? 1080;
        _isInitialized = true;
      });
      await _initializeTorchMode();
    } on Exception catch (e) {
      widget.onCameraError?.call(e.toString());
    }
  }

  String _getOrientationString() {
    switch (widget.cameraOrientation) {
      case QrTrackerCameraOrientation.portrait:
        return 'portrait';
      case QrTrackerCameraOrientation.landscapeLeft:
        return 'landscapeLeft';
      case QrTrackerCameraOrientation.landscapeRight:
        return 'landscapeRight';
      case QrTrackerCameraOrientation.auto:
        return 'auto';
    }
  }

  void _applyOrientation() {
    switch (widget.cameraOrientation) {
      case QrTrackerCameraOrientation.portrait:
        unawaited(
          SystemChrome.setPreferredOrientations(<DeviceOrientation>[
            DeviceOrientation.portraitUp,
          ]),
        );
      case QrTrackerCameraOrientation.landscapeLeft:
        unawaited(
          SystemChrome.setPreferredOrientations(<DeviceOrientation>[
            DeviceOrientation.landscapeLeft,
          ]),
        );
      case QrTrackerCameraOrientation.landscapeRight:
        unawaited(
          SystemChrome.setPreferredOrientations(<DeviceOrientation>[
            DeviceOrientation.landscapeRight,
          ]),
        );
      case QrTrackerCameraOrientation.auto:
        unawaited(
          SystemChrome.setPreferredOrientations(<DeviceOrientation>[
            DeviceOrientation.portraitUp,
            DeviceOrientation.portraitDown,
            DeviceOrientation.landscapeLeft,
            DeviceOrientation.landscapeRight,
          ]),
        );
    }
  }

  @override
  void didUpdateWidget(final MultiQrTrackerView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.cameraOrientation != widget.cameraOrientation) {
      _applyOrientation();
      unawaited(_reinitializeCamera());
    }
  }

  Future<void> _reinitializeCamera() async {
    await _platform.dispose();
    setState(() {
      _isInitialized = false;
      _textureId = null;
    });
    await _initializeCamera();
  }

  @override
  void dispose() {
    _lightSensorTimer?.cancel();
    unawaited(_platform.dispose());
    // Reset orientation to auto when disposing
    unawaited(
      SystemChrome.setPreferredOrientations(<DeviceOrientation>[
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]),
    );
    super.dispose();
  }

  void _onBarcodesDetected(final List<Map<String, dynamic>> barcodes) {
    final qrCodes = <QrCodeInfo>[];

    // Get screen size once for filtering
    final renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null) {
      return;
    }

    final screenSize = renderBox.size;
    final screenRect = Rect.fromLTWH(0, 0, screenSize.width, screenSize.height);

    for (final barcode in barcodes) {
      final barcodeMap = Map<String, dynamic>.from(barcode);
      final value = barcodeMap['value'] as String?;
      final corners = barcodeMap['corners'] as List<dynamic>?;

      if (value == null || corners == null || corners.length != 4) {
        continue;
      }

      // Convert corners to Offset list
      final cornerPoints = corners.map((final corner) {
        final cornerMap = Map<String, dynamic>.from(corner as Map);
        final x = (cornerMap['x'] as num).toDouble();
        final y = (cornerMap['y'] as num).toDouble();
        return _normalizePoint(Offset(x, y));
      }).toList();

      // Calculate bounding box from corners
      final minX = cornerPoints
          .map((final c) => c.dx)
          .reduce((final a, final b) => a < b ? a : b);
      final maxX = cornerPoints
          .map((final c) => c.dx)
          .reduce((final a, final b) => a > b ? a : b);
      final minY = cornerPoints
          .map((final c) => c.dy)
          .reduce((final a, final b) => a < b ? a : b);
      final maxY = cornerPoints
          .map((final c) => c.dy)
          .reduce((final a, final b) => a > b ? a : b);

      final boundingBox = Rect.fromLTRB(minX, minY, maxX, maxY);

      // Filter out QR codes that are completely or mostly outside screen bounds
      // Require at least some meaningful overlap (not just a tiny edge)
      final intersection = boundingBox.intersect(screenRect);
      final overlapArea = intersection.width * intersection.height;
      final qrArea = boundingBox.width * boundingBox.height;

      // Only include QR code if at least 10% of it is visible on screen
      if (qrArea > 0 && overlapArea / qrArea > 0.1) {
        qrCodes.add(
          QrCodeInfo(
            value: value,
            boundingBox: boundingBox,
            corners: cornerPoints,
          ),
        );
      }
    }

    if (mounted) {
      setState(() {
        _detectedQrCodes = qrCodes;
      });
    }
  }

  Offset _normalizePoint(final Offset point) {
    // Get the actual widget size (screen size in our case)
    final renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null) {
      return point;
    }

    final screenSize = renderBox.size;

    // Camera outputs square image (3072x3072) with 90° rotation metadata
    // ML Kit already handles rotation - coordinates come pre-rotated for
    // display orientation
    // Just need to scale and crop to screen

    // BoxFit.cover: Scale to fill the screen completely, cropping overflow
    final scaleX = screenSize.width / _cameraWidth;
    final scaleY = screenSize.height / _cameraHeight;

    // Use the larger scale to fill the screen (BoxFit.cover behavior)
    final scale = scaleX > scaleY ? scaleX : scaleY;

    // Calculate the scaled preview size
    final scaledPreviewWidth = _cameraWidth * scale;
    final scaledPreviewHeight = _cameraHeight * scale;

    // Calculate crop offsets (preview is centered when cropped)
    final cropOffsetX = (scaledPreviewWidth - screenSize.width) / 2;
    final cropOffsetY = (scaledPreviewHeight - screenSize.height) / 2;

    // Transform point: scale then subtract crop offset
    final transformed = Offset(
      (point.dx * scale) - cropOffsetX,
      (point.dy * scale) - cropOffsetY,
    );

    return transformed;
  }

  void _handleScanPressed(final String value) {
    if (_scannedValues.contains(value)) {
      return; // Already scanned, prevent duplicate callbacks
    }

    _scannedValues.add(value);
    widget.onQrCodeScanned(value);

    // Remove from scanned set after a delay to allow rescanning
    unawaited(
      Future<void>.delayed(const Duration(seconds: 3), () {
        if (mounted) {
          _scannedValues.remove(value);
        }
      }),
    );
  }

  @override
  Widget build(final BuildContext context) => Stack(
    children: <Widget>[
      // Camera preview
      if (_isInitialized && _textureId != null)
        SizedBox.expand(
          child: FittedBox(
            fit: BoxFit.cover,
            child: SizedBox(
              width: _cameraWidth,
              height: _cameraHeight,
              child: Texture(textureId: _textureId!),
            ),
          ),
        )
      else
        const Center(child: CircularProgressIndicator()),

      // Scan frame with corner indicators
      if (widget.showScanFrame)
        Center(
          child: Container(
            width: widget.scanFrameSize,
            height: widget.scanFrameSize,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.transparent),
            ),
            child: CustomPaint(
              painter: _ScanFramePainter(
                color: widget.scanFrameColor,
                cornerLength: widget.scanFrameCornerLength,
                cornerWidth: widget.scanFrameCornerWidth,
              ),
            ),
          ),
        ),

      // QR code borders overlay
      Positioned.fill(
        child: CustomPaint(
          painter: QrBorderPainter(
            qrCodes: _detectedQrCodes,
            borderColor: widget.borderColor,
            borderWidth: widget.borderWidth,
            borderPadding: widget.borderPadding,
            cornerRadius: widget.cornerRadius,
          ),
        ),
      ),

      // Scan buttons overlay
      ..._detectedQrCodes.map(
        (final qrCode) => ScanButton(
          qrCode: qrCode,
          onPressed: () => _handleScanPressed(qrCode.value),
          fullButtonColor: widget.scanButtonColor,
          iconOnlyColor: widget.iconColor,
        ),
      ),

      // Torch button (manual mode only)
      if (widget.torchMode == TorchMode.manual && _isInitialized)
        Positioned(
          right: 16,
          bottom: 16,
          child: TorchButton(
            isEnabled: _isTorchEnabled,
            onPressed: () => _toggleTorch(!_isTorchEnabled),
            backgroundColor: widget.torchButtonBackgroundColor,
            iconColor: widget.torchButtonIconColor,
          ),
        ),
    ],
  );
}

/// Custom painter for drawing the scan frame with corner indicators.
class _ScanFramePainter extends CustomPainter {
  _ScanFramePainter({
    required this.color,
    required this.cornerLength,
    required this.cornerWidth,
  });

  final Color color;
  final double cornerLength;
  final double cornerWidth;

  @override
  void paint(final Canvas canvas, final Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = cornerWidth
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    // Top-left corner
    canvas
      ..drawLine(Offset.zero, Offset(cornerLength, 0), paint)
      ..drawLine(Offset.zero, Offset(0, cornerLength), paint)
      // Top-right corner
      ..drawLine(
        Offset(size.width, 0),
        Offset(size.width - cornerLength, 0),
        paint,
      )
      ..drawLine(Offset(size.width, 0), Offset(size.width, cornerLength), paint)
      // Bottom-left corner
      ..drawLine(
        Offset(0, size.height),
        Offset(cornerLength, size.height),
        paint,
      )
      ..drawLine(
        Offset(0, size.height),
        Offset(0, size.height - cornerLength),
        paint,
      )
      // Bottom-right corner
      ..drawLine(
        Offset(size.width, size.height),
        Offset(size.width - cornerLength, size.height),
        paint,
      )
      ..drawLine(
        Offset(size.width, size.height),
        Offset(size.width, size.height - cornerLength),
        paint,
      );
  }

  @override
  bool shouldRepaint(final _ScanFramePainter oldDelegate) =>
      oldDelegate.color != color ||
      oldDelegate.cornerLength != cornerLength ||
      oldDelegate.cornerWidth != cornerWidth;
}
