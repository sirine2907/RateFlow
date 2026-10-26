// A currency that can be converted - either a regular fiat currency
// (like USD, EUR) or a crypto coin (like BTC, ETH).
class Currency {
  final String code; // e.g. "USD" or "BTC"
  final String name; // e.g. "US Dollar" or "Bitcoin"
  final String flag; // emoji flag or coin symbol, shown in the UI
  final bool isCrypto;
  final String? coinGeckoId; // only set for crypto, e.g. "bitcoin"

  const Currency({
    required this.code,
    required this.name,
    required this.flag,
    required this.isCrypto,
    this.coinGeckoId,
  });

  @override
  bool operator ==(Object other) => other is Currency && other.code == code;

  @override
  int get hashCode => code.hashCode;
}
