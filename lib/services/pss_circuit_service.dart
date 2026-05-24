import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/pss_circuit.dart';

class PssCircuitService {
  static const String _baseUrl =
      'https://qxdydzgzlryqjzvneegy.supabase.co/rest/v1';
  static const String _anonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InF4ZHlkemd6bHJ5cWp6dm5lZWd5Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3Nzk2MjI1MzQsImV4cCI6MjA5NTE5ODUzNH0.BjGDyE51nLxBOoPVLmBlrazUCYZGkTD-BfVsuohX6mI';

  static Map<String, String> get _headers => {
        'apikey': _anonKey,
        'Authorization': 'Bearer $_anonKey',
        'Content-Type': 'application/json',
      };

  /// Fetches all active PSS circuits ordered by display_order ascending.
  static Future<List<PssCircuit>> fetchActiveCircuits() async {
    final uri = Uri.parse(
      '$_baseUrl/pss_circuits?is_active=eq.true&order=display_order.asc',
    );

    final response = await http.get(uri, headers: _headers);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body) as List<dynamic>;
      return data
          .map((e) => PssCircuit.fromJson(e as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception(
        'Failed to load PSS circuits: ${response.statusCode} ${response.body}',
      );
    }
  }
}
