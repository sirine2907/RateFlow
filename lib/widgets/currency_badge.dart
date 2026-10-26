import 'package:flutter/material.dart';
import '../models/currency.dart';

// A small colored circle with the currency's first letter, used in
// place of a flag icon everywhere a currency is shown.
class CurrencyBadge extends StatelessWidget {
  final Currency currency;
  final double size;

  const CurrencyBadge(this.currency, {super.key, this.size = 22});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: size / 2,
      backgroundColor: currency.color,
      child: Text(
        currency.code.substring(0, 1),
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: size * 0.5,
        ),
      ),
    );
  }
}
