import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:multi_qr_tracker/src/widgets/torch_button.dart';

void main() {
  group('TorchButton', () {
    testWidgets('renders correctly when disabled', (final tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: TorchButton(isEnabled: false, onPressed: () {})),
        ),
      );

      expect(find.byType(TorchButton), findsOneWidget);
      expect(find.byIcon(Icons.flash_off), findsOneWidget);
    });

    testWidgets('renders correctly when enabled', (final tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: TorchButton(isEnabled: true, onPressed: () {})),
        ),
      );

      expect(find.byType(TorchButton), findsOneWidget);
      expect(find.byIcon(Icons.flash_on), findsOneWidget);
    });

    testWidgets('calls onPressed when tapped', (final tester) async {
      var pressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TorchButton(
              isEnabled: false,
              onPressed: () => pressed = true,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(TorchButton));
      await tester.pumpAndSettle();

      expect(pressed, isTrue);
    });

    testWidgets('uses custom colors', (final tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TorchButton(
              isEnabled: false,
              onPressed: () {},
              backgroundColor: Colors.red,
              iconColor: Colors.blue,
            ),
          ),
        ),
      );

      final container = tester.widget<Container>(
        find.descendant(
          of: find.byType(TorchButton),
          matching: find.byType(Container),
        ),
      );

      final decoration = container.decoration! as BoxDecoration;
      expect(decoration.color, Colors.red);
    });
  });
}
