import 'package:flutter_test/flutter_test.dart';
import 'package:multi_qr_tracker/src/models/qr_tracker_camera_orientation.dart';

void main() {
  group('QrTrackerCameraOrientation', () {
    test('has all expected values', () {
      expect(QrTrackerCameraOrientation.values.length, 4);
      expect(
        QrTrackerCameraOrientation.values,
        contains(QrTrackerCameraOrientation.portrait),
      );
      expect(
        QrTrackerCameraOrientation.values,
        contains(QrTrackerCameraOrientation.landscapeLeft),
      );
      expect(
        QrTrackerCameraOrientation.values,
        contains(QrTrackerCameraOrientation.landscapeRight),
      );
      expect(
        QrTrackerCameraOrientation.values,
        contains(QrTrackerCameraOrientation.auto),
      );
    });

    test('portrait value exists', () {
      expect(QrTrackerCameraOrientation.portrait, isNotNull);
    });

    test('landscapeLeft value exists', () {
      expect(QrTrackerCameraOrientation.landscapeLeft, isNotNull);
    });

    test('landscapeRight value exists', () {
      expect(QrTrackerCameraOrientation.landscapeRight, isNotNull);
    });

    test('auto value exists', () {
      expect(QrTrackerCameraOrientation.auto, isNotNull);
    });

    test('enum values are unique', () {
      final uniqueValues = QrTrackerCameraOrientation.values.toSet();
      expect(uniqueValues.length, QrTrackerCameraOrientation.values.length);
    });

    test('can be used in switch statements', () {
      String getOrientationName(final QrTrackerCameraOrientation orientation) {
        switch (orientation) {
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

      expect(
        getOrientationName(QrTrackerCameraOrientation.portrait),
        'portrait',
      );
      expect(
        getOrientationName(QrTrackerCameraOrientation.landscapeLeft),
        'landscapeLeft',
      );
      expect(
        getOrientationName(QrTrackerCameraOrientation.landscapeRight),
        'landscapeRight',
      );
      expect(getOrientationName(QrTrackerCameraOrientation.auto), 'auto');
    });
  });
}
