import 'package:flutter_test/flutter_test.dart';
import 'package:tpcodl/main.dart';

void main() {
  testWidgets('App launches smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const TPCODLApp());

    // Advance virtual time to 3 seconds for the timer to trigger
    await tester.pump(const Duration(seconds: 3));

    // Pump repeatedly to allow navigation transitions to execute
    for (int i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }

    // Verify we transitioned to the main shell/home screen
    expect(find.text('TPCODL ACADEMY'), findsOneWidget);
  });
}
