/// Represents one entry in the `pss_circuits` Supabase table.
///
/// [contentType] is either `'image'` (opens a fullscreen zoomable image)
/// or `'web'` (opens the URL in an in-app WebView).
class PssCircuit {
  final String id;
  final int circuitNumber;
  final String title;
  final String busSection;
  final String contentUrl;
  final String contentType; // 'image' | 'web'
  final bool isActive;
  final int displayOrder;
  final DateTime createdAt;

  const PssCircuit({
    required this.id,
    required this.circuitNumber,
    required this.title,
    required this.busSection,
    required this.contentUrl,
    required this.contentType,
    required this.isActive,
    required this.displayOrder,
    required this.createdAt,
  });

  bool get isWebContent => contentType == 'web';

  factory PssCircuit.fromJson(Map<String, dynamic> json) {
    return PssCircuit(
      id: json['id'] as String,
      circuitNumber: (json['circuit_number'] as num?)?.toInt() ?? 0,
      title: json['title'] as String? ?? '',
      busSection: json['bus_section'] as String? ?? '',
      contentUrl: json['content_url'] as String,
      contentType: json['content_type'] as String? ?? 'image',
      isActive: json['is_active'] as bool? ?? true,
      displayOrder: (json['display_order'] as num?)?.toInt() ?? 0,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'circuit_number': circuitNumber,
        'title': title,
        'bus_section': busSection,
        'content_url': contentUrl,
        'content_type': contentType,
        'is_active': isActive,
        'display_order': displayOrder,
        'created_at': createdAt.toIso8601String(),
      };
}
