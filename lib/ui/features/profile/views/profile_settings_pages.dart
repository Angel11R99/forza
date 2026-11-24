import 'package:material_ui/material_ui.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../core/widgets/app_surface_card.dart';
import '../../../core/widgets/section_heading.dart';
import '../models/profile_settings.dart';
import '../../../../app/localization/locale_controller.dart';
import '../../../../app/localization/localization_extensions.dart';

class AppLanguagePage extends StatelessWidget {
  const AppLanguagePage({super.key, required this.localeController});

  final LocaleController localeController;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: localeController,
      builder: (context, _) => Scaffold(
        appBar: AppBar(title: Text(context.l10n.settingsLanguageTitle)),
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(AppSpacing.x6),
            children: [
              Text(
                context.l10n.settingsLanguageDescription,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: AppSpacing.x4),
              RadioGroup<String?>(
                groupValue: localeController.locale?.languageCode,
                onChanged: (languageCode) =>
                    _saveLanguage(context, languageCode),
                child: Column(
                  children: [
                    RadioListTile<String?>(
                      value: null,
                      title: Text(context.l10n.settingsLanguageAutomatic),
                      subtitle: Text(
                        context.l10n.settingsLanguageSystemDescription,
                      ),
                    ),
                    RadioListTile<String?>(
                      value: 'es',
                      title: Text(context.l10n.settingsLanguageSpanish),
                    ),
                    RadioListTile<String?>(
                      value: 'en',
                      title: Text(context.l10n.settingsLanguageEnglish),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _saveLanguage(BuildContext context, String? languageCode) async {
    try {
      await localeController.setLanguageCode(languageCode);
    } on Object {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.profileSettingsSaveFailed)),
      );
    }
  }
}

class ProfileEditPage extends StatefulWidget {
  const ProfileEditPage({super.key, required this.profile});

  final ForzaProfile profile;

  @override
  State<ProfileEditPage> createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  final _formKey = GlobalKey<FormState>();
  late final _nameController = TextEditingController(
    text: widget.profile.fullName,
  );
  late final _emailController = TextEditingController(
    text: widget.profile.email,
  );
  late final _goalController = TextEditingController(text: widget.profile.goal);

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _goalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.profileEditTitle)),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 680),
            child: Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.x6,
                  AppSpacing.x2,
                  AppSpacing.x6,
                  AppSpacing.x8,
                ),
                children: [
                  const SizedBox(height: AppSpacing.x4),
                  Text(
                    context.l10n.profileYourInformation,
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                  const SizedBox(height: AppSpacing.x2),
                  Text(
                    context.l10n.profileUpdateInformation,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: AppSpacing.x6),
                  TextFormField(
                    controller: _nameController,
                    textCapitalization: TextCapitalization.words,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      labelText: context.l10n.profileNameField,
                    ),
                    validator: (value) => value == null || value.trim().isEmpty
                        ? context.l10n.profileNameRequired
                        : null,
                  ),
                  const SizedBox(height: AppSpacing.x3),
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      labelText: context.l10n.profileEmailField,
                    ),
                    validator: (value) {
                      final email = value?.trim() ?? '';
                      if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$')
                          .hasMatch(email)) {
                        return context.l10n.profileEmailInvalid;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: AppSpacing.x3),
                  TextFormField(
                    controller: _goalController,
                    textCapitalization: TextCapitalization.sentences,
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                      labelText: context.l10n.profileGoalField,
                    ),
                    validator: (value) => value == null || value.trim().isEmpty
                        ? context.l10n.profileGoalRequired
                        : null,
                  ),
                  const SizedBox(height: AppSpacing.x6),
                  FilledButton.icon(
                    onPressed: _continueToConfirmation,
                    icon: const Icon(Icons.arrow_forward_rounded),
                    label: Text(context.l10n.profileReviewChanges),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _continueToConfirmation() async {
    if (!_formKey.currentState!.validate()) return;
    final draft = ForzaProfile(
      fullName: _nameController.text.trim(),
      email: _emailController.text.trim(),
      goal: _goalController.text.trim(),
    );
    final confirmed = await Navigator.of(context).push<ForzaProfile>(
      MaterialPageRoute<ForzaProfile>(
        builder: (_) => AccountConfirmationPage(profile: draft),
      ),
    );
    if (!mounted || confirmed == null) return;
    Navigator.of(context).pop(confirmed);
  }
}

class AppAppearancePage extends StatefulWidget {
  const AppAppearancePage({
    super.key,
    required this.themeMode,
    required this.onThemeModeChanged,
  });

  final ThemeMode themeMode;
  final Future<void> Function(ThemeMode) onThemeModeChanged;

  @override
  State<AppAppearancePage> createState() => _AppAppearancePageState();
}

class _AppAppearancePageState extends State<AppAppearancePage> {
  late ThemeMode _themeMode = widget.themeMode;

  Future<void> _selectMode(ThemeMode mode) async {
    try {
      await widget.onThemeModeChanged(mode);
      if (mounted) setState(() => _themeMode = mode);
    } on Object {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.profileSettingsSaveFailed)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.settingsAppearanceTitle)),
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.x6,
            AppSpacing.x2,
            AppSpacing.x6,
            AppSpacing.x8,
          ),
          children: [
            const SizedBox(height: AppSpacing.x4),
            Text(
              context.l10n.settingsThemeTitle,
              style: Theme.of(context).textTheme.displaySmall,
            ),
            const SizedBox(height: AppSpacing.x2),
            Text(
              context.l10n.settingsThemeDescription,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: AppSpacing.x6),
            AppSurfaceCard(
              padding: EdgeInsets.zero,
              child: RadioGroup<ThemeMode>(
                groupValue: _themeMode,
                onChanged: (mode) {
                  if (mode != null) _selectMode(mode);
                },
                child: Column(
                  children: [
                    RadioListTile<ThemeMode>(
                      value: ThemeMode.system,
                      title: Text(context.l10n.settingsThemeSystem),
                      subtitle: Text(
                        context.l10n.settingsThemeSystemDescription,
                      ),
                    ),
                    const Divider(height: 1, indent: 56),
                    RadioListTile<ThemeMode>(
                      value: ThemeMode.light,
                      title: Text(context.l10n.settingsThemeLight),
                    ),
                    const Divider(height: 1, indent: 56),
                    RadioListTile<ThemeMode>(
                      value: ThemeMode.dark,
                      title: Text(context.l10n.settingsThemeDark),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AppPreferencesPage extends StatefulWidget {
  const AppPreferencesPage({super.key, required this.preferences});

  final AppPreferences preferences;

  @override
  State<AppPreferencesPage> createState() => _AppPreferencesPageState();
}

class _AppPreferencesPageState extends State<AppPreferencesPage> {
  late String _weightUnit = widget.preferences.weightUnit;
  late String _weekStartsOn = widget.preferences.weekStartsOn;
  late bool _hapticsEnabled = widget.preferences.hapticsEnabled;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.profilePreferencesTitle)),
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.x6,
            AppSpacing.x2,
            AppSpacing.x6,
            AppSpacing.x8,
          ),
          children: [
            const SizedBox(height: AppSpacing.x4),
            Text(
              context.l10n.profileTailoredTitle,
              style: Theme.of(context).textTheme.displaySmall,
            ),
            const SizedBox(height: AppSpacing.x2),
            Text(
              context.l10n.profileTailoredDescription,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: AppSpacing.x8),
            SectionHeading(title: context.l10n.profileWeightUnitTitle),
            Wrap(
              spacing: AppSpacing.x2,
              children: [
                for (final unit in ['kg', 'lb'])
                  ChoiceChip(
                    label: Text(
                      unit == 'kg'
                          ? context.l10n.profileKilograms
                          : context.l10n.profilePounds,
                    ),
                    selected: unit == _weightUnit,
                    selectedColor: context.appColors.surfaceMuted,
                    onSelected: (_) => setState(() => _weightUnit = unit),
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.x6),
            SectionHeading(title: context.l10n.profileWeekStartTitle),
            Wrap(
              spacing: AppSpacing.x2,
              children: [
                for (final day in ['Lunes', 'Domingo'])
                  ChoiceChip(
                    label: Text(
                      day == 'Lunes'
                          ? context.l10n.profileWeekMonday
                          : context.l10n.profileWeekSunday,
                    ),
                    selected: day == _weekStartsOn,
                    selectedColor: context.appColors.surfaceMuted,
                    onSelected: (_) => setState(() => _weekStartsOn = day),
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.x6),
            AppSurfaceCard(
              padding: EdgeInsets.zero,
              child: SwitchListTile(
                title: Text(context.l10n.profileHapticTitle),
                subtitle: Text(context.l10n.profileHapticDescription),
                value: _hapticsEnabled,
                onChanged: (value) => setState(() => _hapticsEnabled = value),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _SaveBar(
        label: context.l10n.profileSavePreferences,
        onPressed: () => Navigator.of(context).pop(
          AppPreferences(
            weightUnit: _weightUnit,
            weekStartsOn: _weekStartsOn,
            hapticsEnabled: _hapticsEnabled,
          ),
        ),
      ),
    );
  }
}

class NotificationsSettingsPage extends StatefulWidget {
  const NotificationsSettingsPage({super.key, required this.settings});

  final NotificationSettings settings;

  @override
  State<NotificationsSettingsPage> createState() =>
      _NotificationsSettingsPageState();
}

class _NotificationsSettingsPageState extends State<NotificationsSettingsPage> {
  late bool _workoutReminders = widget.settings.workoutReminders;
  late bool _weeklySummary = widget.settings.weeklySummary;
  late bool _recordAlerts = widget.settings.personalRecordAlerts;
  late TimeOfDay _reminderTime = TimeOfDay(
    hour: widget.settings.reminderHour,
    minute: widget.settings.reminderMinute,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.profileNotificationsPageTitle)),
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.x6,
            AppSpacing.x2,
            AppSpacing.x6,
            AppSpacing.x8,
          ),
          children: [
            const SizedBox(height: AppSpacing.x4),
            Text(
              context.l10n.profileNotificationsHeading,
              style: Theme.of(context).textTheme.displaySmall,
            ),
            const SizedBox(height: AppSpacing.x2),
            Text(
              context.l10n.profileNotificationsDescription,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: AppSpacing.x6),
            AppSurfaceCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  SwitchListTile(
                    title: Text(context.l10n.profileWorkoutReminders),
                    subtitle: Text(context.l10n.profileReminderDescription),
                    value: _workoutReminders,
                    onChanged: (value) =>
                        setState(() => _workoutReminders = value),
                  ),
                  if (_workoutReminders) ...[
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.schedule_rounded),
                      title: Text(context.l10n.profileReminderTime),
                      trailing: Text(
                        _reminderTime.format(context),
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      onTap: _pickReminderTime,
                    ),
                  ],
                  const Divider(height: 1),
                  SwitchListTile(
                    title: Text(context.l10n.profileWeeklySummary),
                    subtitle: Text(
                      context.l10n.profileWeeklySummaryDescription,
                    ),
                    value: _weeklySummary,
                    onChanged: (value) =>
                        setState(() => _weeklySummary = value),
                  ),
                  const Divider(height: 1),
                  SwitchListTile(
                    title: Text(context.l10n.profilePersonalRecords),
                    subtitle: Text(context.l10n.profileRecordsSubtitle),
                    value: _recordAlerts,
                    onChanged: (value) => setState(() => _recordAlerts = value),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _SaveBar(
        label: context.l10n.profileSavePreferences,
        onPressed: () => Navigator.of(context).pop(
          NotificationSettings(
            workoutReminders: _workoutReminders,
            weeklySummary: _weeklySummary,
            personalRecordAlerts: _recordAlerts,
            reminderHour: _reminderTime.hour,
            reminderMinute: _reminderTime.minute,
          ),
        ),
      ),
    );
  }

  Future<void> _pickReminderTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _reminderTime,
    );
    if (picked != null) setState(() => _reminderTime = picked);
  }
}

class PrivacyAccountPage extends StatefulWidget {
  const PrivacyAccountPage({
    super.key,
    required this.settings,
    required this.profile,
  });

  final PrivacySettings settings;
  final ForzaProfile profile;

  @override
  State<PrivacyAccountPage> createState() => _PrivacyAccountPageState();
}

class _PrivacyAccountPageState extends State<PrivacyAccountPage> {
  late bool _privateProfile = widget.settings.privateProfile;
  late bool _shareActivity = widget.settings.shareWorkoutActivity;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.profilePrivacyPageTitle)),
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.x6,
            AppSpacing.x2,
            AppSpacing.x6,
            AppSpacing.x8,
          ),
          children: [
            const SizedBox(height: AppSpacing.x4),
            Text(
              context.l10n.profilePrivacyHeading,
              style: Theme.of(context).textTheme.displaySmall,
            ),
            const SizedBox(height: AppSpacing.x2),
            Text(
              context.l10n.profilePrivacyDescription,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: AppSpacing.x6),
            AppSurfaceCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  SwitchListTile(
                    title: Text(context.l10n.profilePrivateTitle),
                    subtitle: Text(context.l10n.profilePrivateDescription),
                    value: _privateProfile,
                    onChanged: (value) =>
                        setState(() => _privateProfile = value),
                  ),
                  const Divider(height: 1),
                  SwitchListTile(
                    title: Text(context.l10n.profileShareActivityTitle),
                    subtitle: Text(
                      context.l10n.profileShareActivityDescription,
                    ),
                    value: _shareActivity,
                    onChanged: (value) =>
                        setState(() => _shareActivity = value),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.x6),
            AppSurfaceCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.l10n.profileAccountData,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: AppSpacing.x2),
                  Text(
                    widget.profile.fullName,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: AppSpacing.x1),
                  Text(
                    widget.profile.email,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: AppSpacing.x3),
                  OutlinedButton.icon(
                    onPressed: _reviewAccount,
                    icon: const Icon(Icons.verified_user_outlined),
                    label: Text(context.l10n.profileConfirmAccount),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _SaveBar(
        label: context.l10n.profileSavePrivacy,
        onPressed: () => Navigator.of(context).pop(
          PrivacySettings(
            privateProfile: _privateProfile,
            shareWorkoutActivity: _shareActivity,
          ),
        ),
      ),
    );
  }

  Future<void> _reviewAccount() async {
    final confirmed = await Navigator.of(context).push<ForzaProfile>(
      MaterialPageRoute<ForzaProfile>(
        builder: (_) => AccountConfirmationPage(profile: widget.profile),
      ),
    );
    if (!mounted || confirmed == null) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(context.l10n.profileReviewComplete)));
  }
}

class AccountConfirmationPage extends StatelessWidget {
  const AccountConfirmationPage({super.key, required this.profile});

  final ForzaProfile profile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.profileAccountConfirmation)),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: ListView(
              padding: const EdgeInsets.all(AppSpacing.x6),
              children: [
                const SizedBox(height: AppSpacing.x8),
                Container(
                  width: 72,
                  height: 72,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: context.appColors.surfaceMuted,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.verified_user_outlined,
                    size: 34,
                    color: context.appColors.textPrimary,
                  ),
                ),
                const SizedBox(height: AppSpacing.x6),
                Text(
                  context.l10n.profileConfirmHeading,
                  style: Theme.of(context).textTheme.displaySmall,
                ),
                const SizedBox(height: AppSpacing.x2),
                Text(
                  context.l10n.profileConfirmDescription,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: AppSpacing.x6),
                AppSurfaceCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _AccountValue(
                        label: context.l10n.profileName,
                        value: profile.fullName,
                      ),
                      const Divider(height: AppSpacing.x6),
                      _AccountValue(
                        label: context.l10n.profileEmail,
                        value: profile.email,
                      ),
                      const Divider(height: AppSpacing.x6),
                      _AccountValue(
                        label: context.l10n.profileGoal,
                        value: profile.goal,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.x6),
                FilledButton.icon(
                  onPressed: () => Navigator.of(context).pop(profile),
                  icon: const Icon(Icons.check_rounded),
                  label: Text(context.l10n.profileConfirmDetails),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AccountValue extends StatelessWidget {
  const _AccountValue({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: AppSpacing.x1),
        Text(value, style: Theme.of(context).textTheme.titleMedium),
      ],
    );
  }
}

class _SaveBar extends StatelessWidget {
  const _SaveBar({required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.x6,
          AppSpacing.x3,
          AppSpacing.x6,
          AppSpacing.x4,
        ),
        child: FilledButton(onPressed: onPressed, child: Text(label)),
      ),
    );
  }
}
