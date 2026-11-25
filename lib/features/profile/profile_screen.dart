import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../app/providers.dart';
import '../../design_system/tokens.dart';
import '../../design_system/widgets/feedback.dart';
import '../../l10n/app_localizations.dart';
import '../auth/auth_controller.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final user = ref.watch(authControllerProvider).user;
    final locale = ref.watch(localeCodeProvider);
    final auth = ref.read(authControllerProvider.notifier);
    if (user == null) return const SizedBox.shrink();
    final quota = user.scanQuota;

    return Scaffold(
      appBar: AppBar(title: Text(l.navProfile)),
      body: RefreshIndicator(
        onRefresh: auth.refreshUser,
        child: ListView(
          padding: const EdgeInsets.all(FdSpace.lg),
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 32,
                  backgroundColor: FdColors.reef,
                  child: Text(
                    user.displayName.isEmpty ? '?' : user.displayName[0].toUpperCase(),
                    style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w800),
                  ),
                ),
                const SizedBox(width: FdSpace.lg),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(user.displayName, style: Theme.of(context).textTheme.titleLarge),
                      Text('@${user.handle}', style: const TextStyle(color: FdColors.mist)),
                      Text(user.email, style: const TextStyle(color: FdColors.mist, fontSize: 13)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: FdSpace.xl),
            if (quota != null)
              Card(
                child: ListTile(
                  leading: const Icon(Icons.center_focus_strong_rounded, color: FdColors.lagoon),
                  title: Text(l.scansToday),
                  subtitle: Text(l.scansLeft(quota.remaining, quota.limit)),
                  trailing: SizedBox(
                    width: 48,
                    child: LinearProgressIndicator(
                      value: quota.limit == 0 ? 0 : quota.used / quota.limit,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
            const SizedBox(height: FdSpace.md),
            Card(
              child: ListTile(
                leading: const Icon(Icons.translate_rounded),
                title: Text(l.language),
                trailing: SegmentedButton<String>(
                  key: const Key('profile.language'),
                  segments: const [
                    ButtonSegment(value: 'en', label: Text('EN')),
                    ButtonSegment(value: 'ms', label: Text('BM')),
                  ],
                  selected: {locale},
                  showSelectedIcon: false,
                  onSelectionChanged: (s) async {
                    try {
                      await auth.setLanguage(s.first);
                    } catch (e) {
                      if (context.mounted) showErrorSnack(context, e);
                    }
                  },
                ),
              ),
            ),
            const SizedBox(height: FdSpace.xl),
            OutlinedButton.icon(
              key: const Key('profile.signOut'),
              onPressed: auth.logout,
              icon: const Icon(Icons.logout_rounded),
              label: Text(l.signOut),
            ),
            const SizedBox(height: FdSpace.md),
            TextButton(
              key: const Key('profile.delete'),
              onPressed: () => _confirmDelete(context, ref),
              style: TextButton.styleFrom(foregroundColor: FdColors.coral),
              child: Text(l.deleteAccount),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref) async {
    final l = AppLocalizations.of(context);
    final password = TextEditingController();

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l.deleteAccount),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(l.deleteAccountBody),
            const SizedBox(height: FdSpace.md),
            TextField(
              controller: password,
              obscureText: true,
              decoration: InputDecoration(labelText: l.password),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(l.cancel)),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: FdColors.coral),
            child: Text(l.deleteAccountConfirm),
          ),
        ],
      ),
    );

    if (confirmed != true) return;
    try {
      await ref.read(authControllerProvider.notifier).deleteAccount(password: password.text);
    } catch (e) {
      if (context.mounted) showErrorSnack(context, e);
    }
  }
}
