import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/favorite_pair.dart';
import '../providers/converter_provider.dart';
import '../providers/favorites_provider.dart';
import '../providers/nav_provider.dart';
import '../services/rate_service.dart';
import '../utils/currency_list.dart';

class FavoritesScreen extends StatefulWidget {
  final RateService? rateService;

  const FavoritesScreen({super.key, this.rateService});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  late final RateService _rateService;

  @override
  void initState() {
    super.initState();
    _rateService = widget.rateService ?? RateService();
  }

  @override
  Widget build(BuildContext context) {
    final favorites = context.watch<FavoritesProvider>().favorites;

    return Scaffold(
      appBar: AppBar(title: const Text('Favorites')),
      body: SafeArea(
        child: favorites.isEmpty
            ? const Center(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: Text(
                    'No favorites yet. Tap the star on the Convert tab '
                    'to save a currency pair here.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: favorites.length,
                itemBuilder: (context, index) => _favoriteTile(context, favorites[index]),
              ),
      ),
    );
  }

  Widget _favoriteTile(BuildContext context, FavoritePair pair) {
    final from = currencyByCode(pair.fromCode);
    final to = currencyByCode(pair.toCode);

    return Card(
      child: ListTile(
        leading: Text('${from.flag} → ${to.flag}', style: const TextStyle(fontSize: 18)),
        title: Text('${from.code} → ${to.code}'),
        subtitle: FutureBuilder<double>(
          future: _rateService.getRate(from, to),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Text('Loading...');
            }
            if (snapshot.hasError) {
              return const Text('Rate unavailable');
            }
            final rate = snapshot.data!;
            return Text('1 ${from.code} = ${rate.toStringAsFixed(to.isCrypto ? 6 : 4)} ${to.code}');
          },
        ),
        trailing: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.read<FavoritesProvider>().toggle(pair.fromCode, pair.toCode),
        ),
        onTap: () {
          final converter = context.read<ConverterProvider>();
          converter.setFrom(from);
          converter.setTo(to);
          context.read<NavProvider>().goTo(0);
        },
      ),
    );
  }
}
