import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    expect(find.text('TPCODL'), findsOneWidget);
  });

  testWidgets('Tapping Photos card navigates to PhotosViewScreen', (WidgetTester tester) async {
    // Read the actual file from disk
    final file = File('subststion_data/data.txt');
    final content = file.readAsStringSync();

    // Mock rootBundle to return the contents of the file
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMessageHandler('flutter/assets', (message) async {
      if (message == null) return null;
      final Uint8List list = message.buffer.asUint8List(message.offsetInBytes, message.lengthInBytes);
      final key = utf8.decode(list);
      if (key.endsWith('data.txt')) {
        final buffer = Uint8List.fromList(content.codeUnits).buffer;
        return ByteData.view(buffer);
      }
      return null;
    });

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
}

