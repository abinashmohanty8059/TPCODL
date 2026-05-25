class PssComponentCategory {
  final int id;
  final String name;
  final String? description;
  final String iconName;
  final String? voltageClass;
  final String priority;
  final bool display;
  final int sortOrder;
  final String? coverImageUrl;

  const PssComponentCategory({
    required this.id,
    required this.name,
    this.description,
    this.iconName = 'electrical_services',
    this.voltageClass,
    this.priority = 'HIGH',
    this.display = true,
    this.sortOrder = 0,
    this.coverImageUrl,
  });

  factory PssComponentCategory.fromMap(Map<String, dynamic> m) {
    return PssComponentCategory(
      id: m['id'] as int,
      name: m['name'] as String,
      description: m['description'] as String?,
      iconName: (m['icon_name'] as String?) ?? 'electrical_services',
      voltageClass: m['voltage_class'] as String?,
      priority: (m['priority'] as String?) ?? 'HIGH',
      display: (m['display'] as bool?) ?? true,
      sortOrder: (m['sort_order'] as int?) ?? 0,
      coverImageUrl: m['cover_image_url'] as String?,
    );
  }
}
