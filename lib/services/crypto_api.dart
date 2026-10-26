import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/chart_point.dart';

// Talks to the CoinGecko free public API, no key needed.
class CryptoApi {
  static const _base = 'https://api.coingecko.com/api/v3';

  // Price of 1 unit of [coinId] in [vsCurrency] (e.g. "bitcoin" in "usd").
  Future<double> getPrice(String coinId, String vsCurrency) async {
    final vs = vsCurrency.toLowerCase();
    final uri = Uri.parse('$_base/simple/price?ids=$coinId&vs_currencies=$vs');
    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception('Failed to load crypto price ($coinId -> $vsCurrency)');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final coinData = data[coinId] as Map<String, dynamic>?;
    if (coinData == null || coinData[vs] == null) {
      throw Exception('No price data for $coinId in $vsCurrency');
    }
    return (coinData[vs] as num).toDouble();
  }

  // Daily price points for the last [days] days, oldest to newest.
  Future<List<ChartPoint>> getHistory(
    String coinId,
    String vsCurrency,
    int days,
  ) async {
    final vs = vsCurrency.toLowerCase();
    final uri = Uri.parse(
      '$_base/coins/$coinId/market_chart?vs_currency=$vs&days=$days&interval=daily',
    );
    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception('Failed to load crypto history ($coinId -> $vsCurrency)');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final prices = data['prices'] as List<dynamic>;

    return prices.map((point) {
      final pair = point as List<dynamic>;
      final date = DateTime.fromMillisecondsSinceEpoch(pair[0] as int);
      final value = (pair[1] as num).toDouble();
      return ChartPoint(date, value);
    }).toList();
  }
}
