import 'package:flutter/material.dart';

class SubstationEquipment {
  final int id;
  final String imageName;      // original filename in txt, e.g. manualto remote lever(1).jpg
  final String actualImageName; // cleaned filename on disk, e.g. manualto remote lever.jpg
  final String name;           // Equipment name
  final String category;       // Category name
  final String purpose;        // Purpose
  final List<String> visibleDetails;
  final List<String> functionalNotes;
  final Map<String, String> technicalDetails;

  SubstationEquipment({
    required this.id,
    required this.imageName,
    required this.actualImageName,
    required this.name,
    required this.category,
    required this.purpose,
    required this.visibleDetails,
    required this.functionalNotes,
    required this.technicalDetails,
  });

  // Helper to get asset image path
  String get assetPath => 'subststion_data/pic/$actualImageName';

  // Helper to get status color based on category/type
  Color get statusColor {
    if (category == 'Transformer Systems' || category == 'RTU Systems' || category == 'Protection Relays') {
      return const Color(0xFF00C853); // Active green
    }
    return const Color(0xFF29B6F6); // Operational blue
  }

  // Get status text
  String get statusText => 'OPERATIONAL';
}
