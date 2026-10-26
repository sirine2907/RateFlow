import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/chart_point.dart';

// Talks to frankfurter.app - a free exchange rate API, no key needed.
// It's run on top of the European Central Bank's daily reference rates.
class FiatApi {
  static const _base = 'https://api.frankfurter.app';

  Future<double> getRate(String from, String to) async {
    final uri = Uri.parse('$_base/latest?from=$from&to=$to');
    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception('Failed to load fiat rate ($from -> $to)');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final rates = data['rates'] as Map<String, dynamic>;
    return (rates[to] as num).toDouble();
  }

  // Daily rates for the last [days] days, from oldest to newest.
  Future<List<ChartPoint>> getHistory(String from, String to, int days) async {
    final end = DateTime.now();
    final start = end.subtract(Duration(days: days));
    final startStr = _formatDate(start);
    final endStr = _formatDate(end);

    final uri = Uri.parse('$_base/$startStr..$endStr?from=$from&to=$to');
    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception('Failed to load fiat history ($from -> $to)');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final rates = data['rates'] as Map<String, dynamic>;

    final points = rates.entries.map((entry) {
      final date = DateTime.parse(entry.key);
      final value = (entry.value as Map<String, dynamic>)[to] as num;
      return ChartPoint(date, value.toDouble());
    }).toList();

    points.sort((a, b) => a.date.compareTo(b.date));
    return points;
  }

  String _formatDate(DateTime date) {
    final y = date.year.toString().padLeft(4, '0');
    final m = date.month.toString().padLeft(2, '0');
    final d = date.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }
}
