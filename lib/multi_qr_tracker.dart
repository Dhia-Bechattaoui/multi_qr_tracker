/// A Flutter package for detecting and tracking multiple QR codes
/// simultaneously.
///
/// Currently supports:
/// - Android platform (API 21+)
/// - Portrait orientation only
///
/// This library provides:
/// - Real-time multi-QR code detection with ML Kit
/// - Native CameraX integration for optimal performance
/// - Dynamic border rendering that adapts to QR code distance
/// - Adaptive scan button overlays (full button or icon-only based on size)
/// - Optional scan frame with corner indicators
///
/// Future updates will include iOS support and landscape orientation.
library;

export 'src/models/auto_scan_config.dart';
export 'src/models/qr_code_info.dart';
export 'src/models/qr_tracker_camera_orientation.dart';
export 'src/models/torch_button_position.dart';
export 'src/models/torch_mode.dart';
export 'src/multi_qr_tracker_controller.dart';
export 'src/multi_qr_tracker_view.dart';
export 'src/widgets/qr_border_painter.dart';
export 'src/widgets/torch_button.dart';
