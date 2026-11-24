import 'dart:async';

import 'package:material_ui/material_ui.dart';

import '../../../../app/localization/device_time_format.dart';
import '../../../../data/repositories/workout_reminder_repository.dart';
import '../../../../data/repositories/profile_settings_repository.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../core/widgets/app_surface_card.dart';
import '../../../core/widgets/forza_brand.dart';
import '../../onboarding/views/account_access_pages.dart';
import '../../onboarding/views/onboarding_view.dart';
import '../../onboarding/view_models/account_auth_view_model.dart';
import '../models/profile_settings.dart';
import 'profile_settings_pages.dart';
import '../../../../app/localization/locale_controller.dart';
import '../../../../app/localization/localization_extensions.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({
    super.key,
    required this.trainingSettings,
    required this.onTrainingSettingsChanged,
    required this.profileSettingsRepository,
    required this.accountAuthViewModel,
    this.onNotificationsChanged,
    required this.themeMode,
    required this.onThemeModeChanged,
    required this.onManageBackups,
    required this.localeController,
  });

  final TrainingSettings trainingSettings;
  final ValueChanged<TrainingSettings> onTrainingSettingsChanged;
  final ThemeMode themeMode;
  final Future<void> Function(ThemeMode) onThemeModeChanged;
  final VoidCallback onManageBackups;
  final LocaleController localeController;
  final ProfileSettingsRepository profileSettingsRepository;
  final AccountAuthViewModel accountAuthViewModel;
  final Future<bool> Function(
    NotificationSettings previous,
    NotificationSettings updated,
  )?
  onNotificationsChanged;

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  ForzaProfile _profile = const ForzaProfile(
    fullName: 'Atleta FORZA',
    goal: 'Ganar fuerza',
  );
  AppPreferences _preferences = const AppPreferences();
  NotificationSettings _notifications = const NotificationSettings();
  PrivacySettings _privacy = const PrivacySettings();
  bool _profileSettingsLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadProfileSettings();
    unawaited(widget.accountAuthViewModel.restore());
  }

  Future<void> _loadProfileSettings() async {
    try {
      final preferences = await widget.profileSettingsRepository
          .loadAppPreferences();
      final notifications = await widget.profileSettingsRepository
          .loadNotifications();
      final privacy = await widget.profileSettingsRepository.loadPrivacy();
      if (!mounted) return;
      setState(() {
        _preferences = preferences;
        _notifications = notifications;
        _privacy = privacy;
        _profileSettingsLoaded = true;
      });
    } on Object {
      if (mounted) setState(() => _profileSettingsLoaded = false);
    }
  }

  Future<bool> _ensureProfileSettingsLoaded() async {
    if (!_profileSettingsLoaded) await _loadProfileSettings();
    if (_profileSettingsLoaded) return true;
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.profileSettingsLoadFailed)),
      );
    }
    return false;
  }

  void _showSettingsSaveError() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(context.l10n.profileSettingsSaveFailed)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final displayProfile = _localizedProfile(context);
    final horizontalPadding = AppSpacing.pageGutter(
      MediaQuery.sizeOf(context).width,
    );
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
                ForzaEyebrow(label: context.l10n.profileEyebrow),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  context.l10n.profileTitle,
                  style: Theme.of(context).textTheme.displaySmall,
                ),
                const SizedBox(height: AppSpacing.x6),
                ListenableBuilder(
                  listenable: widget.accountAuthViewModel,
                  builder: (context, _) {
                    final account = widget.accountAuthViewModel.account;
                    final googleName = account?.displayName?.trim();
                    final displayName = googleName == null || googleName.isEmpty
                        ? displayProfile.fullName
                        : googleName;
                    final photoUrl = account?.photoUrl;
                    return AppSurfaceCard(
                      padding: const EdgeInsets.all(AppSpacing.x4),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundColor: context.appColors.accentSoft,
                            foregroundColor: context.appColors.accent,
                            backgroundImage: photoUrl == null
                                ? null
                                : NetworkImage(photoUrl),
                            child: photoUrl == null
                                ? Text(
                                    _initials(displayName),
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge,
                                  )
                                : null,
                          ),
                          const SizedBox(width: AppSpacing.x4),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  displayName,
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                                const SizedBox(height: AppSpacing.x1),
                                Text(
                                  account?.email ??
                                      context.l10n.profileGuestDescription,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                                const SizedBox(height: AppSpacing.x2),
                                Text(
                                  displayProfile.goal,
                                  style: Theme.of(context).textTheme.labelLarge
                                      ?.copyWith(
                                        color: context.appColors.accent,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: AppSpacing.x8),
                _ProfileSection(
                  title: context.l10n.profileEyebrow,
                  options: [
                    _ProfileOption(
                      icon: Icons.language_rounded,
                      title: context.l10n.settingsLanguageSelection,
                      subtitle:
                          widget.localeController.locale?.languageCode == 'en'
                          ? context.l10n.settingsLanguageEnglish
                          : widget.localeController.locale?.languageCode == 'es'
                          ? context.l10n.settingsLanguageSpanish
                          : context.l10n.settingsLanguageAutomatic,
                      onTap: _editLanguage,
                    ),
                    _ProfileOption(
                      icon: Icons.person_outline_rounded,
                      title: context.l10n.profileEdit,
                      subtitle: context.l10n.profileEditSubtitle,
                      onTap: _editProfile,
                    ),
                    _ProfileOption(
                      icon: Icons.login_rounded,
                      title: context.l10n.profileAccountAccess,
                      subtitle: context.l10n.profileAccountAccessSubtitle,
                      onTap: _openAccountAccess,
                    ),
                    _ProfileOption(
                      icon: Icons.lock_outline_rounded,
                      title: context.l10n.profilePrivacy,
                      subtitle: _privacy.privateProfile
                          ? context.l10n.profilePrivate
                          : context.l10n.profileVisible,
                      onTap: _editPrivacy,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.x6),
                _ProfileSection(
                  title: context.l10n.profileTraining,
                  options: [
                    _ProfileOption(
                      icon: Icons.flag_outlined,
                      title: context.l10n.profileMyPlan,
                      subtitle: context.l10n.profilePlanSummary(
                        _localizedGoal(context, widget.trainingSettings.goal),
                        widget.trainingSettings.daysPerWeek,
                        widget.trainingSettings.sessionMinutes,
                      ),
                      onTap: _configurePlan,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.x6),
                _ProfileSection(
                  title: context.l10n.profilePreferences,
                  options: [
                    _ProfileOption(
                      icon: Icons.palette_outlined,
                      title: context.l10n.profileAppearance,
                      subtitle: _themeModeLabel(context, widget.themeMode),
                      onTap: _editAppearance,
                    ),
                    _ProfileOption(
                      icon: Icons.tune_rounded,
                      title: context.l10n.profilePreferences,
                      subtitle:
                          '${context.l10n.profileWeightUnit(_preferences.weightUnit)} · ${context.l10n.profileWeekStart(_weekStartLabel(context, _preferences.weekStartsOn))} · ${context.l10n.profileHaptics(_preferences.hapticsEnabled ? context.l10n.profileHapticsOn : context.l10n.profileHapticsOff)}',
                      onTap: _editPreferences,
                    ),
                    _ProfileOption(
                      icon: Icons.backup_outlined,
                      title: context.l10n.profileBackup,
                      subtitle: context.l10n.profileBackupSubtitle,
                      onTap: widget.onManageBackups,
                    ),
                    _ProfileOption(
                      icon: Icons.notifications_none_rounded,
                      title: context.l10n.profileNotifications,
                      subtitle: _notifications.workoutReminders
                          ? context.l10n.profileReminderAt(
                              _formatTime(
                                context,
                                _notifications.reminderHour,
                                _notifications.reminderMinute,
                              ),
                            )
                          : context.l10n.profileRemindersOff,
                      onTap: _editNotifications,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.x4),
                Center(
                  child: Text(
                    context.l10n.profileSessionPreferencesNote,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _openAccountAccess() {
    Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (_) => AccountWelcomePage(
          accountAuthViewModel: widget.accountAuthViewModel,
        ),
      ),
    );
  }

  Future<void> _configurePlan() async {
    final updated = await Navigator.of(context).push<TrainingSettings>(
      MaterialPageRoute<TrainingSettings>(
        builder: (_) =>
            OnboardingView(initialSettings: widget.trainingSettings),
      ),
    );
    if (updated == null || !mounted) return;
    setState(() {
      widget.onTrainingSettingsChanged(updated);
      _profile = ForzaProfile(fullName: _profile.fullName, goal: updated.goal);
    });
  }

  Future<void> _editProfile() async {
    final updated = await Navigator.of(context).push<ForzaProfile>(
      MaterialPageRoute<ForzaProfile>(
        builder: (_) => ProfileEditPage(profile: _localizedProfile(context)),
      ),
    );
    if (updated == null || !mounted) return;
    setState(() => _profile = updated);
  }

  Future<void> _editPreferences() async {
    if (!await _ensureProfileSettingsLoaded() || !mounted) return;
    final updated = await Navigator.of(context).push<AppPreferences>(
      MaterialPageRoute<AppPreferences>(
        builder: (_) => AppPreferencesPage(preferences: _preferences),
      ),
    );
    if (updated == null || !mounted) return;
    try {
      await widget.profileSettingsRepository.saveAppPreferences(updated);
    } on Object {
      if (mounted) _showSettingsSaveError();
      return;
    }
    if (!mounted) return;
    setState(() => _preferences = updated);
  }

  void _editAppearance() {
    Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (_) => AppAppearancePage(
          themeMode: widget.themeMode,
          onThemeModeChanged: widget.onThemeModeChanged,
        ),
      ),
    );
  }

  void _editLanguage() {
    Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (_) =>
            AppLanguagePage(localeController: widget.localeController),
      ),
    );
  }

  Future<void> _editNotifications() async {
    if (!await _ensureProfileSettingsLoaded() || !mounted) return;
    final updated = await Navigator.of(context).push<NotificationSettings>(
      MaterialPageRoute<NotificationSettings>(
        builder: (_) => NotificationsSettingsPage(settings: _notifications),
      ),
    );
    if (updated == null || !mounted) return;
    try {
      final onNotificationsChanged = widget.onNotificationsChanged;
      if (onNotificationsChanged == null) {
        await widget.profileSettingsRepository.saveNotifications(updated);
      } else if (!await onNotificationsChanged(_notifications, updated)) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(context.l10n.profileReminderPermissionDenied),
            ),
          );
        }
        return;
      }
    } on WorkoutReminderSyncException {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.l10n.profileReminderScheduleFailed)),
        );
      }
      return;
    } on Object {
      if (mounted) _showSettingsSaveError();
      return;
    }
    if (!mounted) return;
    setState(() => _notifications = updated);
  }

  Future<void> _editPrivacy() async {
    if (!await _ensureProfileSettingsLoaded() || !mounted) return;
    final updated = await Navigator.of(context).push<PrivacySettings>(
      MaterialPageRoute<PrivacySettings>(
        builder: (_) => PrivacyAccountPage(settings: _privacy),
      ),
    );
    if (updated == null || !mounted) return;
    try {
      await widget.profileSettingsRepository.savePrivacy(updated);
    } on Object {
      if (mounted) _showSettingsSaveError();
      return;
    }
    if (!mounted) return;
    setState(() => _privacy = updated);
  }

  ForzaProfile _localizedProfile(BuildContext context) => ForzaProfile(
    fullName: _profile.fullName == 'Atleta FORZA'
        ? context.l10n.profileDefaultName
        : _profile.fullName,
    goal: _localizedGoal(context, _profile.goal),
  );
}

class _ProfileSection extends StatelessWidget {
  const _ProfileSection({required this.title, required this.options});

  final String title;
  final List<_ProfileOption> options;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: AppSpacing.x3),
        AppSurfaceCard(
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              for (var index = 0; index < options.length; index++) ...[
                options[index],
                if (index < options.length - 1)
                  const Divider(height: 1, indent: 56),
              ],
            ],
          ),
        ),
      ],
    );
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
    return Semantics(
      button: true,
      label: '$title, $subtitle',
      child: ExcludeSemantics(
        child: ListTile(
          onTap: onTap,
          minVerticalPadding: AppSpacing.x3,
          contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.x4),
          leading: Icon(icon, color: context.appColors.accent),
          title: Text(title),
          subtitle: Text(subtitle),
          trailing: Icon(
            Icons.chevron_right_rounded,
            color: context.appColors.textSecondary,
          ),
        ),
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

String _formatTime(BuildContext context, int hour, int minute) =>
    formatDeviceTimeOfDay(context, TimeOfDay(hour: hour, minute: minute));

String _themeModeLabel(BuildContext context, ThemeMode mode) => switch (mode) {
  ThemeMode.system => context.l10n.settingsThemeSystem,
  ThemeMode.light => context.l10n.settingsThemeLight,
  ThemeMode.dark => context.l10n.settingsThemeDark,
};

String _weekStartLabel(BuildContext context, String day) => day == 'Lunes'
    ? context.l10n.profileWeekMonday
    : context.l10n.profileWeekSunday;

String _localizedGoal(BuildContext context, String goal) =>
    context.localizeTrainingGoal(goal);
