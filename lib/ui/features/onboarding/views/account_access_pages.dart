import 'package:material_ui/material_ui.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/localization/localization_extensions.dart';
import '../../../core/widgets/app_surface_card.dart';

class AccountWelcomePage extends StatelessWidget {
  const AccountWelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final padding = AppSpacing.pageGutter(constraints.maxWidth);
            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 560),
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(padding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const _ForzaMark(),
                      const SizedBox(height: AppSpacing.x12),
                      Text(
                        context.l10n.accountWelcomeTitle,
                        style: Theme.of(context).textTheme.displaySmall,
                      ),
                      const SizedBox(height: AppSpacing.x3),
                      Text(
                        context.l10n.accountWelcomeDescription,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(height: AppSpacing.x8),
                      _AccessNote(),
                      const SizedBox(height: AppSpacing.x8),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          onPressed: () =>
                              _open(context, const CreateAccountPage()),
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 13),
                            child: Text(context.l10n.accountCreate),
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.x3),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () => _open(context, const SignInPage()),
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 13),
                            child: Text(context.l10n.accountExisting),
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.x4),
                      Center(
                        child: TextButton(
                          onPressed: Navigator.of(context).pop,
                          child: Text(context.l10n.accountContinue),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class CreateAccountPage extends StatefulWidget {
  const CreateAccountPage({super.key});

  @override
  State<CreateAccountPage> createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmationController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _AccountFormScaffold(
      title: context.l10n.accountCreate,
      eyebrow: context.l10n.accountNewEyebrow,
      description: context.l10n.accountCreateDescription,
      form: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                labelText: context.l10n.accountEmail,
                prefixIcon: Icon(Icons.mail_outline_rounded),
              ),
              validator: (value) => _validateEmail(context, value),
            ),
            const SizedBox(height: AppSpacing.x4),
            TextFormField(
              controller: _passwordController,
              obscureText: true,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                labelText: context.l10n.accountPassword,
                prefixIcon: Icon(Icons.lock_outline_rounded),
              ),
              validator: (value) => (value?.length ?? 0) < 8
                  ? context.l10n.accountPasswordLengthError
                  : null,
            ),
            const SizedBox(height: AppSpacing.x4),
            TextFormField(
              controller: _confirmationController,
              obscureText: true,
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(
                labelText: context.l10n.accountConfirmPassword,
                prefixIcon: Icon(Icons.lock_reset_rounded),
              ),
              validator: (value) => value != _passwordController.text
                  ? context.l10n.accountPasswordMismatchError
                  : null,
              onFieldSubmitted: (_) => _submit(),
            ),
          ],
        ),
      ),
      actionLabel: context.l10n.accountCreate,
      onAction: _submit,
      footer: TextButton(
        onPressed: () => _replace(context, const SignInPage()),
        child: Text(context.l10n.accountSignInPrompt),
      ),
    );
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    _showAccountUnavailableMessage(context);
  }
}

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _AccountFormScaffold(
      title: context.l10n.accountSignIn,
      eyebrow: context.l10n.accountSignInEyebrow,
      description: context.l10n.accountSignInDescription,
      form: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                labelText: context.l10n.accountEmail,
                prefixIcon: Icon(Icons.mail_outline_rounded),
              ),
              validator: (value) => _validateEmail(context, value),
            ),
            const SizedBox(height: AppSpacing.x4),
            TextFormField(
              controller: _passwordController,
              obscureText: true,
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(
                labelText: context.l10n.accountPassword,
                prefixIcon: Icon(Icons.lock_outline_rounded),
              ),
              validator: (value) => (value?.isEmpty ?? true)
                  ? context.l10n.accountPasswordRequired
                  : null,
              onFieldSubmitted: (_) => _submit(),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => _open(context, const RecoverPasswordPage()),
                child: Text(context.l10n.accountForgotPassword),
              ),
            ),
          ],
        ),
      ),
      actionLabel: context.l10n.accountSignIn,
      onAction: _submit,
      footer: TextButton(
        onPressed: () => _replace(context, const CreateAccountPage()),
        child: Text(context.l10n.accountCreateNew),
      ),
    );
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    _showAccountUnavailableMessage(context);
  }
}

class RecoverPasswordPage extends StatefulWidget {
  const RecoverPasswordPage({super.key});

  @override
  State<RecoverPasswordPage> createState() => _RecoverPasswordPageState();
}

class _RecoverPasswordPageState extends State<RecoverPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _AccountFormScaffold(
      title: context.l10n.accountRecover,
      eyebrow: context.l10n.accountRecoverEyebrow,
      description: context.l10n.accountRecoverDescription,
      form: Form(
        key: _formKey,
        child: TextFormField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.done,
          decoration: InputDecoration(
            labelText: context.l10n.accountEmail,
            prefixIcon: Icon(Icons.mail_outline_rounded),
          ),
          validator: (value) => _validateEmail(context, value),
          onFieldSubmitted: (_) => _submit(),
        ),
      ),
      actionLabel: context.l10n.accountContinueAction,
      onAction: _submit,
    );
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    _showAccountUnavailableMessage(context);
  }
}

class _AccountFormScaffold extends StatelessWidget {
  const _AccountFormScaffold({
    required this.title,
    required this.eyebrow,
    required this.description,
    required this.form,
    required this.actionLabel,
    required this.onAction,
    this.footer,
  });

  final String title;
  final String eyebrow;
  final String description;
  final Widget form;
  final String actionLabel;
  final VoidCallback onAction;
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('FORZA')),
      body: SafeArea(
        top: false,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final padding = AppSpacing.pageGutter(constraints.maxWidth);
            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 560),
                child: ListView(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  padding: EdgeInsets.fromLTRB(
                    padding,
                    AppSpacing.x4,
                    padding,
                    AppSpacing.x6,
                  ),
                  children: [
                    Text(
                      eyebrow,
                      style: Theme.of(context).textTheme.labelLarge
                          ?.copyWith(color: context.appColors.accent),
                    ),
                    const SizedBox(height: AppSpacing.x3),
                    Text(
                      title,
                      style: Theme.of(context).textTheme.displaySmall,
                    ),
                    const SizedBox(height: AppSpacing.x2),
                    Text(
                      description,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: AppSpacing.x6),
                    form,
                    const SizedBox(height: AppSpacing.x3),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: onAction,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 13),
                          child: Text(actionLabel),
                        ),
                      ),
                    ),
                    if (footer != null) ...[
                      const SizedBox(height: AppSpacing.x3),
                      Center(child: footer!),
                    ],
                    const SizedBox(height: AppSpacing.x6),
                    _AccessNote(),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _ForzaMark extends StatelessWidget {
  const _ForzaMark();

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'FORZA',
      child: ExcludeSemantics(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: context.appColors.textPrimary,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text(
                'F',
                style: TextStyle(
                  color: context.appColors.inverseText,
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.x3),
            Text(
              'FORZA',
              style: Theme.of(context).textTheme.titleLarge
                  ?.copyWith(fontWeight: FontWeight.w800, letterSpacing: 2),
            ),
          ],
        ),
      ),
    );
  }
}

class _AccessNote extends StatelessWidget {
  const _AccessNote();

  @override
  Widget build(BuildContext context) {
    return AppSurfaceCard(
      color: context.appColors.surfaceMuted,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline_rounded, size: 20),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Text(
              context.l10n.accountUnavailableNote,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }
}

String? _validateEmail(BuildContext context, String? value) {
  final email = value?.trim() ?? '';
  if (email.isEmpty) return context.l10n.accountEmailRequired;
  if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email)) {
    return context.l10n.accountEmailInvalid;
  }
  return null;
}

void _showAccountUnavailableMessage(BuildContext context) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(content: Text(context.l10n.accountUnavailableMessage)),
    );
}

void _open(BuildContext context, Widget page) {
  Navigator.of(context)
      .push<void>(MaterialPageRoute<void>(builder: (_) => page));
}

void _replace(BuildContext context, Widget page) {
  Navigator.of(
    context,
  ).pushReplacement<void, void>(MaterialPageRoute<void>(builder: (_) => page));
}
