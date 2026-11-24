import 'dart:async';

import 'package:material_ui/material_ui.dart';

import '../../../../app/localization/localization_extensions.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../domain/repositories/account_auth_repository.dart';
import '../../../core/widgets/app_surface_card.dart';
import '../view_models/account_auth_view_model.dart';

class AccountWelcomePage extends StatefulWidget {
  const AccountWelcomePage({super.key, required this.accountAuthViewModel});

  final AccountAuthViewModel accountAuthViewModel;

  @override
  State<AccountWelcomePage> createState() => _AccountWelcomePageState();
}

class _AccountWelcomePageState extends State<AccountWelcomePage> {
  @override
  void initState() {
    super.initState();
    unawaited(widget.accountAuthViewModel.restore());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('FORZA')),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final padding = AppSpacing.pageGutter(constraints.maxWidth);
            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 560),
                child: ListenableBuilder(
                  listenable: widget.accountAuthViewModel,
                  builder: (context, _) {
                    final model = widget.accountAuthViewModel;
                    final account = model.account;
                    return ListView(
                      padding: EdgeInsets.all(padding),
                      children: [
                        Text(
                          context.l10n.accountWelcomeTitle,
                          style: Theme.of(context).textTheme.displaySmall,
                        ),
                        const SizedBox(height: AppSpacing.x3),
                        Text(
                          context.l10n.accountWelcomeDescription,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        const SizedBox(height: AppSpacing.x6),
                        if (account != null) ...[
                          AppSurfaceCard(
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 26,
                                  backgroundColor:
                                      context.appColors.surfaceMuted,
                                  foregroundColor:
                                      context.appColors.textPrimary,
                                  backgroundImage: account.photoUrl == null
                                      ? null
                                      : NetworkImage(account.photoUrl!),
                                  child: account.photoUrl == null
                                      ? const Icon(Icons.person_outline_rounded)
                                      : null,
                                ),
                                const SizedBox(width: AppSpacing.x4),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        account.displayName
                                                    ?.trim()
                                                    .isNotEmpty ==
                                                true
                                            ? account.displayName!
                                            : account.email,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium,
                                      ),
                                      const SizedBox(height: AppSpacing.x1),
                                      Text(
                                        account.email,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium,
                                      ),
                                      const SizedBox(height: AppSpacing.x2),
                                      Text(
                                        context.l10n.profileGoogleConnected,
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelMedium,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: AppSpacing.x4),
                        ],
                        if (model.failure != null) ...[
                          _AccountFailureMessage(failure: model.failure!),
                          const SizedBox(height: AppSpacing.x4),
                        ],
                        SizedBox(
                          width: double.infinity,
                          child: FilledButton.icon(
                            onPressed: model.isLoading
                                ? null
                                : () => model.signInWithGoogle(
                                    changeAccount: account != null,
                                  ),
                            icon: model.isLoading
                                ? const SizedBox.square(
                                    dimension: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Icon(Icons.account_circle_outlined),
                            label: Text(
                              account == null
                                  ? context.l10n.accountSignInWithGoogle
                                  : context.l10n.accountSwitchGoogle,
                            ),
                          ),
                        ),
                        if (account != null) ...[
                          const SizedBox(height: AppSpacing.x3),
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton(
                              onPressed: model.isLoading
                                  ? null
                                  : () => _confirmSignOut(context),
                              child: Text(context.l10n.accountSignOut),
                            ),
                          ),
                        ] else ...[
                          const SizedBox(height: AppSpacing.x3),
                          Center(
                            child: TextButton(
                              onPressed: model.isLoading
                                  ? null
                                  : Navigator.of(context).pop,
                              child: Text(
                                context.l10n.accountContinueWithoutAccount,
                              ),
                            ),
                          ),
                        ],
                        const SizedBox(height: AppSpacing.x4),
                        AppSurfaceCard(
                          color: context.appColors.surfaceMuted,
                          child: Text(
                            context.l10n.accountLocalDataNote,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _confirmSignOut(BuildContext context) async {
    final shouldSignOut = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.l10n.accountSignOutTitle),
        content: Text(context.l10n.accountSignOutMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(context.l10n.commonCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(context.l10n.accountSignOut),
          ),
        ],
      ),
    );
    if (shouldSignOut == true) {
      await widget.accountAuthViewModel.signOut();
    }
  }
}

class _AccountFailureMessage extends StatelessWidget {
  const _AccountFailureMessage({required this.failure});

  final AccountAuthFailure failure;

  @override
  Widget build(BuildContext context) {
    final message = switch (failure) {
      AccountAuthFailure.configuration =>
        context.l10n.accountConfigurationRequired,
      AccountAuthFailure.unavailable => context.l10n.accountProviderUnavailable,
      AccountAuthFailure.unknown => context.l10n.accountAuthenticationFailed,
    };
    return AppSurfaceCard(
      color: context.appColors.surfaceMuted,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info_outline_rounded,
            color: context.appColors.textPrimary,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(child: Text(message)),
        ],
      ),
    );
  }
}
