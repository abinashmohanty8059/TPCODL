import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tpcodl/main.dart';

void main() {
  setUpAll(() async {
    // Mock SharedPreferences platform channel
    SharedPreferences.setMockInitialValues({});

    // Initialize Supabase with dummy credentials for widget tests to avoid initialization assertion error.
    await Supabase.initialize(
      url: 'https://placeholder.supabase.co',
      anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InBsYWNlaG9sZGVyIiwicm9sZSI6ImFub24iLCJpYXQiOjE2MDAwMDAwMDAsImV4cCI6MTkwMDAwMDAwMH0.placeholder',
    );
  });

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
    expect(find.text('TPCODL'), findsOneWidget);
  });

  testWidgets('Tapping Photos card navigates to PhotosViewScreen', (WidgetTester tester) async {
    await tester.pumpWidget(const TPCODLApp());

    // Advance virtual time to 3 seconds for the timer to trigger
    await tester.pump(const Duration(seconds: 3));

    // Pump repeatedly to allow navigation transitions to execute
    for (int i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }

    // Ensure we are on home screen
    expect(find.text('LIVE METRICS'), findsOneWidget);

    // Find the text 'Photos' and ensure it is visible in the horizontal list view
    final photosFinder = find.text('Photos');
    await tester.ensureVisible(photosFinder);
    for (int i = 0; i < 5; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }

    // Tap the Photos card
    await tester.tap(photosFinder);
    for (int i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }

    // Verify that we are on the Substation Gallery screen
    expect(find.text('SUBSTATION GALLERY'), findsOneWidget);
    
    // Verify that grid view options are available
    expect(find.byIcon(Icons.grid_view_rounded), findsOneWidget);
    expect(find.byIcon(Icons.view_stream_rounded), findsOneWidget);
  });

  testWidgets('Tapping Substation module card navigates to SubstationScreen', (WidgetTester tester) async {
    await tester.pumpWidget(const TPCODLApp());

    // Advance virtual time to 3 seconds for the timer to trigger
    await tester.pump(const Duration(seconds: 3));

    // Pump repeatedly to allow navigation transitions to execute
    for (int i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }

    // Ensure we are on home screen
    expect(find.text('CORE SYSTEMS'), findsOneWidget);

    // Find the text 'Substation' in CORE SYSTEMS section
    final substationFinder = find.text('Substation');
    await tester.ensureVisible(substationFinder);
    for (int i = 0; i < 5; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }

    // Tap the Substation card
    await tester.tap(substationFinder);
    for (int i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }

    // Verify that the SUBSTATION tab is active
    expect(find.text('SUBSTATION'), findsWidgets);
  });
}

