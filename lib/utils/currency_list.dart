import 'package:flutter/material.dart';
import '../models/currency.dart';

// Fiat list kept to currencies the frankfurter.app API actually supports
// (it mirrors the European Central Bank's reference rates).
const List<Currency> fiatCurrencies = [
  Currency(code: 'USD', name: 'US Dollar', color: Color(0xFF2E7D32), isCrypto: false),
  Currency(code: 'EUR', name: 'Euro', color: Color(0xFF1D4ED8), isCrypto: false),
  Currency(code: 'GBP', name: 'British Pound', color: Color(0xFF7C3AED), isCrypto: false),
  Currency(code: 'JPY', name: 'Japanese Yen', color: Color(0xFFDC2626), isCrypto: false),
  Currency(code: 'CHF', name: 'Swiss Franc', color: Color(0xFFEA580C), isCrypto: false),
  Currency(code: 'CAD', name: 'Canadian Dollar', color: Color(0xFFB91C1C), isCrypto: false),
  Currency(code: 'AUD', name: 'Australian Dollar', color: Color(0xFF0891B2), isCrypto: false),
  Currency(code: 'CNY', name: 'Chinese Yuan', color: Color(0xFFBE123C), isCrypto: false),
  Currency(code: 'INR', name: 'Indian Rupee', color: Color(0xFFD97706), isCrypto: false),
  Currency(code: 'SEK', name: 'Swedish Krona', color: Color(0xFF2563EB), isCrypto: false),
  Currency(code: 'SGD', name: 'Singapore Dollar', color: Color(0xFFE11D48), isCrypto: false),
  Currency(code: 'TRY', name: 'Turkish Lira', color: Color(0xFFC2410C), isCrypto: false),
];

// coinGeckoId is the id CoinGecko's API expects, which isn't always the
// same as the ticker symbol.
const List<Currency> cryptoCurrencies = [
  Currency(code: 'BTC', name: 'Bitcoin', color: Color(0xFFF7931A), isCrypto: true, coinGeckoId: 'bitcoin'),
  Currency(code: 'ETH', name: 'Ethereum', color: Color(0xFF627EEA), isCrypto: true, coinGeckoId: 'ethereum'),
  Currency(code: 'USDT', name: 'Tether', color: Color(0xFF26A17B), isCrypto: true, coinGeckoId: 'tether'),
  Currency(code: 'BNB', name: 'BNB', color: Color(0xFFF3BA2F), isCrypto: true, coinGeckoId: 'binancecoin'),
  Currency(code: 'SOL', name: 'Solana', color: Color(0xFF9945FF), isCrypto: true, coinGeckoId: 'solana'),
  Currency(code: 'XRP', name: 'XRP', color: Color(0xFF23292F), isCrypto: true, coinGeckoId: 'ripple'),
  Currency(code: 'ADA', name: 'Cardano', color: Color(0xFF0D1E30), isCrypto: true, coinGeckoId: 'cardano'),
  Currency(code: 'DOGE', name: 'Dogecoin', color: Color(0xFFC2A633), isCrypto: true, coinGeckoId: 'dogecoin'),
];

const List<Currency> allCurrencies = [...fiatCurrencies, ...cryptoCurrencies];

Currency currencyByCode(String code) {
  return allCurrencies.firstWhere((c) => c.code == code);
}
