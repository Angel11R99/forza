import 'package:material_ui/material_ui.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../core/widgets/app_surface_card.dart';
import '../../../core/widgets/section_heading.dart';
import '../models/profile_settings.dart';

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
      appBar: AppBar(title: const Text('Editar perfil')),
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
                    'Tu información',
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                  const SizedBox(height: AppSpacing.x2),
                  Text(
                    'Actualiza los datos que se muestran en tu perfil.',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: AppSpacing.x6),
                  TextFormField(
                    controller: _nameController,
                    textCapitalization: TextCapitalization.words,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(labelText: 'Nombre'),
                    validator: (value) => value == null || value.trim().isEmpty
                        ? 'Ingresa tu nombre.'
                        : null,
                  ),
                  const SizedBox(height: AppSpacing.x3),
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(labelText: 'Correo'),
                    validator: (value) {
                      final email = value?.trim() ?? '';
                      if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$')
                          .hasMatch(email)) {
                        return 'Ingresa un correo válido.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: AppSpacing.x3),
                  TextFormField(
                    controller: _goalController,
                    textCapitalization: TextCapitalization.sentences,
                    textInputAction: TextInputAction.done,
                    decoration: const InputDecoration(
                      labelText: 'Objetivo de entrenamiento',
                    ),
                    validator: (value) => value == null || value.trim().isEmpty
                        ? 'Escribe un objetivo.'
                        : null,
                  ),
                  const SizedBox(height: AppSpacing.x6),
                  FilledButton.icon(
                    onPressed: _continueToConfirmation,
                    icon: const Icon(Icons.arrow_forward_rounded),
                    label: const Text('Revisar cambios'),
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

class AppPreferencesPage extends StatefulWidget {
  const AppPreferencesPage({
    super.key,
    required this.preferences,
    required this.themeMode,
    required this.onThemeModeChanged,
  });

  final AppPreferences preferences;
  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onThemeModeChanged;

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
      appBar: AppBar(title: const Text('Preferencias')),
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
              'A tu medida',
              style: Theme.of(context).textTheme.displaySmall,
            ),
            const SizedBox(height: AppSpacing.x2),
            Text(
              'Elige cómo quieres ver la información en la app.',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: AppSpacing.x8),
            SectionHeading(title: 'Unidad de peso'),
            Wrap(
              spacing: AppSpacing.x2,
              children: [
                for (final unit in ['kg', 'lb'])
                  ChoiceChip(
                    label: Text(unit),
                    selected: unit == _weightUnit,
                    selectedColor: context.appColors.surfaceMuted,
                    onSelected: (_) => setState(() => _weightUnit = unit),
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.x6),
            SectionHeading(title: 'Inicio de semana'),
            Wrap(
              spacing: AppSpacing.x2,
              children: [
                for (final day in ['Lunes', 'Domingo'])
                  ChoiceChip(
                    label: Text(day),
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
                title: const Text('Respuesta háptica'),
                subtitle: const Text(
                  'Vibración suave al usar controles compatibles.',
                ),
                value: _hapticsEnabled,
                onChanged: (value) => setState(() => _hapticsEnabled = value),
              ),
            ),
            const SizedBox(height: AppSpacing.x3),
            SectionHeading(title: 'Apariencia'),
            AppSurfaceCard(
              padding: EdgeInsets.zero,
              child: RadioGroup<ThemeMode>(
                groupValue: widget.themeMode,
                onChanged: (mode) {
                  if (mode != null) widget.onThemeModeChanged(mode);
                },
                child: Column(
                  children: [
                    RadioListTile<ThemeMode>(
                      value: ThemeMode.system,
                      title: const Text('Según el dispositivo'),
                      subtitle: const Text('Sigue el tema del sistema.'),
                    ),
                    const Divider(height: 1, indent: 56),
                    RadioListTile<ThemeMode>(
                      value: ThemeMode.light,
                      title: const Text('Claro'),
                    ),
                    const Divider(height: 1, indent: 56),
                    RadioListTile<ThemeMode>(
                      value: ThemeMode.dark,
                      title: const Text('Oscuro'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _SaveBar(
        label: 'Guardar preferencias',
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
      appBar: AppBar(title: const Text('Notificaciones')),
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
              'Recibe solo lo útil.',
              style: Theme.of(context).textTheme.displaySmall,
            ),
            const SizedBox(height: AppSpacing.x2),
            Text(
              'Configura tus preferencias de notificaciones.',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: AppSpacing.x6),
            AppSurfaceCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  SwitchListTile(
                    title: const Text('Recordatorios de entrenamiento'),
                    subtitle: const Text('Elige una hora que te funcione.'),
                    value: _workoutReminders,
                    onChanged: (value) =>
                        setState(() => _workoutReminders = value),
                  ),
                  if (_workoutReminders) ...[
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.schedule_rounded),
                      title: const Text('Hora del recordatorio'),
                      trailing: Text(
                        _reminderTime.format(context),
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      onTap: _pickReminderTime,
                    ),
                  ],
                  const Divider(height: 1),
                  SwitchListTile(
                    title: const Text('Resumen semanal'),
                    subtitle: const Text('Un repaso de tu actividad.'),
                    value: _weeklySummary,
                    onChanged: (value) =>
                        setState(() => _weeklySummary = value),
                  ),
                  const Divider(height: 1),
                  SwitchListTile(
                    title: const Text('Récords personales'),
                    subtitle: const Text(
                      'Avisos cuando alcances una nueva marca.',
                    ),
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
        label: 'Guardar preferencias',
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
      appBar: AppBar(title: const Text('Privacidad y cuenta')),
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
              'Tú decides qué compartir.',
              style: Theme.of(context).textTheme.displaySmall,
            ),
            const SizedBox(height: AppSpacing.x2),
            Text(
              'Tus preferencias de privacidad.',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: AppSpacing.x6),
            AppSurfaceCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  SwitchListTile(
                    title: const Text('Perfil privado'),
                    subtitle: const Text(
                      'Mantener tu perfil fuera de vistas públicas.',
                    ),
                    value: _privateProfile,
                    onChanged: (value) =>
                        setState(() => _privateProfile = value),
                  ),
                  const Divider(height: 1),
                  SwitchListTile(
                    title: const Text('Compartir actividad'),
                    subtitle: const Text(
                      'Permitir que otras personas vean tus entrenamientos.',
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
                    'Datos de cuenta',
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
                    label: const Text('Confirmar datos de cuenta'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _SaveBar(
        label: 'Guardar privacidad',
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
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Revisión de datos completada.')),
    );
  }
}

class AccountConfirmationPage extends StatelessWidget {
  const AccountConfirmationPage({super.key, required this.profile});

  final ForzaProfile profile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Confirmación de cuenta')),
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
                  'Confirma tus datos',
                  style: Theme.of(context).textTheme.displaySmall,
                ),
                const SizedBox(height: AppSpacing.x2),
                Text(
                  'Revisa la información antes de volver a tu perfil.',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: AppSpacing.x6),
                AppSurfaceCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _AccountValue(label: 'Nombre', value: profile.fullName),
                      const Divider(height: AppSpacing.x6),
                      _AccountValue(label: 'Correo', value: profile.email),
                      const Divider(height: AppSpacing.x6),
                      _AccountValue(label: 'Objetivo', value: profile.goal),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.x6),
                FilledButton.icon(
                  onPressed: () => Navigator.of(context).pop(profile),
                  icon: const Icon(Icons.check_rounded),
                  label: const Text('Confirmar datos'),
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
