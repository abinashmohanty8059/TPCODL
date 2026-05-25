class GalleryItem {
  final int id;
  final String title;
  final String? subtitle;
  final String? description;
  final String imageUrl;
  final int priority;
  final bool display;
  final String? category;
  final String? location;
  final List<String>? tags;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const GalleryItem({
    required this.id,
    required this.title,
    this.subtitle,
    this.description,
    required this.imageUrl,
    this.priority = 0,
    this.display = true,
    this.category,
    this.location,
    this.tags,
    this.createdAt,
    this.updatedAt,
  });

  factory GalleryItem.fromMap(Map<String, dynamic> map) {
    return GalleryItem(
      id: map['id'] as int,
      title: map['title'] as String,
      subtitle: map['subtitle'] as String?,
      description: map['description'] as String?,
      imageUrl: map['image_url'] as String,
      priority: (map['priority'] as int?) ?? 0,
      display: (map['display'] as bool?) ?? true,
      category: map['category'] as String?,
      location: map['location'] as String?,
      tags: (map['tags'] as List<dynamic>?)?.cast<String>(),
      createdAt: map['created_at'] != null
          ? DateTime.tryParse(map['created_at'] as String)
          : null,
      updatedAt: map['updated_at'] != null
          ? DateTime.tryParse(map['updated_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'description': description,
      'image_url': imageUrl,
      'priority': priority,
      'display': display,
      'category': category,
      'location': location,
      'tags': tags,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}
