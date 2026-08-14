import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:uasleep/app/app.dart';

import '../helpers/fakes.dart';

void main() {
  testWidgets('renders the 10-inch tablet store screenshot', (
    WidgetTester tester,
  ) async {
    await _loadFont(
      'Roboto',
      r'C:\flutter\bin\cache\artifacts\material_fonts\roboto-regular.ttf',
    );
    await _loadFont(
      'Ahem',
      r'C:\flutter\bin\cache\artifacts\material_fonts\roboto-regular.ttf',
    );
    await _loadFont(
      'MaterialIcons',
      r'C:\flutter\bin\cache\artifacts\material_fonts\materialicons-regular.otf',
    );
    tester.view.physicalSize = const Size(1440, 2560);
    tester.view.devicePixelRatio = 1;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      UAsleepApp(
        settingsRepository: MemorySettingsRepository(),
        historyRepository: MemoryCalculationHistoryRepository(),
        feedbackLauncher: FakeFeedbackLauncher(),
        appInfoProvider: const FakeAppInfoProvider(),
        resultExporter: FakeResultExporter(),
      ),
    );
    await tester.pumpAndSettle();

    await expectLater(
      find.byType(Scaffold),
      matchesGoldenFile(
        '../../../release/play-store/tablet-home-1440x2560.png',
      ),
    );
  });
}

Future<void> _loadFont(String family, String path) async {
  final Uint8List bytes = File(path).readAsBytesSync();
  await (FontLoader(
    family,
  )..addFont(Future.value(ByteData.sublistView(bytes)))).load();
}
