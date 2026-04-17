import 'package:bt_cuoi_ky/main.dart';
import 'package:bt_cuoi_ky/screen/splash_onboarding.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('renders splash screen shell', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pump();

    expect(find.byType(SplashScreen), findsOneWidget);
  });
}
