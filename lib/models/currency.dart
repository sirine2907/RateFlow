import 'package:flutter/material.dart';

// A currency that can be converted - either a regular fiat currency
// (like USD, EUR) or a crypto coin (like BTC, ETH).
//
// Flag emoji don't render reliably everywhere (Windows in particular),
// so each currency gets a plain color used for its badge in the UI
// instead of a flag icon.
class Currency {
  final String code; // e.g. "USD" or "BTC"
  final String name; // e.g. "US Dollar" or "Bitcoin"
  final Color color;
  final bool isCrypto;
  final String? coinGeckoId; // only set for crypto, e.g. "bitcoin"

  const Currency({
    required this.code,
    required this.name,
    required this.color,
    required this.isCrypto,
    this.coinGeckoId,
  });

  @override
  bool operator ==(Object other) => other is Currency && other.code == code;

  @override
  int get hashCode => code.hashCode;
}
