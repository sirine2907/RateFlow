import 'package:flutter/material.dart';
import '../models/currency.dart';
import '../services/rate_cache.dart';
import '../services/rate_service.dart';
import '../utils/currency_list.dart';

class ConverterProvider extends ChangeNotifier {
  final RateService _rateService = RateService();
  final RateCache _cache = RateCache();

  Currency from = currencyByCode('USD');
  Currency to = currencyByCode('EUR');
  double amount = 1;

  double? result;
  bool isLoading = false;
  String? error;
  bool isFromCache = false;

  void setFrom(Currency currency) {
    from = currency;
    convert();
  }

  void setTo(Currency currency) {
    to = currency;
    convert();
  }

  void setAmount(double value) {
    amount = value;
    convert();
  }

  void swap() {
    final oldFrom = from;
    from = to;
    to = oldFrom;
    convert();
  }

  Future<void> convert() async {
    isLoading = true;
    error = null;
    isFromCache = false;
    notifyListeners();

    try {
      final rate = await _rateService.getRate(from, to);
      result = amount * rate;
      await _cache.save(from.code, to.code, rate);
    } catch (e) {
      final cached = await _cache.read(from.code, to.code);
      if (cached != null) {
        result = amount * cached.rate;
        isFromCache = true;
      } else {
        error = 'Could not load this rate. Check your connection.';
      }
    }

    isLoading = false;
    notifyListeners();
  }
}
