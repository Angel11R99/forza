import 'package:material_ui/material_ui.dart';

import 'app_colors.dart';
import 'app_radius.dart';

abstract final class AppTheme {
  static ThemeData get light => _build(AppColors.light, Brightness.light);
  static ThemeData get dark => _build(AppColors.dark, Brightness.dark);

  static ThemeData _build(AppColors colors, Brightness brightness) {
    final colorScheme =
        ColorScheme.fromSeed(
          seedColor: colors.accent,
          brightness: brightness,
        ).copyWith(
          primary: colors.accent,
          onPrimary: colors.inverseText,
          secondary: colors.accent,
          onSecondary: colors.inverseText,
          primaryContainer: colors.accentSoft,
          onPrimaryContainer: colors.accent,
          surface: colors.surface,
          onSurface: colors.textPrimary,
          error: colors.textPrimary,
          onError: colors.inverseText,
        );

    final textTheme = TextTheme(
      displayLarge: TextStyle(
        fontFamily: 'Barlow Condensed',
        color: colors.textPrimary,
        fontSize: 32,
        height: 1.08,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.8,
      ),
      displayMedium: TextStyle(
        fontFamily: 'Barlow Condensed',
        color: colors.textPrimary,
        fontSize: 28,
        height: 1.1,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.65,
      ),
      displaySmall: TextStyle(
        fontFamily: 'Barlow Condensed',
        color: colors.textPrimary,
        fontSize: 28,
        height: 1.12,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.8,
      ),
      headlineLarge: TextStyle(
        fontFamily: 'Barlow Condensed',
        color: colors.textPrimary,
        fontSize: 24,
        height: 1.12,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.45,
      ),
      headlineMedium: TextStyle(
        fontFamily: 'Barlow Condensed',
        color: colors.textPrimary,
        fontSize: 24,
        height: 1.15,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.45,
      ),
      headlineSmall: TextStyle(
        fontFamily: 'Barlow Condensed',
        color: colors.textPrimary,
        fontSize: 24,
        height: 1.18,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.45,
      ),
      titleLarge: TextStyle(
        color: colors.textPrimary,
        fontSize: 18,
        height: 1.2,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.25,
      ),
      titleMedium: TextStyle(
        color: colors.textPrimary,
        fontSize: 16,
        height: 1.25,
        fontWeight: FontWeight.w600,
      ),
      titleSmall: TextStyle(
        color: colors.textPrimary,
        fontSize: 14,
        height: 1.3,
        fontWeight: FontWeight.w600,
      ),
      bodyLarge: TextStyle(
        color: colors.textPrimary,
        fontSize: 16,
        height: 1.45,
      ),
      bodyMedium: TextStyle(
        color: colors.textSecondary,
        fontSize: 14,
        height: 1.4,
        fontWeight: FontWeight.w500,
      ),
      bodySmall: TextStyle(
        color: colors.textSecondary,
        fontSize: 12,
        height: 1.4,
        fontWeight: FontWeight.w500,
      ),
      labelMedium: TextStyle(
        color: colors.textPrimary,
        fontSize: 12,
        height: 1.25,
        fontWeight: FontWeight.w600,
      ),
      labelSmall: TextStyle(
        color: colors.textSecondary,
        fontSize: 12,
        height: 1.25,
        fontWeight: FontWeight.w600,
      ),
      labelLarge: TextStyle(
        color: colors.textPrimary,
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      fontFamily: 'Barlow',
      colorScheme: colorScheme,
      extensions: [colors],
      scaffoldBackgroundColor: colors.background,
      dividerColor: colors.divider,
      visualDensity: VisualDensity.standard,
      iconTheme: IconThemeData(color: colors.textPrimary),
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: colors.background,
        foregroundColor: colors.textPrimary,
        surfaceTintColor: Colors.transparent,
        centerTitle: false,
        scrolledUnderElevation: 0,
        titleTextStyle: textTheme.titleMedium,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: colors.surface.withValues(alpha: 0.96),
        indicatorColor: colors.accentSoft,
        elevation: 0,
        height: 66,
        labelTextStyle: WidgetStateProperty.resolveWith(
          (states) => textTheme.labelSmall!.copyWith(
            color: states.contains(WidgetState.selected)
                ? colors.accent
                : colors.textSecondary,
            fontWeight: states.contains(WidgetState.selected)
                ? FontWeight.w600
                : FontWeight.w500,
          ),
        ),
        iconTheme: WidgetStateProperty.resolveWith(
          (states) => IconThemeData(
            color: states.contains(WidgetState.selected)
                ? colors.accent
                : colors.textSecondary,
          ),
        ),
      ),
      navigationRailTheme: NavigationRailThemeData(
        selectedIconTheme: IconThemeData(color: colors.accent),
        unselectedIconTheme: IconThemeData(color: colors.textSecondary),
        selectedLabelTextStyle: textTheme.labelSmall!.copyWith(
          color: colors.accent,
        ),
        unselectedLabelTextStyle: textTheme.labelSmall,
      ),
      listTileTheme: ListTileThemeData(
        titleTextStyle: textTheme.titleMedium,
        subtitleTextStyle: textTheme.bodyMedium!.copyWith(height: 1.3),
      ),
      dividerTheme: DividerThemeData(
        color: colors.divider,
        thickness: 0.8,
        space: 1,
      ),
      cardTheme: CardThemeData(
        color: colors.surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.medium),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: colors.accent,
          foregroundColor: colors.inverseText,
          minimumSize: Size(48, 50),
          padding: EdgeInsets.symmetric(horizontal: 22, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.small),
          ),
          textStyle: textTheme.titleSmall,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colors.textPrimary,
          minimumSize: Size(48, 50),
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          side: BorderSide(color: colors.divider),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.small),
          ),
          textStyle: textTheme.titleSmall,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colors.surfaceMuted,
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        hintStyle: TextStyle(color: colors.textSecondary),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.control),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.control),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.control),
          borderSide: BorderSide(color: colors.accent, width: 1.5),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: colors.surface,
        selectedColor: colors.accentSoft,
        labelStyle: textTheme.labelMedium!.copyWith(color: colors.textPrimary),
        secondaryLabelStyle: textTheme.labelMedium!.copyWith(
          color: colors.textPrimary,
        ),
        checkmarkColor: colors.accent,
        side: BorderSide(color: colors.divider),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.pill),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: colors.accent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.small),
          ),
        ),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? colors.accent
              : colors.surface,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      ),
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? colors.accent
              : colors.textSecondary,
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? colors.inverseText
              : colors.surface,
        ),
        trackColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? colors.success
              : colors.textSecondary.withValues(alpha: 0.24),
        ),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: colors.accent,
        linearTrackColor: colors.surfaceMuted,
        circularTrackColor: colors.surfaceMuted,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: colors.surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.large),
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: colors.surface,
        surfaceTintColor: Colors.transparent,
        showDragHandle: true,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: colors.inverseSurface,
        contentTextStyle: TextStyle(color: colors.inverseText),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.medium),
        ),
      ),
    );
  }
}
