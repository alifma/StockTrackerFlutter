import 'package:bloc_flutter/helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('roundToTwoDecimalPlaces', () {
    test('should round to two decimal places correctly', () {
      expect(roundToTwoDecimalPlaces('123.456'), 123.46);
      expect(roundToTwoDecimalPlaces('123.4'), 123.40);
      expect(roundToTwoDecimalPlaces('123'), 123.00);
      expect(roundToTwoDecimalPlaces('0.999'), 1.00);
    });
  });

  group('parseAndFormatAbsolute', () {
    test('should parse and format absolute value correctly', () {
      expect(parseAndFormatAbsolute('-1234.56'), '1,234.56');
      expect(parseAndFormatAbsolute('1234.56'), '1,234.56');
      expect(parseAndFormatAbsolute('-0.56'), '0.56');
      expect(parseAndFormatAbsolute('0.56'), '0.56');
      expect(parseAndFormatAbsolute('0'), '0.00');
    });
  });

  group('conditionalTextColor', () {
    testWidgets('should return correct color based on conditions',
        (WidgetTester tester) async {
      final testWidget = MaterialApp(
        theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch().copyWith(error: Colors.red),
        ),
        home: Builder(
          builder: (BuildContext context) {
            return Container();
          },
        ),
      );

      await tester.pumpWidget(testWidget);
      final BuildContext context = tester.element(find.byType(Container));

      expect(conditionalTextColor(context, true, false),
          Theme.of(context).colorScheme.error);
      expect(conditionalTextColor(context, false, true), Colors.grey);
      expect(conditionalTextColor(context, false, false), Colors.green[900]);
    });
  });

  group('showToast', () {
    test('should show toast and return true', () {
      expect(showToast('Hello'), true);
    });
  });
}
