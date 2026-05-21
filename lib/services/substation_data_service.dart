import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import '../models/substation_equipment.dart';

class SubstationDataService {
  static List<SubstationEquipment> _cache = [];

  static Future<List<SubstationEquipment>> loadEquipmentData() async {
    if (_cache.isNotEmpty) return _cache;

    try {
      final String rawData = await rootBundle.loadString('subststion_data/data.txt');
      final lines = const LineSplitter().convert(rawData);
      
      final List<SubstationEquipment> equipmentList = [];
      
      int? currentId;
      String? currentImageName;
      String? currentEquipmentName;
      String? currentSection;
      String currentPurpose = '';
      List<String> currentVisibleDetails = [];
      List<String> currentFunctionalNotes = [];
      Map<String, String> currentTechnicalDetails = {};

      void saveCurrent() {
        if (currentId != null && currentImageName != null && currentEquipmentName != null) {
          final Map<String, String> diskMapping = {
            'transformer.jpg': 'transformer.jpg',
            'manualto remote lever(1).jpg': 'manualto remote lever.jpg',
            'smart meters.jpg': 'smart meters.jpg',
            'pss zoom(1).jpg': 'pss zoom.jpg',
            'smart meter(1).jpg': 'smart meter.jpg',
            'relaymodule(1).jpg': 'relaymodule.jpg',
            'indside smartmeterbox.jpg': 'indside smartmeterbox.jpg',
            'switch inside rtu.jpg': 'switch inside rtu.jpg',
            'rturemotetomanualswitch.jpg': 'rturemotetomanualswitch.jpg',
            'rtucpu.jpg': 'rtucpu.jpg',
            'rtucpu2.jpg': 'rtucpu2.jpg',
            'rtucpu3.jpg': 'rtucpu3.jpg',
            'rtucpu4.jpg': 'rtucpu4.jpg',
            'rtucpu connection.jpg': 'rtucpu connection.jpg',
            'acbd pannel.jpg': 'acbd pannel.jpg',
            'rtubox.jpg': 'rtubox.jpg',
            'relay panel front.jpg': 'PSS indicator.jpg',
            'relay panel internal.jpg': 'RTCC3.jpg',
            'network rack.jpg': 'patch Pannel and switch.jpg',
            'rtu rack complete.jpg': 'PSSHUB.jpg',
            'gas pressure gauges.jpg': 'RMU.jpg',
            'breaker mimic panel.jpg': 'PSS.jpg',
            'ethernet communication panel.jpg': 'patch Pannel and switch.jpg',
            'transformer alarm module.jpg': 'ANNR.jpg',
            'remote control switch.jpg': 'digital,analog card when sistem set to remote.jpg',
            'moxa switch.jpg': 'rtucpu connection.jpg',
            'husky rtu front.jpg': 'Control box.jpg',
            'rtu ethernet ports.jpg': 'Analog and digital wire attached behind rtu cpu.jpg',
            'battery charger feeder.jpg': 'fcbc,charger1.jpg',
            'substation overview.jpg': 'PSS.jpg',
          };

          // clean image name (remove (1) if present)
          String actualImageName = currentImageName!;
          if (diskMapping.containsKey(actualImageName)) {
            actualImageName = diskMapping[actualImageName]!;
          } else if (actualImageName.contains('(1).jpg')) {
            actualImageName = actualImageName.replaceAll('(1).jpg', '.jpg');
          }

          // Category mapping
          final category = _getCategoryForEquipment(currentId!, currentEquipmentName!, actualImageName);

          equipmentList.add(SubstationEquipment(
            id: currentId!,
            imageName: currentImageName!,
            actualImageName: actualImageName,
            name: currentEquipmentName!,
            category: category,
            purpose: currentPurpose.trim(),
            visibleDetails: List.from(currentVisibleDetails),
            functionalNotes: List.from(currentFunctionalNotes),
            technicalDetails: Map.from(currentTechnicalDetails),
          ));
        }
        
        // Reset block variables
        currentId = null;
        currentImageName = null;
        currentEquipmentName = null;
        currentSection = null;
        currentPurpose = '';
        currentVisibleDetails = [];
        currentFunctionalNotes = [];
        currentTechnicalDetails = {};
      }

      final headerRegex = RegExp(r'^(\d+)\.\s+(\S.*)$');

      for (var line in lines) {
        line = line.trim();
        if (line.isEmpty) continue;

        final match = headerRegex.firstMatch(line);
        if (match != null) {
          // Save previous block
          saveCurrent();

          currentId = int.parse(match.group(1)!);
          currentImageName = match.group(2)!;
          continue;
        }

        if (line == 'Equipment') {
          currentSection = 'Equipment';
          continue;
        } else if (line == 'Visible Details' || line == 'Visible Alarms' || line == 'Includes') {
          currentSection = 'Visible Details';
          continue;
        } else if (line == 'Rating' || line == 'Labels') {
          currentSection = 'Technical Details';
          continue;
        } else if (line == 'Purpose') {
          currentSection = 'Purpose';
          continue;
        } else if (line == 'Functional Notes') {
          currentSection = 'Functional Notes';
          continue;
        }

        // Add line to current section
        if (currentSection == 'Equipment') {
          currentEquipmentName = line;
        } else if (currentSection == 'Purpose') {
          if (currentPurpose.isNotEmpty) currentPurpose += ' ';
          currentPurpose += line;
        } else if (currentSection == 'Visible Details') {
          currentVisibleDetails.add(line);
        } else if (currentSection == 'Functional Notes') {
          currentFunctionalNotes.add(line);
        } else if (currentSection == 'Technical Details') {
          // If the line contains a colon, split it, e.g. "Protocol: IEC 61850"
          if (line.contains(':')) {
            final parts = line.split(':');
            final key = parts[0].trim();
            final value = parts.sublist(1).join(':').trim();
            currentTechnicalDetails[key] = value;
          } else {
            // For ratings or labels which don't have colon, like "12.5 MVA" or "TRAFO-1"
            currentTechnicalDetails['Detail ${currentTechnicalDetails.length + 1}'] = line;
          }
        }
      }

      // Save last block
      saveCurrent();

      _cache = equipmentList;
      return _cache;
    } catch (e) {
      debugPrint('Error parsing substation data: $e');
      return [];
    }
  }

  static String _getCategoryForEquipment(int id, String name, String imageName) {
    final lowerName = name.toLowerCase();
    final lowerImage = imageName.toLowerCase();
    
    if (lowerName.contains('transformer') || lowerImage.contains('transformer')) {
      return 'Transformer Systems';
    } else if (lowerName.contains('rtu') || lowerImage.contains('rtu') || lowerName.contains('husky')) {
      return 'RTU Systems';
    } else if (lowerName.contains('relay') || lowerName.contains('protection') || lowerImage.contains('relay')) {
      return 'Protection Relays';
    } else if (lowerName.contains('meter') || lowerImage.contains('meter')) {
      return 'Smart Metering';
    } else if (lowerName.contains('switch') || lowerName.contains('ethernet') || lowerName.contains('network') || lowerName.contains('moxa') || lowerImage.contains('switch') || lowerImage.contains('rack') || lowerName.contains('patch')) {
      if (lowerName.contains('selector') || lowerName.contains('lever') || lowerName.contains('control')) {
        return 'Control Systems';
      }
      return 'Communication Network';
    } else if (lowerName.contains('acdb') || lowerName.contains('ac distribution') || lowerImage.contains('acbd') || lowerImage.contains('dcdb')) {
      return 'ACDB Panels';
    } else if (lowerName.contains('control') || lowerName.contains('lever') || lowerName.contains('mimic') || lowerName.contains('selector') || lowerName.contains('contact') || lowerName.contains('fire')) {
      return 'Control Systems';
    } else if (lowerName.contains('switchgear') || lowerName.contains('rmu') || lowerName.contains('pressure') || lowerImage.contains('rmu') || lowerImage.contains('gas')) {
      return 'Switchgear';
    } else if (lowerName.contains('substation overview') || lowerName.contains('system') || lowerImage.contains('overview')) {
      return 'SCADA Infrastructure';
    } else {
      return 'Control Systems'; // fallback
    }
  }
}
