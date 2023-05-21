import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:patrol/patrol.dart';
import 'package:my_first_getx_project/main.dart' as app;

void main() {
  patrolTest(
    'app test with patrol test drag',
    ($) async {
      // Replace later with your app's main widget

      app.main();
      await $.pumpAndSettle();

      $.printInfo(info: "app ready");
      // await $.native.pressHome();
      // await $.native.pressDoubleRecentApps();
      //
      // await $.native.openNotifications();
      //
      // await $.native.enableWifi();
      // await $.native.disableWifi();
      // await $.native.enableWifi();
      //
      // await $.native.enableCellular();
      // await $.native.disableCellular();
      // await $.native.enableCellular();
      //
      // await $.native.enableDarkMode();
      // await $.native.disableDarkMode();
      // await $.native.enableDarkMode();
      //
      // await $.native.pressBack();

      expect(find.text('sliver'), findsOneWidget);

      await $.tap(find.text('sliver'));

      await $.pumpAndSettle(
          // const Duration(seconds: ),
          );
      expect(find.text('Ignacio Zhang'), findsOneWidget);
      expect(find.textContaining('下拉刷新'), findsOneWidget);
      await $.tester.fling(find.textContaining('下拉刷新'), Offset(0, 300), 3000);

      await $.pumpAndSettle();

      expect(find.text('科教館'), findsOneWidget);
    },
    nativeAutomation: true,
  );
}
