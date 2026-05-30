import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/pss_component.dart';
import '../models/pss_component_detail.dart';

class PssComponentService {
  static final SupabaseClient _db = Supabase.instance.client;

  // ── Components ──────────────────────────────────────────────────────────────

  static Future<List<PssComponent>> fetchAllComponents() async {
    try {
      final res = await _db
          .from('pss_components')
          .select()
          .eq('display', true)
          .order('sort_order', ascending: true);
      return (res as List).map((m) => PssComponent.fromMap(m)).toList();
    } catch (e) {
      debugPrint('PssComponentService.fetchAllComponents: $e');
      return [];
    }
  }

  // ── Detail points for a component ───────────────────────────────────────────

  static Future<List<PssComponentDetail>> fetchDetails(int componentId) async {
    try {
      final res = await _db
          .from('pss_component_details')
          .select()
          .eq('component_id', componentId)
          .eq('display', true)
          .order('sort_order', ascending: true);
      return (res as List).map((m) => PssComponentDetail.fromMap(m)).toList();
    } catch (e) {
      debugPrint('PssComponentService.fetchDetails: $e');
      return [];
    }
  }
}
