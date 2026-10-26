import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/currency.dart';
import '../providers/converter_provider.dart';
import '../providers/favorites_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/currency_picker_sheet.dart';

class ConvertScreen extends StatefulWidget {
  const ConvertScreen({super.key});

  @override
  State<ConvertScreen> createState() => _ConvertScreenState();
}

class _ConvertScreenState extends State<ConvertScreen> {
  final _amountController = TextEditingController(text: '1');

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final converter = context.watch<ConverterProvider>();
    final favorites = context.watch<FavoritesProvider>();
    final isFav = favorites.isFavorite(converter.from.code, converter.to.code);

    return Scaffold(
      appBar: AppBar(
        title: const Text('RateFlow'),
        actions: [
          IconButton(
            icon: Icon(isFav ? Icons.star : Icons.star_border),
            color: isFav ? AppColors.coral : null,
            onPressed: () => favorites.toggle(converter.from.code, converter.to.code),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _currencyCard(
                context: context,
                label: 'Amount',
                currency: converter.from,
                amountController: _amountController,
                editable: true,
                onPickCurrency: () async {
                  final picked = await showCurrencyPicker(context);
                  if (picked != null) converter.setFrom(picked);
                },
              ),
              const SizedBox(height: 8),
              Center(
                child: IconButton.filled(
                  onPressed: converter.swap,
                  icon: const Icon(Icons.swap_vert),
                ),
              ),
              const SizedBox(height: 8),
              _currencyCard(
                context: context,
                label: 'Converted amount',
                currency: converter.to,
                displayValue: _formatResult(converter),
                editable: false,
                onPickCurrency: () async {
                  final picked = await showCurrencyPicker(context);
                  if (picked != null) converter.setTo(picked);
                },
              ),
              const SizedBox(height: 16),
              if (converter.isLoading)
                const Center(child: CircularProgressIndicator())
              else if (converter.error != null)
                Text(converter.error!, style: const TextStyle(color: Colors.red))
              else if (converter.isFromCache)
                const Text(
                  'Showing last saved rate - you seem to be offline.',
                  style: TextStyle(color: Colors.grey),
                )
              else
                Text(
                  '1 ${converter.from.code} = ${_formatRate(converter)} ${converter.to.code}',
                  style: const TextStyle(color: Colors.grey),
                ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatResult(ConverterProvider converter) {
    if (converter.result == null) return '-';
    return converter.result!.toStringAsFixed(converter.to.isCrypto ? 6 : 2);
  }

  String _formatRate(ConverterProvider converter) {
    if (converter.result == null || converter.amount == 0) return '-';
    final rate = converter.result! / converter.amount;
    return rate.toStringAsFixed(converter.to.isCrypto ? 6 : 4);
  }

  Widget _currencyCard({
    required BuildContext context,
    required String label,
    required Currency currency,
    required bool editable,
    required VoidCallback onPickCurrency,
    TextEditingController? amountController,
    String? displayValue,
  }) {
    final converter = context.read<ConverterProvider>();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 8),
            Row(
              children: [
                OutlinedButton.icon(
                  onPressed: onPickCurrency,
                  icon: Text(currency.flag, style: const TextStyle(fontSize: 18)),
                  label: Text(currency.code),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: editable
                      ? TextField(
                          controller: amountController,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          textAlign: TextAlign.right,
                          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                          decoration: const InputDecoration(border: InputBorder.none),
                          onChanged: (value) {
                            final parsed = double.tryParse(value);
                            if (parsed != null) converter.setAmount(parsed);
                          },
                        )
                      : Text(
                          displayValue ?? '-',
                          textAlign: TextAlign.right,
                          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                        ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
