import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/chart_point.dart';
import '../models/currency.dart';
import '../services/rate_service.dart';
import '../theme/app_theme.dart';
import '../utils/currency_list.dart';
import '../widgets/currency_picker_sheet.dart';

class _Period {
  final String label;
  final int days;
  const _Period(this.label, this.days);
}

const _periods = [
  _Period('7D', 7),
  _Period('1M', 30),
  _Period('3M', 90),
  _Period('1Y', 365),
];

class ChartScreen extends StatefulWidget {
  const ChartScreen({super.key});

  @override
  State<ChartScreen> createState() => _ChartScreenState();
}

class _ChartScreenState extends State<ChartScreen> {
  final _rateService = RateService();

  Currency _from = currencyByCode('BTC');
  Currency _to = currencyByCode('USD');
  int _periodIndex = 1;

  Future<List<ChartPoint>>? _future;

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() {
    setState(() {
      _future = _rateService.getHistory(_from, _to, _periods[_periodIndex].days);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chart')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(child: _pairButton(_from, () async {
                    final picked = await showCurrencyPicker(context);
                    if (picked != null) {
                      setState(() => _from = picked);
                      _load();
                    }
                  })),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Icon(Icons.arrow_forward),
                  ),
                  Expanded(child: _pairButton(_to, () async {
                    final picked = await showCurrencyPicker(context);
                    if (picked != null) {
                      setState(() => _to = picked);
                      _load();
                    }
                  })),
                ],
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                children: List.generate(_periods.length, (index) {
                  return ChoiceChip(
                    label: Text(_periods[index].label),
                    selected: _periodIndex == index,
                    onSelected: (_) {
                      setState(() => _periodIndex = index);
                      _load();
                    },
                  );
                }),
              ),
              const SizedBox(height: 16),
              Expanded(child: _chartBody()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _pairButton(Currency currency, VoidCallback onTap) {
    return OutlinedButton.icon(
      onPressed: onTap,
      icon: Text(currency.flag, style: const TextStyle(fontSize: 18)),
      label: Text(currency.code),
    );
  }

  Widget _chartBody() {
    return FutureBuilder<List<ChartPoint>>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError || snapshot.data == null || snapshot.data!.isEmpty) {
          return const Center(
            child: Text(
              'Chart not available for this pair.\nTry a fiat-crypto or fiat-fiat pair.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
          );
        }

        final points = snapshot.data!;
        final first = points.first.value;
        final last = points.last.value;
        final change = ((last - first) / first) * 100;
        final isUp = change >= 0;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              last.toStringAsFixed(_to.isCrypto ? 6 : 4),
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            Text(
              '${isUp ? '+' : ''}${change.toStringAsFixed(2)}% over this period',
              style: TextStyle(color: isUp ? Colors.green : Colors.red),
            ),
            const SizedBox(height: 16),
            Expanded(child: _lineChart(points)),
          ],
        );
      },
    );
  }

  Widget _lineChart(List<ChartPoint> points) {
    final spots = <FlSpot>[];
    for (var i = 0; i < points.length; i++) {
      spots.add(FlSpot(i.toDouble(), points[i].value));
    }

    return LineChart(
      LineChartData(
        gridData: const FlGridData(show: false),
        titlesData: FlTitlesData(
          leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 24,
              interval: (points.length / 4).clamp(1, points.length).floorToDouble(),
              getTitlesWidget: (value, meta) {
                final index = value.toInt();
                if (index < 0 || index >= points.length) return const SizedBox.shrink();
                return Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(
                    DateFormat('MMM d').format(points[index].date),
                    style: const TextStyle(fontSize: 10, color: Colors.grey),
                  ),
                );
              },
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: AppColors.coral,
            barWidth: 2,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              color: AppColors.coral.withValues(alpha: 0.15),
            ),
          ),
        ],
      ),
    );
  }
}
