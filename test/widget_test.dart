import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_crud/main.dart';

void main() {
  testWidgets('Widget test', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp());

    expect(find.text('UAS Nur'), findsOneWidget);
    expect(find.byType(TextField), findsNWidgets(6));
    expect(find.byType(Radio), findsNWidgets(2));
    expect(find.byType(ElevatedButton), findsNWidgets(2));
    expect(find.byType(ListView), findsOneWidget);
  });
}
