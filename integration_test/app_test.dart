import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:my_first_getx_project/main.dart' as app;

void main() {
  final IntegrationTestWidgetsFlutterBinding binding =
      IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  //Build the app
  app.main();
  group('end to end test', () {
    testWidgets('home page', (WidgetTester tester) async {
      await tester.pumpAndSettle();

      await tester.idle();
      tester.printToConsole("message: tester.idle();");

      expect(find.text('sliver'), findsOneWidget);

      await tester.tap(find.text('sliver'));

      await tester.pumpAndSettle(
          // const Duration(seconds: ),
          );
      expect(find.text('Ignacio Zhang'), findsOneWidget);
      expect(find.textContaining('下拉刷新'), findsOneWidget);
      await tester.drag(
        find.textContaining('下拉刷新'),
        Offset(0, 300),
      );

      await tester.pumpAndSettle();

      tester.printToConsole("message: tester.idle();");
      expect(find.text('科教館'), findsOneWidget);
      tester.printToConsole("message: tester.idle();");
    });
  });
}
