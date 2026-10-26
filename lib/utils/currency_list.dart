import '../models/currency.dart';

// Fiat list kept to currencies the frankfurter.app API actually supports
// (it mirrors the European Central Bank's reference rates).
const List<Currency> fiatCurrencies = [
  Currency(code: 'USD', name: 'US Dollar', flag: '🇺🇸', isCrypto: false),
  Currency(code: 'EUR', name: 'Euro', flag: '🇪🇺', isCrypto: false),
  Currency(code: 'GBP', name: 'British Pound', flag: '🇬🇧', isCrypto: false),
  Currency(code: 'JPY', name: 'Japanese Yen', flag: '🇯🇵', isCrypto: false),
  Currency(code: 'CHF', name: 'Swiss Franc', flag: '🇨🇭', isCrypto: false),
  Currency(code: 'CAD', name: 'Canadian Dollar', flag: '🇨🇦', isCrypto: false),
  Currency(code: 'AUD', name: 'Australian Dollar', flag: '🇦🇺', isCrypto: false),
  Currency(code: 'CNY', name: 'Chinese Yuan', flag: '🇨🇳', isCrypto: false),
  Currency(code: 'INR', name: 'Indian Rupee', flag: '🇮🇳', isCrypto: false),
  Currency(code: 'SEK', name: 'Swedish Krona', flag: '🇸🇪', isCrypto: false),
  Currency(code: 'SGD', name: 'Singapore Dollar', flag: '🇸🇬', isCrypto: false),
  Currency(code: 'TRY', name: 'Turkish Lira', flag: '🇹🇷', isCrypto: false),
];

// coinGeckoId is the id CoinGecko's API expects, which isn't always the
// same as the ticker symbol.
const List<Currency> cryptoCurrencies = [
  Currency(code: 'BTC', name: 'Bitcoin', flag: '₿', isCrypto: true, coinGeckoId: 'bitcoin'),
  Currency(code: 'ETH', name: 'Ethereum', flag: 'Ξ', isCrypto: true, coinGeckoId: 'ethereum'),
  Currency(code: 'USDT', name: 'Tether', flag: '₮', isCrypto: true, coinGeckoId: 'tether'),
  Currency(code: 'BNB', name: 'BNB', flag: '◆', isCrypto: true, coinGeckoId: 'binancecoin'),
  Currency(code: 'SOL', name: 'Solana', flag: '◎', isCrypto: true, coinGeckoId: 'solana'),
  Currency(code: 'XRP', name: 'XRP', flag: '✕', isCrypto: true, coinGeckoId: 'ripple'),
  Currency(code: 'ADA', name: 'Cardano', flag: '❖', isCrypto: true, coinGeckoId: 'cardano'),
  Currency(code: 'DOGE', name: 'Dogecoin', flag: 'Ð', isCrypto: true, coinGeckoId: 'dogecoin'),
];

const List<Currency> allCurrencies = [...fiatCurrencies, ...cryptoCurrencies];

Currency currencyByCode(String code) {
  return allCurrencies.firstWhere((c) => c.code == code);
}
