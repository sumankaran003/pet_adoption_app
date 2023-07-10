import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';

Text textWidget(String text, double size, Color color) {
  return Text(
    text,
    style: GoogleFonts.roboto(
      color: color,
      fontSize: size,
      fontWeight: FontWeight.w400,
    ),
  );
}

void main() {
  testWidgets('Testing for Nymble', (WidgetTester tester) async {
    const String expectedText = 'Hello, Nymble!';
    const double expectedSize = 20.0;
    const Color expectedColor = Colors.blue;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: textWidget(expectedText, expectedSize, expectedColor),
        ),
      ),
    );

    final textFinder = find.text(expectedText);
    expect(textFinder, findsOneWidget);

    final textWidgetInstance = tester.widget<Text>(textFinder);
    expect(textWidgetInstance.style!.fontSize, equals(expectedSize));
    expect(textWidgetInstance.style!.color, equals(expectedColor));
    expect(textWidgetInstance.style!.fontWeight, equals(FontWeight.w400));
  });
}
