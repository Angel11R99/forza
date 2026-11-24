import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:forza/app/theme/app_colors.dart';

void main() {
  test(
    'theme text and primary controls meet WCAG AA contrast in both themes',
    () {
      for (final colors in [AppColors.light, AppColors.dark]) {
        for (final surface in [
          colors.background,
          colors.surface,
          colors.surfaceMuted,
        ]) {
          expect(
            _contrastRatio(colors.textPrimary, surface),
            greaterThanOrEqualTo(4.5),
          );
          expect(
            _contrastRatio(colors.textSecondary, surface),
            greaterThanOrEqualTo(4.5),
          );
        }
        expect(
          _contrastRatio(colors.inverseText, colors.accent),
          greaterThanOrEqualTo(4.5),
        );
        expect(
          _contrastRatio(colors.accent, colors.background),
          greaterThanOrEqualTo(4.5),
        );
      }
    },
  );
}

double _contrastRatio(Color first, Color second) {
  final luminances = [first.computeLuminance(), second.computeLuminance()]
    ..sort((a, b) => b.compareTo(a));
  return (luminances.first + 0.05) / (luminances.last + 0.05);
}
