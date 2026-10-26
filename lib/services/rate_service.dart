import '../models/chart_point.dart';
import '../models/currency.dart';
import 'crypto_api.dart';
import 'fiat_api.dart';

// Works out which API(s) to call based on whether each side of the pair
// is fiat or crypto. Shared by the converter and the favorites list so
// the branching logic only lives in one place.
class RateService {
  final FiatApi fiatApi;
  final CryptoApi cryptoApi;

  RateService({FiatApi? fiatApi, CryptoApi? cryptoApi})
      : fiatApi = fiatApi ?? FiatApi(),
        cryptoApi = cryptoApi ?? CryptoApi();

  // Returns "how much of [to] for 1 of [from]".
  Future<double> getRate(Currency from, Currency to) async {
    if (!from.isCrypto && !to.isCrypto) {
      return fiatApi.getRate(from.code, to.code);
    }

    if (from.isCrypto && !to.isCrypto) {
      return cryptoApi.getPrice(from.coinGeckoId!, to.code);
    }

    if (!from.isCrypto && to.isCrypto) {
      final price = await cryptoApi.getPrice(to.coinGeckoId!, from.code);
      return 1 / price;
    }

    // Both crypto: cross the two USD prices.
    final fromUsd = await cryptoApi.getPrice(from.coinGeckoId!, 'usd');
    final toUsd = await cryptoApi.getPrice(to.coinGeckoId!, 'usd');
    return fromUsd / toUsd;
  }

  // Historical "how much of [to] for 1 of [from]", oldest to newest.
  // Crypto-to-crypto charting is left out on purpose: it would need two
  // history calls crossed through USD, which adds a lot of complexity
  // for a pairing people rarely want to chart.
  Future<List<ChartPoint>> getHistory(Currency from, Currency to, int days) async {
    if (!from.isCrypto && !to.isCrypto) {
      return fiatApi.getHistory(from.code, to.code, days);
    }

    if (from.isCrypto && !to.isCrypto) {
      return cryptoApi.getHistory(from.coinGeckoId!, to.code, days);
    }

    if (!from.isCrypto && to.isCrypto) {
      final points = await cryptoApi.getHistory(to.coinGeckoId!, from.code, days);
      return points.map((p) => ChartPoint(p.date, 1 / p.value)).toList();
    }

    throw UnsupportedError('Charting two cryptos against each other is not supported yet.');
  }
}
