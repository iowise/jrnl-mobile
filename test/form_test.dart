// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jrnl/fields/log_message.dart';
import 'package:jrnl/form.dart';
import 'package:jrnl/jrnl/models.dart';

void main() {
  testWidgets('Form has required fields and saves a record',
      (WidgetTester tester) async {
    Record? called;
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: RecordForm(
          onSaved: (RecordMomento record) {
            called = record.state;
          },
        ),
      ),
    ));

    expect(find.text('Create a record'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.check));
    await tester.pumpAndSettle();

    expect(find.text('Please select a date'), findsNothing);
    expect(find.text('Please add a log message'), findsOneWidget);

    await tester.enterText(find.byType(LogMessage), 'ping');

    await tester.tap(find.byIcon(Icons.check));
    await tester.pumpAndSettle();

    expect(find.text('Please select a date'), findsNothing);
    expect(find.text('Please add a log message'), findsNothing);

    expect(called!.fullContent, equals('ping'));
    expect(called!.title, equals('ping'));
  });
}
