import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:multi_qr_tracker/src/models/qr_code_info.dart';

void main() {
  group('QrCodeInfo', () {
    test('creates instance with valid parameters', () {
      const qrCode = QrCodeInfo(
        value: 'https://example.com',
        boundingBox: Rect.fromLTWH(10, 20, 100, 100),
        corners: <Offset>[
          Offset(10, 20),
          Offset(110, 20),
          Offset(110, 120),
          Offset(10, 120),
        ],
      );

      expect(qrCode.value, 'https://example.com');
      expect(qrCode.boundingBox, const Rect.fromLTWH(10, 20, 100, 100));
      expect(qrCode.corners.length, 4);
    });

    test('calculates center correctly', () {
      const qrCode = QrCodeInfo(
        value: 'test',
        boundingBox: Rect.fromLTWH(0, 0, 100, 100),
        corners: <Offset>[],
      );

      expect(qrCode.center, const Offset(50, 50));
    });

    test('calculates width correctly', () {
      const qrCode = QrCodeInfo(
        value: 'test',
        boundingBox: Rect.fromLTWH(0, 0, 150, 100),
        corners: <Offset>[],
      );

      expect(qrCode.width, 150);
    });

    test('calculates height correctly', () {
      const qrCode = QrCodeInfo(
        value: 'test',
        boundingBox: Rect.fromLTWH(0, 0, 100, 200),
        corners: <Offset>[],
      );

      expect(qrCode.height, 200);
    });

    test('isLargeEnoughForFullButton returns true for large QR codes', () {
      const largeQrCode = QrCodeInfo(
        value: 'test',
        boundingBox: Rect.fromLTWH(0, 0, 150, 150),
        corners: <Offset>[],
      );

      expect(largeQrCode.isLargeEnoughForFullButton, true);
    });

    test('isLargeEnoughForFullButton returns false for small QR codes', () {
      const smallQrCode = QrCodeInfo(
        value: 'test',
        boundingBox: Rect.fromLTWH(0, 0, 80, 80),
        corners: <Offset>[],
      );

      expect(smallQrCode.isLargeEnoughForFullButton, false);
    });

    test(
      'isLargeEnoughForFullButton returns false when one dimension is small',
      () {
        const narrowQrCode = QrCodeInfo(
          value: 'test',
          boundingBox: Rect.fromLTWH(0, 0, 150, 80),
          corners: <Offset>[],
        );

        expect(narrowQrCode.isLargeEnoughForFullButton, false);
      },
    );

    test('equality works correctly', () {
      const qrCode1 = QrCodeInfo(
        value: 'test',
        boundingBox: Rect.fromLTWH(0, 0, 100, 100),
        corners: <Offset>[],
      );

      const qrCode2 = QrCodeInfo(
        value: 'test',
        boundingBox: Rect.fromLTWH(0, 0, 100, 100),
        corners: <Offset>[],
      );

      expect(qrCode1, qrCode2);
    });

    test('inequality works correctly for different values', () {
      const qrCode1 = QrCodeInfo(
        value: 'test1',
        boundingBox: Rect.fromLTWH(0, 0, 100, 100),
        corners: <Offset>[],
      );

      const qrCode2 = QrCodeInfo(
        value: 'test2',
        boundingBox: Rect.fromLTWH(0, 0, 100, 100),
        corners: <Offset>[],
      );

      expect(qrCode1 == qrCode2, false);
    });

    test('toString returns expected format', () {
      const qrCode = QrCodeInfo(
        value: 'test',
        boundingBox: Rect.fromLTWH(0, 0, 100, 100),
        corners: <Offset>[Offset.zero],
      );

      expect(qrCode.toString(), contains('QrCodeInfo'));
      expect(qrCode.toString(), contains('test'));
    });
  });
}
