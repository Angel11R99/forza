import 'package:material_ui/material_ui.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../core/widgets/app_surface_card.dart';
import '../models/profile_settings.dart';
import 'profile_settings_pages.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  ForzaProfile _profile = const ForzaProfile(
    fullName: 'Atleta FORZA',
    email: 'atleta@forza.demo',
    goal: 'Ganar fuerza',
  );
  TrainingSettings _trainingSettings = const TrainingSettings();
  AppPreferences _preferences = const AppPreferences();
  NotificationSettings _notifications = const NotificationSettings();
  PrivacySettings _privacy = const PrivacySettings();

  @override
  Widget build(BuildContext context) {
    final horizontalPadding = MediaQuery.sizeOf(context).width < 380
        ? AppSpacing.x4
        : AppSpacing.x6;

    return CustomScrollView(
      key: const PageStorageKey<String>('profile-scroll'),
      slivers: [
        SliverPadding(
          padding: EdgeInsets.fromLTRB(
            horizontalPadding,
            AppSpacing.x6,
            horizontalPadding,
            AppSpacing.x8,
          ),
          sliver: SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'TU ESPACIO PERSONAL',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 11,
                    letterSpacing: 1.3,
                  ),
                ),
                const SizedBox(height: AppSpacing.x2),
                Text('Perfil', style: Theme.of(context).textTheme.displaySmall),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  'Ajusta FORZA a tu manera.',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: AppSpacing.x4),
                const _DemoBadge(),
                const SizedBox(height: AppSpacing.x8),
                AppSurfaceCard(
                  padding: const EdgeInsets.all(AppSpacing.x6),
                  child: Row(
                    children: [
                      Container(
                        width: 64,
                        height: 64,
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                          color: AppColors.textPrimary,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          _initials(_profile.fullName),
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(color: AppColors.inverseText),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.x4),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _profile.fullName,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(height: AppSpacing.x1),
                            Text(
                              _profile.email,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            const SizedBox(height: AppSpacing.x2),
                            Text(
                              _profile.goal,
                              style: Theme.of(context).textTheme.labelLarge,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.x8),
                Text(
                  'Cuenta y preferencias',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: AppSpacing.x3),
                _ProfileOption(
                  icon: Icons.badge_outlined,
                  title: 'Editar perfil',
                  subtitle: 'Nombre, correo y objetivo',
                  onTap: _editProfile,
                ),
                const SizedBox(height: AppSpacing.x2),
                _ProfileOption(
                  icon: Icons.fitness_center_outlined,
                  title: 'Entrenamiento',
                  subtitle:
                      '${_trainingSettings.daysPerWeek} días · ${_trainingSettings.sessionMinutes} min · ${_trainingSettings.goal}',
                  onTap: _editTrainingSettings,
                ),
                const SizedBox(height: AppSpacing.x2),
                _ProfileOption(
                  icon: Icons.tune_rounded,
                  title: 'Preferencias',
                  subtitle:
                      'Unidades ${_preferences.weightUnit} · semana desde ${_preferences.weekStartsOn.toLowerCase()}',
                  onTap: _editPreferences,
                ),
                const SizedBox(height: AppSpacing.x2),
                _ProfileOption(
                  icon: Icons.notifications_none_rounded,
                  title: 'Notificaciones',
                  subtitle: _notifications.workoutReminders
                      ? 'Recordatorio ${_formatTime(_notifications.reminderHour, _notifications.reminderMinute)}'
                      : 'Recordatorios desactivados',
                  onTap: _editNotifications,
                ),
                const SizedBox(height: AppSpacing.x2),
                _ProfileOption(
                  icon: Icons.lock_outline_rounded,
                  title: 'Privacidad y cuenta',
                  subtitle: _privacy.privateProfile
                      ? 'Perfil privado'
                      : 'Perfil visible',
                  onTap: _editPrivacy,
                ),
                const SizedBox(height: AppSpacing.x6),
                Text(
                  'Los cambios de demostración se mantienen solo mientras esta app permanece abierta.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _editProfile() async {
    final updated = await Navigator.of(context).push<ForzaProfile>(
      MaterialPageRoute<ForzaProfile>(
        builder: (_) => ProfileEditPage(profile: _profile),
      ),
    );
    if (updated == null || !mounted) return;
    setState(() => _profile = updated);
  }

  Future<void> _editTrainingSettings() async {
    final updated = await Navigator.of(context).push<TrainingSettings>(
      MaterialPageRoute<TrainingSettings>(
        builder: (_) => TrainingSettingsPage(settings: _trainingSettings),
      ),
    );
    if (updated == null || !mounted) return;
    setState(() => _trainingSettings = updated);
  }

  Future<void> _editPreferences() async {
    final updated = await Navigator.of(context).push<AppPreferences>(
      MaterialPageRoute<AppPreferences>(
        builder: (_) => AppPreferencesPage(preferences: _preferences),
      ),
    );
    if (updated == null || !mounted) return;
    setState(() => _preferences = updated);
  }

  Future<void> _editNotifications() async {
    final updated = await Navigator.of(context).push<NotificationSettings>(
      MaterialPageRoute<NotificationSettings>(
        builder: (_) => NotificationsSettingsPage(settings: _notifications),
      ),
    );
    if (updated == null || !mounted) return;
    setState(() => _notifications = updated);
  }

  Future<void> _editPrivacy() async {
    final updated = await Navigator.of(context).push<PrivacySettings>(
      MaterialPageRoute<PrivacySettings>(
        builder: (_) =>
            PrivacyAccountPage(settings: _privacy, profile: _profile),
      ),
    );
    if (updated == null || !mounted) return;
    setState(() => _privacy = updated);
  }
}

class _ProfileOption extends StatelessWidget {
  const _ProfileOption({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppSurfaceCard(
      padding: EdgeInsets.zero,
      child: Semantics(
        button: true,
        label: '$title, $subtitle',
        child: ExcludeSemantics(
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(AppRadius.medium),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.x4,
                vertical: AppSpacing.x3,
              ),
              child: Row(
                children: [
                  Icon(icon, size: 22),
                  const SizedBox(width: AppSpacing.x4),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: AppSpacing.x1),
                        Text(
                          subtitle,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppSpacing.x2),
                  const Icon(Icons.chevron_right_rounded),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DemoBadge extends StatelessWidget {
  const _DemoBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x3,
        vertical: AppSpacing.x2,
      ),
      decoration: BoxDecoration(
        color: AppColors.surfaceMuted,
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Text(
        'DATOS DE EJEMPLO',
        style: Theme.of(context).textTheme.labelLarge
            ?.copyWith(fontSize: 10, letterSpacing: 1),
      ),
    );
  }
}

String _initials(String name) {
  final parts = name
      .trim()
      .split(RegExp(r'\s+'))
      .where((part) => part.isNotEmpty);
  final initials = parts.take(2).map((part) => part[0].toUpperCase()).join();
  return initials.isEmpty ? 'F' : initials;
}

String _formatTime(int hour, int minute) =>
    '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
