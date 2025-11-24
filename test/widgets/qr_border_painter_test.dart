import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:multi_qr_tracker/src/models/qr_code_info.dart';
import 'package:multi_qr_tracker/src/widgets/qr_border_painter.dart';

void main() {
  group('QrBorderPainter', () {
    test('creates instance with required parameters', () {
      const qrCode = QrCodeInfo(
        value: 'test',
        boundingBox: Rect.fromLTWH(10, 10, 100, 100),
        corners: <Offset>[],
      );

      final painter = QrBorderPainter(qrCodes: <QrCodeInfo>[qrCode]);

      expect(painter.qrCodes.length, 1);
      expect(painter.borderColor, Colors.green);
      expect(painter.borderWidth, 3.0);
      expect(painter.borderPadding, 8.0);
      expect(painter.cornerRadius, 12.0);
    });

    test('creates instance with custom styling', () {
      const qrCode = QrCodeInfo(
        value: 'test',
        boundingBox: Rect.fromLTWH(10, 10, 100, 100),
        corners: <Offset>[],
      );

      final painter = QrBorderPainter(
        qrCodes: <QrCodeInfo>[qrCode],
        borderColor: Colors.blue,
        borderWidth: 5,
        borderPadding: 12,
        cornerRadius: 16,
      );

      expect(painter.borderColor, Colors.blue);
      expect(painter.borderWidth, 5.0);
      expect(painter.borderPadding, 12.0);
      expect(painter.cornerRadius, 16.0);
    });

    test('shouldRepaint returns true when qrCodes change', () {
      const qrCode1 = QrCodeInfo(
        value: 'test1',
        boundingBox: Rect.fromLTWH(10, 10, 100, 100),
        corners: <Offset>[],
      );

      const qrCode2 = QrCodeInfo(
        value: 'test2',
        boundingBox: Rect.fromLTWH(20, 20, 100, 100),
        corners: <Offset>[],
      );

      final painter1 = QrBorderPainter(qrCodes: <QrCodeInfo>[qrCode1]);

      final painter2 = QrBorderPainter(qrCodes: <QrCodeInfo>[qrCode2]);

      expect(painter1.shouldRepaint(painter2), true);
    });

    test('shouldRepaint returns true when borderColor changes', () {
      const qrCode = QrCodeInfo(
        value: 'test',
        boundingBox: Rect.fromLTWH(10, 10, 100, 100),
        corners: <Offset>[],
      );

      final painter1 = QrBorderPainter(qrCodes: <QrCodeInfo>[qrCode]);

      final painter2 = QrBorderPainter(
        qrCodes: <QrCodeInfo>[qrCode],
        borderColor: Colors.blue,
      );

      expect(painter1.shouldRepaint(painter2), true);
    });

    test('shouldRepaint returns true when borderWidth changes', () {
      const qrCode = QrCodeInfo(
        value: 'test',
        boundingBox: Rect.fromLTWH(10, 10, 100, 100),
        corners: <Offset>[],
      );

      final painter1 = QrBorderPainter(qrCodes: <QrCodeInfo>[qrCode]);

      final painter2 = QrBorderPainter(
        qrCodes: <QrCodeInfo>[qrCode],
        borderWidth: 5,
      );

      expect(painter1.shouldRepaint(painter2), true);
    });

    test('shouldRepaint returns false when nothing changes', () {
      const qrCode = QrCodeInfo(
        value: 'test',
        boundingBox: Rect.fromLTWH(10, 10, 100, 100),
        corners: <Offset>[],
      );

      final qrCodes = <QrCodeInfo>[qrCode];

      final painter1 = QrBorderPainter(qrCodes: qrCodes);

      final painter2 = QrBorderPainter(qrCodes: qrCodes);

      expect(painter1.shouldRepaint(painter2), false);
    });

    testWidgets('paints without throwing errors', (final tester) async {
      const qrCode = QrCodeInfo(
        value: 'test',
        boundingBox: Rect.fromLTWH(50, 50, 100, 100),
        corners: <Offset>[
          Offset(50, 50),
          Offset(150, 50),
          Offset(150, 150),
          Offset(50, 150),
        ],
      );

      final painter = QrBorderPainter(qrCodes: <QrCodeInfo>[qrCode]);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomPaint(painter: painter, size: const Size(300, 300)),
          ),
        ),
      );

      expect(find.byType(CustomPaint), findsWidgets);
    });

    testWidgets('paints multiple QR codes', (final tester) async {
      const qrCodes = <QrCodeInfo>[
        QrCodeInfo(
          value: 'test1',
          boundingBox: Rect.fromLTWH(20, 20, 80, 80),
          corners: <Offset>[],
        ),
        QrCodeInfo(
          value: 'test2',
          boundingBox: Rect.fromLTWH(150, 150, 80, 80),
          corners: <Offset>[],
        ),
      ];

      final painter = QrBorderPainter(qrCodes: qrCodes);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomPaint(painter: painter, size: const Size(300, 300)),
          ),
        ),
      );

      expect(find.byType(CustomPaint), findsWidgets);
      expect(painter.qrCodes.length, 2);
    });
  });
}
