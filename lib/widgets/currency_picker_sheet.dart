import 'package:flutter/material.dart';
import '../models/currency.dart';
import '../utils/currency_list.dart';
import 'currency_badge.dart';

// Bottom sheet that lets the user pick a currency, with fiat and
// crypto shown as two separate sections.
Future<Currency?> showCurrencyPicker(BuildContext context) {
  return showModalBottomSheet<Currency>(
    context: context,
    isScrollControlled: true,
    builder: (context) => const _CurrencyPickerSheet(),
  );
}

class _CurrencyPickerSheet extends StatefulWidget {
  const _CurrencyPickerSheet();

  @override
  State<_CurrencyPickerSheet> createState() => _CurrencyPickerSheetState();
}

class _CurrencyPickerSheetState extends State<_CurrencyPickerSheet> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final query = _query.toLowerCase();
    final fiatResults = fiatCurrencies.where((c) => _matches(c, query)).toList();
    final cryptoResults = cryptoCurrencies.where((c) => _matches(c, query)).toList();

    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      minChildSize: 0.5,
      maxChildSize: 0.9,
      expand: false,
      builder: (context, scrollController) {
        return Column(
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                autofocus: false,
                decoration: const InputDecoration(
                  hintText: 'Search currency or coin',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) => setState(() => _query = value),
              ),
            ),
            Expanded(
              child: ListView(
                controller: scrollController,
                children: [
                  if (fiatResults.isNotEmpty) _sectionLabel('Fiat currencies'),
                  ...fiatResults.map((c) => _currencyTile(c)),
                  if (cryptoResults.isNotEmpty) _sectionLabel('Crypto'),
                  ...cryptoResults.map((c) => _currencyTile(c)),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  bool _matches(Currency c, String query) {
    if (query.isEmpty) return true;
    return c.code.toLowerCase().contains(query) ||
        c.name.toLowerCase().contains(query);
  }

  Widget _sectionLabel(String label) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        label,
        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
      ),
    );
  }

  Widget _currencyTile(Currency currency) {
    return ListTile(
      leading: CurrencyBadge(currency),
      title: Text(currency.code),
      subtitle: Text(currency.name),
      onTap: () => Navigator.of(context).pop(currency),
    );
  }
}
