import 'package:chp/ui/form_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('validates required clinical visit fields', (tester) async {
    tester.view.physicalSize = const Size(800, 1600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const MaterialApp(home: FormScreen()));

    final saveButton = find.text('Save Record Locally');
    await tester.tap(saveButton);
    await tester.pumpAndSettle();

    expect(find.text('Enter a patient CHW ID'), findsOneWidget);
    expect(find.text('Patient CHW ID *'), findsOneWidget);
    expect(find.text('Patient ID *'), findsNothing);
    expect(find.text('Enter a patient name'), findsOneWidget);
    expect(find.text('Enter a village name'), findsOneWidget);
    expect(find.text('Required'), findsOneWidget);
    expect(find.text('Select a visit type'), findsOneWidget);
  });
}
