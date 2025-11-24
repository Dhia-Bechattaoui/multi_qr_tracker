import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:multi_qr_tracker/src/models/qr_code_info.dart';
import 'package:multi_qr_tracker/src/widgets/scan_button.dart';

void main() {
  group('ScanButton', () {
    testWidgets('renders full button for large QR codes', (final tester) async {
      const largeQrCode = QrCodeInfo(
        value: 'test',
        boundingBox: Rect.fromLTWH(50, 50, 150, 150),
        corners: <Offset>[],
      );

      var pressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: SizedBox(
              width: 400,
              height: 400,
              child: Stack(
                children: <Widget>[
                  ScanButton(
                    qrCode: largeQrCode,
                    onPressed: () => pressed = true,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('SCAN ME'), findsOneWidget);
      expect(find.byIcon(Icons.qr_code_scanner), findsOneWidget);

      await tester.tap(find.text('SCAN ME'));
      await tester.pump();
      expect(pressed, true);
    });

    testWidgets('renders icon-only button for small QR codes', (
      final tester,
    ) async {
      const smallQrCode = QrCodeInfo(
        value: 'test',
        boundingBox: Rect.fromLTWH(50, 50, 80, 80),
        corners: <Offset>[],
      );

      var pressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: SizedBox(
              width: 400,
              height: 400,
              child: Stack(
                children: <Widget>[
                  ScanButton(
                    qrCode: smallQrCode,
                    onPressed: () => pressed = true,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('SCAN ME'), findsNothing);
      expect(find.byType(IconButton), findsOneWidget);
      expect(find.byIcon(Icons.qr_code_scanner), findsOneWidget);

      await tester.tap(find.byType(IconButton));
      await tester.pump();
      expect(pressed, true);
    });

    testWidgets('positioned correctly based on QR code center', (
      final tester,
    ) async {
      const qrCode = QrCodeInfo(
        value: 'test',
        boundingBox: Rect.fromLTWH(100, 100, 150, 150),
        corners: <Offset>[],
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: SizedBox(
              width: 400,
              height: 400,
              child: Stack(
                children: <Widget>[
                  ScanButton(qrCode: qrCode, onPressed: () {}),
                ],
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final positioned = tester.widget<Positioned>(find.byType(Positioned));
      // Center of boundingBox is (175, 175)
      // For large QR (150x150), button offset is center.dx - 60, center.dy - 24
      expect(positioned.left, 115.0); // 175 - 60
      expect(positioned.top, 151.0); // 175 - 24
    });

    testWidgets('uses custom colors', (final tester) async {
      const largeQrCode = QrCodeInfo(
        value: 'test',
        boundingBox: Rect.fromLTWH(50, 50, 150, 150),
        corners: <Offset>[],
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: SizedBox(
              width: 400,
              height: 400,
              child: Stack(
                children: <Widget>[
                  ScanButton(
                    qrCode: largeQrCode,
                    onPressed: () {},
                    fullButtonColor: Colors.red,
                    iconOnlyColor: Colors.yellow,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('SCAN ME'), findsOneWidget);
    });

    testWidgets('calls onPressed when tapped', (final tester) async {
      const qrCode = QrCodeInfo(
        value: 'test-value',
        boundingBox: Rect.fromLTWH(50, 50, 150, 150),
        corners: <Offset>[],
      );

      var tapCount = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: SizedBox(
              width: 400,
              height: 400,
              child: Stack(
                children: <Widget>[
                  ScanButton(qrCode: qrCode, onPressed: () => tapCount++),
                ],
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('SCAN ME'));
      await tester.pump();
      expect(tapCount, 1);

      await tester.tap(find.text('SCAN ME'));
      await tester.pump();
      expect(tapCount, 2);
    });
  });
}
