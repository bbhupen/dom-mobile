import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:dom_mobile/app/drone_ops_app.dart';

void main() {
  testWidgets('shows sign in screen', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});

    await tester.pumpWidget(const DroneOpsApp());
    await tester.pumpAndSettle();

    expect(find.text('Sign in'), findsWidgets);
    expect(find.text('DRONE OPERATIONS'), findsOneWidget);
  });
}
