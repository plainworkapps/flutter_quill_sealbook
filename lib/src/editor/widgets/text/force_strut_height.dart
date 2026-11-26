import 'package:flutter/widgets.dart';

/// Makes every line of the editor below it exactly as tall as its strut (the
/// line's style height), whatever the line holds: a taller fallback glyph, an
/// emoji, or nothing at all (an empty line is sized by the strut alone, which
/// the engine can round a pixel taller than text of the same style).
///
/// Off by default, which is the editor's behavior without this widget. An app
/// that sets every line to a fixed height, to sit text on ruled lines, wraps the
/// editor in this.
class QuillForceStrutHeight extends InheritedWidget {
  const QuillForceStrutHeight({
    required super.child,
    this.force = true,
    super.key,
  });

  final bool force;

  /// Whether lines below [context] are forced to their strut height.
  static bool of(BuildContext context) =>
      context
          .dependOnInheritedWidgetOfExactType<QuillForceStrutHeight>()
          ?.force ??
      false;

  @override
  bool updateShouldNotify(QuillForceStrutHeight oldWidget) =>
      oldWidget.force != force;
}
