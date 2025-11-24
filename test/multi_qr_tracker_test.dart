import 'package:flutter_test/flutter_test.dart';
import 'package:multi_qr_tracker/multi_qr_tracker.dart';

void main() {
  group('MultiQrTracker Library', () {
    test('exports MultiQrTrackerView', () {
      expect(MultiQrTrackerView, isNotNull);
    });

    test('exports QrTrackerCameraOrientation', () {
      expect(QrTrackerCameraOrientation.portrait, isNotNull);
      expect(QrTrackerCameraOrientation.landscapeLeft, isNotNull);
      expect(QrTrackerCameraOrientation.landscapeRight, isNotNull);
      expect(QrTrackerCameraOrientation.auto, isNotNull);
    });

    test('exports QrCodeInfo', () {
      expect(QrCodeInfo, isNotNull);
    });

    test('exports QrBorderPainter', () {
      expect(QrBorderPainter, isNotNull);
    });
  });
}
