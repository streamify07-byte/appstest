import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http;

class ApiService {
  ApiService({this.baseUrl});
  final String? baseUrl;

  Future<List<dynamic>> fetchJsonList(String endpoint, {String? assetFallback}) async {
    try {
      if (baseUrl != null) {
        final uri = Uri.parse('$baseUrl/$endpoint');
        final resp = await http.get(uri).timeout(const Duration(seconds: 10));
        if (resp.statusCode == 200) {
          final data = json.decode(resp.body);
          if (data is List) return data;
          if (data is Map && data['items'] is List) return List<dynamic>.from(data['items']);
        }
      }
    } catch (_) {
      // ignore and use fallback
    }

    if (assetFallback != null) {
      final raw = await rootBundle.loadString(assetFallback);
      final data = json.decode(raw);
      return List<dynamic>.from(data);
    }
    return <dynamic>[];
  }
}
