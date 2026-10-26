// Renders the app into docs/screenshots for the README.
// Run: flutter test test/screenshots --update-goldens
@Tags(['screenshots'])
library;

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rateflow/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'fake_rate_service.dart';

// Without loading a real font the test renders every letter as a box.
Future<void> loadFonts() async {
  final inter = FontLoader('Inter')
    ..addFont(rootBundle.load('assets/fonts/Inter.ttf'));
  final icons = FontLoader('MaterialIcons')
    ..addFont(rootBundle.load('fonts/MaterialIcons-Regular.otf'));
  await Future.wait([inter.load(), icons.load()]);
}

final seededFavorites = [
  jsonEncode({'from': 'BTC', 'to': 'USD'}),
  jsonEncode({'from': 'EUR', 'to': 'GBP'}),
];

Future<void> openApp(
  WidgetTester tester, {
  Size size = const Size(412, 915),
  bool darkMode = false,
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  SharedPreferences.setMockInitialValues({
    'favorite_pairs': seededFavorites,
    'dark_mode': darkMode,
  });

  await tester.pumpWidget(RateFlowApp(rateService: FakeRateService()));
  await settle(tester);
}

// shared_preferences answers outside the fake clock, so give it real time.
Future<void> settle(WidgetTester tester) async {
  for (var i = 0; i < 3; i++) {
    await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 50)));
    await tester.pumpAndSettle();
  }
}

Future<void> takeScreenshot(String name) async {
  await expectLater(
    find.byType(MaterialApp),
    matchesGoldenFile('../../docs/screenshots/$name.png'),
  );
}

final windows = TargetPlatformVariant.only(TargetPlatform.windows);

void main() {
  setUpAll(loadFonts);

  testWidgets('convert screen', (tester) async {
    await openApp(tester);
    await takeScreenshot('01_convert');
  }, variant: windows);

  testWidgets('currency picker', (tester) async {
    await openApp(tester);
    await tester.tap(find.widgetWithText(OutlinedButton, 'USD'));
    await settle(tester);
    await takeScreenshot('02_currency_picker');
  }, variant: windows);

  testWidgets('chart screen', (tester) async {
    await openApp(tester);
    await tester.tap(find.text('Chart'));
    await settle(tester);
    await takeScreenshot('03_chart');
  }, variant: windows);

  testWidgets('favorites screen', (tester) async {
    await openApp(tester);
    await tester.tap(find.text('Favorites'));
    await settle(tester);
    await takeScreenshot('04_favorites');
  }, variant: windows);

  testWidgets('dark mode', (tester) async {
    await openApp(tester, darkMode: true);
    await takeScreenshot('05_dark_mode');
  }, variant: windows);
}
