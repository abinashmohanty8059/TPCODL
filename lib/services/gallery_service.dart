import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/gallery_item.dart';

class GalleryService {
  static final SupabaseClient _client = Supabase.instance.client;
  static const String _table = 'gallery_items';

  /// Fetch all gallery items where display = true, ordered by priority ASC then created_at ASC.
  static Future<List<GalleryItem>> fetchDisplayedItems() async {
    try {
      final response = await _client
          .from(_table)
          .select()
          .eq('display', true)
          .order('priority', ascending: true)
          .order('created_at', ascending: true);

      return (response as List<dynamic>)
          .map((e) => GalleryItem.fromMap(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      debugPrint('GalleryService.fetchDisplayedItems error: $e');
      return [];
    }
  }

  /// Realtime stream of all displayed gallery items.
  static Stream<List<GalleryItem>> streamDisplayedItems() {
    return _client
        .from(_table)
        .stream(primaryKey: ['id'])
        .order('priority', ascending: true)
        .map((list) => list
            .map((e) => GalleryItem.fromMap(e))
            .where((item) => item.display)
            .toList());
  }
}
