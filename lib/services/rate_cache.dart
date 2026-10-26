import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

// Caches the last successfully fetched rate for a currency pair, so the
// converter still shows something useful if the next API call fails
// (no internet, API down, etc).
class RateCache {
  Future<void> save(String from, String to, double rate) async {
    final prefs = await SharedPreferences.getInstance();
    final entry = jsonEncode({
      'rate': rate,
      'cachedAt': DateTime.now().toIso8601String(),
    });
    await prefs.setString(_key(from, to), entry);
  }

  Future<CachedRate?> read(String from, String to) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key(from, to));
    if (raw == null) return null;

    final data = jsonDecode(raw) as Map<String, dynamic>;
    return CachedRate(
      rate: (data['rate'] as num).toDouble(),
      cachedAt: DateTime.parse(data['cachedAt'] as String),
    );
  }

  String _key(String from, String to) => 'rate_cache_${from}_$to';
}

class CachedRate {
  final double rate;
  final DateTime cachedAt;

  const CachedRate({required this.rate, required this.cachedAt});
}
