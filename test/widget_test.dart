import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:rateflow/main.dart';

void main() {
  testWidgets('App starts on the Convert tab', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});

    await tester.pumpWidget(const RateFlowApp());
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Convert'), findsWidgets);
  });
}
