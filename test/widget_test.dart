import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:movie_app/core/constants/branding.dart';

void main() {
  testWidgets('Branding title appears in a minimal scaffold', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          appBar: AppBar(title: Text(Branding.appName)),
        ),
      ),
    );

    expect(find.text(Branding.appName), findsOneWidget);
  });
}
