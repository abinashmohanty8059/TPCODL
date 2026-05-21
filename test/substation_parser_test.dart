import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tpcodl/services/substation_data_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    // Read the actual file from disk
    final file = File('subststion_data/data.txt');
    final content = file.readAsStringSync();

    // Mock rootBundle to return the contents of the file
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMessageHandler('flutter/assets', (message) async {
      final buffer = Uint8List.fromList(content.codeUnits).buffer;
      return ByteData.view(buffer);
    });
  });

  test('SubstationDataService parses 30 equipment items with full details', () async {
    final equipment = await SubstationDataService.loadEquipmentData();

    expect(equipment.length, 30);

    // Verify first equipment (transformer)
    final transformer = equipment.first;
    expect(transformer.id, 1);
    expect(transformer.name, '33/11 kV Power Transformer (Toshiba)');
    expect(transformer.imageName, 'transformer.jpg');
    expect(transformer.category, 'Transformer Systems');
    expect(transformer.purpose.contains('primary power conversion backbone'), true);
    expect(transformer.visibleDetails.length, greaterThanOrEqualTo(5));
    expect(transformer.technicalDetails['Voltage Ratio'], '33,000 V / 11,000 V (33/11 kV)');
    expect(transformer.functionalNotes.length, greaterThanOrEqualTo(3));

    // Verify all items are parsed correctly
    for (int i = 0; i < 30; i++) {
      final item = equipment[i];
      expect(item.id, i + 1);
      expect(item.name.isNotEmpty, true);
      expect(item.imageName.isNotEmpty, true);
      expect(item.purpose.isNotEmpty, true);
      expect(item.visibleDetails.isNotEmpty, true);
      expect(item.technicalDetails.isNotEmpty, true);
      expect(item.functionalNotes.isNotEmpty, true);
    }
  });
}
