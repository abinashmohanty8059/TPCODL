class PssComponent {
  final int id;
  final String name;
  final String nodeLabel;
  final String? purpose;
  final List<String> imageUrls;
  final bool display;
  final int sortOrder;
  final String category;
  final String? voltageClass;
  final String priority;
  final String iconName;

  const PssComponent({
    required this.id,
    required this.name,
    this.nodeLabel = 'NODE #1',
    this.purpose,
    this.imageUrls = const [],
    this.display = true,
    this.sortOrder = 0,
    required this.category,
    this.voltageClass,
    this.priority = 'HIGH',
    this.iconName = 'electrical_services',
  });

  factory PssComponent.fromMap(Map<String, dynamic> m) {
    return PssComponent(
      id: m['id'] as int,
      name: m['name'] as String,
      nodeLabel: (m['node_label'] as String?) ?? 'NODE #1',
      purpose: m['purpose'] as String?,
      imageUrls: (m['image_urls'] as List<dynamic>?)?.cast<String>() ?? [],
      display: (m['display'] as bool?) ?? true,
      sortOrder: (m['sort_order'] as int?) ?? 0,
      category: m['category'] as String,
      voltageClass: m['voltage_class'] as String?,
      priority: (m['priority'] as String?) ?? 'HIGH',
      iconName: (m['icon_name'] as String?) ?? 'electrical_services',
    );
  }
}
