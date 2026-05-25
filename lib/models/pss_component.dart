class PssComponent {
  final int id;
  final int categoryId;
  final String name;
  final String nodeLabel;
  final String? purpose;
  final List<String> imageUrls;
  final bool display;
  final int sortOrder;

  const PssComponent({
    required this.id,
    required this.categoryId,
    required this.name,
    this.nodeLabel = 'NODE #1',
    this.purpose,
    this.imageUrls = const [],
    this.display = true,
    this.sortOrder = 0,
  });

  factory PssComponent.fromMap(Map<String, dynamic> m) {
    return PssComponent(
      id: m['id'] as int,
      categoryId: m['category_id'] as int,
      name: m['name'] as String,
      nodeLabel: (m['node_label'] as String?) ?? 'NODE #1',
      purpose: m['purpose'] as String?,
      imageUrls: (m['image_urls'] as List<dynamic>?)?.cast<String>() ?? [],
      display: (m['display'] as bool?) ?? true,
      sortOrder: (m['sort_order'] as int?) ?? 0,
    );
  }
}
