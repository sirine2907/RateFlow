import 'package:flutter/material.dart';
import '../models/currency.dart';
import '../services/crypto_api.dart';
import '../services/fiat_api.dart';
import '../services/rate_cache.dart';
import '../utils/currency_list.dart';

class ConverterProvider extends ChangeNotifier {
  final FiatApi _fiatApi = FiatApi();
  final CryptoApi _cryptoApi = CryptoApi();
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
      final rate = await _getRate(from, to);
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

  // Figures out which API(s) to call based on whether each side is
  // fiat or crypto, then returns "how much of [to] for 1 of [from]".
  Future<double> _getRate(Currency from, Currency to) async {
    if (!from.isCrypto && !to.isCrypto) {
      return _fiatApi.getRate(from.code, to.code);
    }

    if (from.isCrypto && !to.isCrypto) {
      return _cryptoApi.getPrice(from.coinGeckoId!, to.code);
    }

    if (!from.isCrypto && to.isCrypto) {
      final price = await _cryptoApi.getPrice(to.coinGeckoId!, from.code);
      return 1 / price;
    }

    // Both crypto: cross the two USD prices.
    final fromUsd = await _cryptoApi.getPrice(from.coinGeckoId!, 'usd');
    final toUsd = await _cryptoApi.getPrice(to.coinGeckoId!, 'usd');
    return fromUsd / toUsd;
  }
}
