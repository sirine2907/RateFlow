import 'package:flutter_test/flutter_test.dart';

import 'package:rateflow/main.dart';

void main() {
  testWidgets('App starts on the Convert tab', (WidgetTester tester) async {
    await tester.pumpWidget(const RateFlowApp());
    await tester.pumpAndSettle();

    expect(find.text('Convert'), findsWidgets);
  });
}
