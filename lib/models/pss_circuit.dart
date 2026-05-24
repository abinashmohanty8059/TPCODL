class PssCircuit {
  final String id;
  final String locationName;
  final String subtitle;
  final String busSection;
  final int circuitNumber;
  final String imageUrl;
  final bool isActive;
  final int displayOrder;
  final DateTime createdAt;

  const PssCircuit({
    required this.id,
    required this.locationName,
    required this.subtitle,
    required this.busSection,
    required this.circuitNumber,
    required this.imageUrl,
    required this.isActive,
    required this.displayOrder,
    required this.createdAt,
  });

  factory PssCircuit.fromJson(Map<String, dynamic> json) {
    return PssCircuit(
      id: json['id'] as String,
      locationName: json['location_name'] as String,
      subtitle: json['subtitle'] as String? ?? '',
      busSection: json['bus_section'] as String? ?? '',
      circuitNumber: (json['circuit_number'] as num?)?.toInt() ?? 0,
      imageUrl: json['image_url'] as String,
      isActive: json['is_active'] as bool? ?? true,
      displayOrder: (json['display_order'] as num?)?.toInt() ?? 0,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'location_name': locationName,
        'subtitle': subtitle,
        'bus_section': busSection,
        'circuit_number': circuitNumber,
        'image_url': imageUrl,
        'is_active': isActive,
        'display_order': displayOrder,
        'created_at': createdAt.toIso8601String(),
      };
}
