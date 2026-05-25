class PssComponentDetail {
  final int id;
  final int componentId;
  final String section; // 'visible_details' | 'tech_specs' | 'functional_notes'
  final String content;
  final int sortOrder;
  final bool display;

  const PssComponentDetail({
    required this.id,
    required this.componentId,
    required this.section,
    required this.content,
    this.sortOrder = 0,
    this.display = true,
  });

  factory PssComponentDetail.fromMap(Map<String, dynamic> m) {
    return PssComponentDetail(
      id: m['id'] as int,
      componentId: m['component_id'] as int,
      section: m['section'] as String,
      content: m['content'] as String,
      sortOrder: (m['sort_order'] as int?) ?? 0,
      display: (m['display'] as bool?) ?? true,
    );
  }
}
