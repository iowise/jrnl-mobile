// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jrnl/journal.dart';
import 'package:jrnl/jrnl/models.dart';

void main() {
  testWidgets('Jounral is clickable', (WidgetTester tester) async {
    final records = [
      Record(DateTime(2020, 3, 05, 12, 54), 'ping 1', 'ping 1\nfirst line'),
      Record(DateTime(2020, 2, 05, 12), 'ping 2', 'ping 2\nfirst line'),
    ];
    var called;
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: Journal(
          records,
          (Record record) {
            called = record;
          },
        ),
      ),
    ));

    expect(find.text('ping 1'), findsOneWidget);
    expect(find.text('ping 2'), findsOneWidget);
    expect(find.text('first line'), findsNothing);

    await tester.tap(find.text('ping 1'));

    expect(called, equals(records[0]));
  });
}
