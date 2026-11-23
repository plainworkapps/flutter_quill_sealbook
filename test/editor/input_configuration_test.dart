import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late QuillController controller;

  setUp(() {
    controller = QuillController.basic();
  });

  tearDown(() {
    controller.dispose();
  });

  Future<Map<String, Object?>> clientArgs(
    WidgetTester tester,
    QuillEditorConfig config,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: QuillEditor(
          focusNode: FocusNode(),
          scrollController: ScrollController(),
          controller: controller,
          config: config,
        ),
      ),
    );
    await tester.tap(find.byType(QuillEditor));
    await tester.pumpAndSettle();
    expect(tester.testTextInput.hasAnyClients, isTrue);
    return Map<String, Object?>.from(tester.testTextInput.setClientArgs!);
  }

  group('input configuration', () {
    testWidgets('defaults keep the previous behavior', (tester) async {
      final args = await clientArgs(tester, const QuillEditorConfig());
      expect(args['enableIMEPersonalizedLearning'], isTrue);
      expect(args['autocorrect'], isTrue);
      expect(args['enableSuggestions'], isTrue);
    });

    testWidgets('are passed to the platform text input', (tester) async {
      final args = await clientArgs(
        tester,
        const QuillEditorConfig(
          enableIMEPersonalizedLearning: false,
          autocorrect: false,
          enableSuggestions: false,
        ),
      );
      expect(args['enableIMEPersonalizedLearning'], isFalse);
      expect(args['autocorrect'], isFalse);
      expect(args['enableSuggestions'], isFalse);
    });

    testWidgets('copyWith keeps and replaces the settings', (tester) async {
      const config = QuillEditorConfig(
        enableIMEPersonalizedLearning: false,
        autocorrect: false,
      );
      expect(config.copyWith().enableIMEPersonalizedLearning, isFalse);
      expect(config.copyWith().autocorrect, isFalse);
      expect(
        config
            .copyWith(enableIMEPersonalizedLearning: true)
            .enableIMEPersonalizedLearning,
        isTrue,
      );
      expect(
        config.copyWith(enableSuggestions: false).enableSuggestions,
        isFalse,
      );
    });
  });
}
