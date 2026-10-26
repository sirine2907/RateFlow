import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/favorite_pair.dart';

class FavoritesProvider extends ChangeNotifier {
  static const _prefsKey = 'favorite_pairs';

  List<FavoritePair> _favorites = [];
  List<FavoritePair> get favorites => _favorites;

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_prefsKey) ?? [];
    _favorites = raw
        .map((entry) => FavoritePair.fromJson(jsonDecode(entry)))
        .toList();
    notifyListeners();
  }

  bool isFavorite(String fromCode, String toCode) {
    return _favorites.contains(FavoritePair(fromCode, toCode));
  }

  Future<void> toggle(String fromCode, String toCode) async {
    final pair = FavoritePair(fromCode, toCode);
    if (_favorites.contains(pair)) {
      _favorites.remove(pair);
    } else {
      _favorites.add(pair);
    }
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      _prefsKey,
      _favorites.map((p) => jsonEncode(p.toJson())).toList(),
    );
  }
}
