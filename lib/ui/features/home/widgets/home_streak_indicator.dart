import 'package:material_ui/material_ui.dart';
import 'package:streak_flame/streak_flame.dart';

import '../../../../app/localization/localization_extensions.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';

class HomeStreakIndicator extends StatelessWidget {
  const HomeStreakIndicator({
    required this.days,
    required this.animationFrom,
    required this.animationRevision,
    super.key,
  });

  final int days;
  final int animationFrom;
  final int animationRevision;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final label = context.l10n.homeStreakSemantics(days);
    final animate = animationRevision > 0 && animationFrom < days;
    final tierColor = _coolStreakColor(days);
    final flameBase = isDark
        ? Color.lerp(tierColor, colors.textPrimary, 0.2)!
        : tierColor;
    const flameCore = Color(0xFFF4F8FC);
    final palette = StreakPalette(
      flameBase: flameBase,
      flameMiddle: Color.lerp(flameBase, flameCore, 0.35)!,
      flameTip: Color.lerp(flameBase, flameCore, 0.7)!,
      flameCore: flameCore,
      accent: flameBase,
      surface: colors.surface,
      foreground: colors.textPrimary,
      secondaryForeground: colors.textSecondary,
      flameGlow: Colors.transparent,
      flameGlowSecondary: Colors.transparent,
      particlePrimary: flameBase,
      particleSecondary: Color.lerp(flameBase, flameCore, 0.55)!,
      badgeBackground: colors.surface,
      badgeHighlight: colors.surfaceMuted,
      badgeBorder: flameBase,
      badgeGlow: Colors.transparent,
      badgeOldNumber: colors.textSecondary,
      badgeNumber: isDark
          ? Color.lerp(flameBase, colors.textPrimary, 0.12)!
          : Color.lerp(flameBase, colors.textPrimary, 0.36)!,
      badgeLabel: colors.textSecondary,
    );

    return Semantics(
      label: label,
      child: ExcludeSemantics(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              key: const ValueKey('home-streak-flame'),
              width: 82,
              height: 82,
              child: FittedBox(
                fit: BoxFit.contain,
                child: StreakWidget(
                  key: ValueKey(animationRevision),
                  oldStreak: animate ? animationFrom : days,
                  newStreak: days,
                  size: 128,
                  autoStart: animate,
                  transitionDelay: Duration.zero,
                  transitionDuration: const Duration(milliseconds: 900),
                  idleDuration: const Duration(milliseconds: 2600),
                  idleAnimationEnabled: true,
                  respectReducedMotion: true,
                  showGlow: false,
                  showParticles: false,
                  particleCount: 0,
                  palette: palette,
                  flameStyle: const StreakFlameStyle(
                    glowRadius: 0,
                    particleSize: 0,
                  ),
                  badgeStyle: const StreakBadgeStyle(
                    borderWidth: 2,
                    shadows: [],
                    glowBlurRadius: 0,
                  ),
                  strings: StreakStrings(
                    day: context.l10n.homeStreakDay,
                    days: context.l10n.homeStreakDays,
                    badge: context.l10n.homeStreakCurrent,
                  ),
                  unitLabelBuilder: (count) => count == 1
                      ? context.l10n.homeStreakDay
                      : context.l10n.homeStreakDays,
                  semanticsLabel: label,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.x2),
            Flexible(
              child: Column(
                key: const ValueKey('home-streak-labels'),
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    context.l10n.homeStreakCurrent,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: AppSpacing.x1),
                  Text(
                    context.l10n.homeStreakCount(days),
                    style: Theme.of(context).textTheme.bodyMedium
                        ?.copyWith(color: colors.textSecondary),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Color _coolStreakColor(int days) {
  if (days >= 100) return const Color(0xFF8B5CF6);
  if (days >= 60) return const Color(0xFF3B82F6);
  if (days >= 30) return const Color(0xFF14B8A6);
  if (days >= 14) return const Color(0xFF06B6D4);
  if (days >= 7) return const Color(0xFF0EA5E9);
  return const Color(0xFF64748B);
}
