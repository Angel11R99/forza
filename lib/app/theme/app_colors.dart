import 'package:material_ui/material_ui.dart';

@immutable
class AppColors extends ThemeExtension<AppColors> {
  const AppColors({
    required this.background,
    required this.surface,
    required this.surfaceMuted,
    required this.textPrimary,
    required this.textSecondary,
    required this.divider,
    required this.accent,
    required this.accentSoft,
    required this.success,
    required this.inverseSurface,
    required this.inverseText,
  });

  static const light = AppColors(
    background: Color(0xFFF7F7F7),
    surface: Color(0xFFFFFFFF),
    surfaceMuted: Color(0xFFEFEFEF),
    textPrimary: Color(0xFF111111),
    textSecondary: Color(0xFF5F5F5F),
    divider: Color(0xFFD9D9D9),
    accent: Color(0xFF111111),
    accentSoft: Color(0xFFE7E7E7),
    success: Color(0xFF111111),
    inverseSurface: Color(0xFF111111),
    inverseText: Color(0xFFFFFFFF),
  );

  static const dark = AppColors(
    background: Color(0xFF101112),
    surface: Color(0xFF191A1C),
    surfaceMuted: Color(0xFF242629),
    textPrimary: Color(0xFFF5F5F5),
    textSecondary: Color(0xFFB8BABD),
    divider: Color(0xFF383A3D),
    accent: Color(0xFFF5F5F5),
    accentSoft: Color(0xFF33363A),
    success: Color(0xFFF5F5F5),
    inverseSurface: Color(0xFFF5F5F5),
    inverseText: Color(0xFF111111),
  );

  final Color background;
  final Color surface;
  final Color surfaceMuted;
  final Color textPrimary;
  final Color textSecondary;
  final Color divider;
  final Color accent;
  final Color accentSoft;
  final Color success;
  final Color inverseSurface;
  final Color inverseText;

  @override
  AppColors copyWith({
    Color? background,
    Color? surface,
    Color? surfaceMuted,
    Color? textPrimary,
    Color? textSecondary,
    Color? divider,
    Color? accent,
    Color? accentSoft,
    Color? success,
    Color? inverseSurface,
    Color? inverseText,
  }) => AppColors(
    background: background ?? this.background,
    surface: surface ?? this.surface,
    surfaceMuted: surfaceMuted ?? this.surfaceMuted,
    textPrimary: textPrimary ?? this.textPrimary,
    textSecondary: textSecondary ?? this.textSecondary,
    divider: divider ?? this.divider,
    accent: accent ?? this.accent,
    accentSoft: accentSoft ?? this.accentSoft,
    success: success ?? this.success,
    inverseSurface: inverseSurface ?? this.inverseSurface,
    inverseText: inverseText ?? this.inverseText,
  );

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) return this;
    return AppColors(
      background: Color.lerp(background, other.background, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      surfaceMuted: Color.lerp(surfaceMuted, other.surfaceMuted, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      divider: Color.lerp(divider, other.divider, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      accentSoft: Color.lerp(accentSoft, other.accentSoft, t)!,
      success: Color.lerp(success, other.success, t)!,
      inverseSurface: Color.lerp(inverseSurface, other.inverseSurface, t)!,
      inverseText: Color.lerp(inverseText, other.inverseText, t)!,
    );
  }
}

extension AppColorsContext on BuildContext {
  AppColors get appColors => Theme.of(this).extension<AppColors>()!;
}
