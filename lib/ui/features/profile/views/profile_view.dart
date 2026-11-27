import 'dart:async';

import 'package:material_ui/material_ui.dart';

import '../../../../app/localization/device_time_format.dart';
import '../../../../data/repositories/workout_reminder_repository.dart';
import '../../../../data/repositories/profile_settings_repository.dart';
import '../../../../data/services/firestore_backup_sync_service.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../core/widgets/app_surface_card.dart';
import '../../../core/widgets/forza_brand.dart';
import '../../onboarding/views/account_access_pages.dart';
import '../../onboarding/views/onboarding_view.dart';
import '../../onboarding/view_models/account_auth_view_model.dart';
import '../models/profile_settings.dart';
import 'cloud_sync_settings_page.dart';
import 'profile_settings_pages.dart';
import '../../../../app/localization/locale_controller.dart';
import '../../../../app/localization/localization_extensions.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({
    super.key,
    required this.trainingSettings,
    required this.onTrainingSettingsChanged,
    required this.profileSettingsRepository,
    this.preferences = const AppPreferences(),
    this.onPreferencesChanged,
    required this.accountAuthViewModel,
    this.cloudSyncService,
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
  final AppPreferences preferences;
  final ValueChanged<AppPreferences>? onPreferencesChanged;
  final AccountAuthViewModel accountAuthViewModel;
  final FirestoreBackupSyncService? cloudSyncService;
  final Future<bool> Function(
    NotificationSettings previous,
    NotificationSettings updated,
  )?
  onNotificationsChanged;

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  String? _profileDisplayName;
  String? _profileNameUid;
  int _profileNameRequest = 0;
  late AppPreferences _preferences = widget.preferences;
  NotificationSettings _notifications = const NotificationSettings();
  PrivacySettings _privacy = const PrivacySettings();
  bool _profileSettingsLoaded = false;
  int _preferencesRevision = 0;

  @override
  void initState() {
    super.initState();
    _loadProfileSettings();
    widget.accountAuthViewModel.addListener(_onAccountChanged);
    _onAccountChanged();
    unawaited(widget.accountAuthViewModel.restore());
  }

  @override
  void didUpdateWidget(covariant ProfileView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.accountAuthViewModel != widget.accountAuthViewModel) {
      oldWidget.accountAuthViewModel.removeListener(_onAccountChanged);
      widget.accountAuthViewModel.addListener(_onAccountChanged);
      _profileNameUid = null;
      _onAccountChanged();
    }
    if (oldWidget.preferences == widget.preferences) return;
    _preferencesRevision++;
    _preferences = widget.preferences;
  }

  @override
  void dispose() {
    widget.accountAuthViewModel.removeListener(_onAccountChanged);
    super.dispose();
  }

  void _onAccountChanged() {
    final uid = widget.accountAuthViewModel.account?.providerUserId;
    if (uid == _profileNameUid) return;
    _profileNameUid = uid;
    _profileDisplayName = null;
    final request = ++_profileNameRequest;
    if (mounted) setState(() {});
    if (uid != null) unawaited(_loadProfileDisplayName(uid, request));
  }

  Future<void> _loadProfileDisplayName(String uid, int request) async {
    try {
      final name = await widget.profileSettingsRepository
          .loadProfileDisplayName(uid);
      if (!mounted || request != _profileNameRequest) return;
      setState(() => _profileDisplayName = name);
    } on Object {
      // The Google identity remains a safe fallback when local settings fail.
    }
  }

  Future<void> _loadProfileSettings() async {
    final preferencesRevision = _preferencesRevision;
    try {
      final preferences = await widget.profileSettingsRepository
          .loadAppPreferences();
      final notifications = await widget.profileSettingsRepository
          .loadNotifications();
      final privacy = await widget.profileSettingsRepository.loadPrivacy();
      if (!mounted) return;
      setState(() {
        if (preferencesRevision == _preferencesRevision) {
          _preferences = preferences;
        }
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
                    return _AccountIdentityCard(
                      model: widget.accountAuthViewModel,
                      onSignIn: _openAccountAccess,
                      customName: _profileDisplayName,
                    );
                  },
                ),
                const SizedBox(height: AppSpacing.x8),
                ListenableBuilder(
                  listenable: Listenable.merge([
                    widget.accountAuthViewModel,
                    if (widget.cloudSyncService != null)
                      widget.cloudSyncService!,
                  ]),
                  builder: (context, _) {
                    final hasAccount =
                        widget.accountAuthViewModel.account != null;
                    return _ProfileSection(
                      title: context.l10n.profileEyebrow,
                      options: [
                        _ProfileOption(
                          icon: Icons.language_rounded,
                          title: context.l10n.settingsLanguageSelection,
                          subtitle:
                              widget.localeController.locale?.languageCode ==
                                  'en'
                              ? context.l10n.settingsLanguageEnglish
                              : widget.localeController.locale?.languageCode ==
                                    'es'
                              ? context.l10n.settingsLanguageSpanish
                              : context.l10n.settingsLanguageAutomatic,
                          onTap: _editLanguage,
                        ),
                        if (hasAccount) ...[
                          if (widget.cloudSyncService != null)
                            _ProfileOption(
                              icon: Icons.cloud_sync_outlined,
                              title: context.l10n.cloudSyncTitle,
                              subtitle: _cloudSyncSubtitle(
                                context,
                                widget.cloudSyncService!.status.phase,
                              ),
                              onTap: _openCloudSyncSettings,
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
                      ],
                    );
                  },
                ),
                const SizedBox(height: AppSpacing.x6),
                _ProfileSection(
                  title: context.l10n.profileTraining,
                  options: [
                    _ProfileOption(
                      icon: Icons.flag_outlined,
                      title: context.l10n.profileMyPlan,
                      subtitle: context.l10n.profilePlanSummary(
                        widget.trainingSettings.daysPerWeek,
                        _localizedGoal(context, widget.trainingSettings.goal),
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
    });
  }

  Future<void> _editProfile() async {
    final account = widget.accountAuthViewModel.account;
    if (account == null) return;
    final googleName = account.displayName?.trim();
    final updated = await Navigator.of(context).push<ForzaProfile>(
      MaterialPageRoute<ForzaProfile>(
        builder: (_) => ProfileEditPage(
          profile: ForzaProfile(
            fullName:
                _profileDisplayName ??
                (googleName?.isNotEmpty == true ? googleName! : ''),
            useGoogleName: _profileDisplayName == null,
          ),
          email: account.email,
          googleName: googleName?.isNotEmpty == true ? googleName : null,
        ),
      ),
    );
    if (updated == null || !mounted) return;
    try {
      final savedName = updated.useGoogleName ? null : updated.fullName.trim();
      await widget.profileSettingsRepository.saveProfileDisplayName(
        account.providerUserId,
        savedName,
      );
      if (!mounted ||
          widget.accountAuthViewModel.account?.providerUserId !=
              account.providerUserId) {
        return;
      }
      setState(() => _profileDisplayName = savedName);
    } on Object {
      if (mounted) _showSettingsSaveError();
    }
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
    widget.onPreferencesChanged?.call(updated);
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

  Future<void> _openCloudSyncSettings() async {
    final service = widget.cloudSyncService;
    final account = widget.accountAuthViewModel.account;
    if (service == null || account == null) return;
    await Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (_) => CloudSyncSettingsPage(
          service: service,
          settingsRepository: widget.profileSettingsRepository,
          uid: account.providerUserId,
        ),
      ),
    );
  }
}

String _cloudSyncSubtitle(BuildContext context, CloudSyncPhase phase) =>
    switch (phase) {
      CloudSyncPhase.signedOut => context.l10n.cloudSyncStatusSignedOut,
      CloudSyncPhase.consentRequired => context.l10n.cloudSyncStatusDisabled,
      CloudSyncPhase.syncing => context.l10n.cloudSyncStatusSyncing,
      CloudSyncPhase.synced => context.l10n.cloudSyncStatusSynced,
      CloudSyncPhase.pending => context.l10n.cloudSyncStatusPending,
      CloudSyncPhase.failed => context.l10n.cloudSyncStatusFailed,
    };

class _AccountIdentityCard extends StatelessWidget {
  const _AccountIdentityCard({
    required this.model,
    required this.onSignIn,
    this.customName,
  });

  final AccountAuthViewModel model;
  final VoidCallback onSignIn;
  final String? customName;

  @override
  Widget build(BuildContext context) {
    final account = model.account;
    final providerName = account?.displayName?.trim();
    final displayName = customName?.trim().isNotEmpty == true
        ? customName!.trim()
        : providerName;
    final hasDisplayName = displayName != null && displayName.isNotEmpty;

    return AppSurfaceCard(
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: context.appColors.accentSoft,
                foregroundColor: context.appColors.accent,
                backgroundImage: account?.photoUrl == null
                    ? null
                    : NetworkImage(account!.photoUrl!),
                child: account?.photoUrl != null
                    ? null
                    : hasDisplayName
                    ? Text(
                        _initials(displayName),
                        style: Theme.of(context).textTheme.titleLarge,
                      )
                    : const Icon(Icons.person_outline_rounded, size: 28),
              ),
              const SizedBox(width: AppSpacing.x4),
              Expanded(
                child: account == null
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            model.isLoading
                                ? context.l10n.profileAccountChecking
                                : context.l10n.profileNoAccount,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: AppSpacing.x1),
                          Text(
                            model.isLoading
                                ? context.l10n.profileAccountCheckingDescription
                                : context.l10n.profileGuestDescription,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            hasDisplayName ? displayName : account.email,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          if (hasDisplayName) ...[
                            const SizedBox(height: AppSpacing.x1),
                            Text(
                              account.email,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                          const SizedBox(height: AppSpacing.x2),
                          Text(
                            context.l10n.profileGoogleConnected,
                            style: Theme.of(context).textTheme.labelMedium,
                          ),
                        ],
                      ),
              ),
            ],
          ),
          if (account == null && !model.isLoading) ...[
            const SizedBox(height: AppSpacing.x4),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: onSignIn,
                icon: const Icon(Icons.login_rounded),
                label: Text(context.l10n.accountSignInWithGoogle),
              ),
            ),
          ],
          if (account == null && model.isLoading) ...[
            const SizedBox(height: AppSpacing.x3),
            const LinearProgressIndicator(),
          ],
        ],
      ),
    );
  }
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
