import 'dart:math';
import 'package:rateflow/models/chart_point.dart';
import 'package:rateflow/models/currency.dart';
import 'package:rateflow/services/rate_service.dart';

// Canned data so screenshot tests don't depend on a live network call.
class FakeRateService extends RateService {
  static const _rates = {
    'USD_EUR': 0.92,
    'EUR_USD': 1.087,
    'EUR_GBP': 0.84,
    'GBP_EUR': 1.19,
    'BTC_USD': 67250.0,
    'USD_BTC': 1 / 67250.0,
    'ETH_USD': 2450.0,
  };

  @override
  Future<double> getRate(Currency from, Currency to) async {
    return _rates['${from.code}_${to.code}'] ?? 1.0;
  }

  @override
  Future<List<ChartPoint>> getHistory(Currency from, Currency to, int days) async {
    final base = _rates['${from.code}_${to.code}'] ?? 1.0;
    final now = DateTime(2026, 10, 26);

    return List.generate(days, (i) {
      final date = now.subtract(Duration(days: days - i));
      final wiggle = sin(i / 6) * base * 0.03;
      final drift = base * 0.0015 * i;
      return ChartPoint(date, base + wiggle + drift);
    });
  }
}
