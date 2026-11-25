import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../core/api/api_exception.dart';
import '../../l10n/app_localizations.dart';
import '../tokens.dart';

/// Renders loading / error / data for an AsyncValue with a retry button.
class AsyncValueView<T> extends StatelessWidget {
  const AsyncValueView({super.key, required this.value, required this.data, this.onRetry});

  final AsyncValue<T> value;
  final Widget Function(T data) data;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) => value.when(
    data: data,
    loading: () => const Center(child: CircularProgressIndicator()),
    error: (e, _) => ErrorState(error: e, onRetry: onRetry),
  );
}

class ErrorState extends StatelessWidget {
  const ErrorState({super.key, required this.error, this.onRetry});

  final Object error;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final message = error is ApiException && !(error as ApiException).isNetwork ? (error as ApiException).message : l.loadError;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(FdSpace.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.waves_rounded, size: 48, color: FdColors.mist),
            const SizedBox(height: FdSpace.md),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: FdColors.mist),
            ),
            if (onRetry != null) ...[
              const SizedBox(height: FdSpace.lg),
              OutlinedButton.icon(onPressed: onRetry, icon: const Icon(Icons.refresh_rounded), label: Text(l.retry)),
            ],
          ],
        ),
      ),
    );
  }
}

class EmptyState extends StatelessWidget {
  const EmptyState({super.key, required this.icon, required this.message, this.action});

  final IconData icon;
  final String message;
  final Widget? action;

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(FdSpace.xl),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 56, color: FdColors.current),
          const SizedBox(height: FdSpace.md),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(color: FdColors.mist, fontSize: 15),
          ),
          if (action != null) ...[const SizedBox(height: FdSpace.lg), action!],
        ],
      ),
    ),
  );
}

void showErrorSnack(BuildContext context, Object error) {
  final l = AppLocalizations.of(context);
  final message = error is ApiException && !error.isNetwork ? error.message : l.loadError;
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
}
