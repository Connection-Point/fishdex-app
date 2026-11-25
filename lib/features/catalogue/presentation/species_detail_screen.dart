import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../../app/providers.dart';
import '../../../design_system/tokens.dart';
import '../../../design_system/widgets/feedback.dart';
import '../../../design_system/widgets/fish_card_view.dart';
import '../../../l10n/app_localizations.dart';
import '../catalogue_providers.dart';
import '../data/species.dart';

class SpeciesDetailScreen extends ConsumerWidget {
  const SpeciesDetailScreen({super.key, required this.speciesId});

  final String speciesId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detail = ref.watch(speciesDetailProvider(speciesId));
    final locale = ref.watch(localeCodeProvider);

    return Scaffold(
      appBar: AppBar(),
      body: AsyncValueView<SpeciesDetail>(
        value: detail,
        onRetry: () => ref.invalidate(speciesDetailProvider(speciesId)),
        data: (d) => _DetailBody(detail: d, locale: locale),
      ),
    );
  }
}

class _DetailBody extends StatelessWidget {
  const _DetailBody({required this.detail, required this.locale});

  final SpeciesDetail detail;
  final String locale;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final s = detail.summary;
    final theme = Theme.of(context);
    final primaryImage = detail.images.isNotEmpty ? detail.images.first.url : s.thumbnailUrl;

    String originLabel(String? o) => switch (o) {
      'native' => l.native,
      'endemic' => l.endemic,
      'introduced' => l.introduced,
      'invasive' => l.invasive,
      _ => l.uncertain,
    };

    final aliases = detail.aliases.map((a) => a.name).where((n) => n != s.names.en && n != s.names.ms).toSet().toList();

    return ListView(
      padding: const EdgeInsets.fromLTRB(FdSpace.lg, 0, FdSpace.lg, FdSpace.xxl),
      children: [
        Center(
          child: Hero(
            tag: 'card-${s.id}',
            child: FishCardView(
              scientificName: s.scientificName,
              primaryName: s.names.primary(locale),
              secondaryName: s.names.secondary(locale),
              rarity: s.rarity,
              card: s.card,
              imageUrl: primaryImage,
              width: 250,
            ),
          ),
        ),
        const SizedBox(height: FdSpace.lg),
        Center(
          child: Text(
            switch (s.userState) {
              UserSpeciesState.collected => l.stateCollected,
              UserSpeciesState.seen => l.stateSeen,
              UserSpeciesState.unseen => l.stateUnseen,
            },
            style: TextStyle(color: s.userState == UserSpeciesState.unseen ? FdColors.mist : FdColors.lagoon, fontWeight: FontWeight.w700),
          ),
        ),
        if (s.rarity != null) ...[
          const SizedBox(height: FdSpace.xs),
          Center(
            child: Text(
              l.rarityNote,
              textAlign: TextAlign.center,
              style: const TextStyle(color: FdColors.mist, fontSize: 12),
            ),
          ),
        ],
        if (detail.legalNotice != null) ...[
          const SizedBox(height: FdSpace.lg),
          Container(
            padding: const EdgeInsets.all(FdSpace.md),
            decoration: BoxDecoration(
              color: FdColors.coral.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(FdRadius.field),
              border: Border.all(color: FdColors.coral.withValues(alpha: 0.6)),
            ),
            child: Row(
              children: [
                const Icon(Icons.shield_outlined, color: FdColors.coral),
                const SizedBox(width: FdSpace.md),
                Expanded(child: Text('${l.protectedSpecies}${detail.legalNotice!.notes != null ? ' — ${detail.legalNotice!.notes}' : ''}')),
              ],
            ),
          ),
        ],
        _Section(
          title: l.identification,
          children: [
            if (detail.identificationNotes != null) Text(detail.identificationNotes!, style: const TextStyle(height: 1.45)),
            if (detail.description != null) ...[
              const SizedBox(height: FdSpace.sm),
              Text(detail.description!, style: const TextStyle(height: 1.45)),
            ],
            if (detail.funFact != null) ...[
              const SizedBox(height: FdSpace.sm),
              Text('💡 ${detail.funFact!}', style: const TextStyle(color: FdColors.sand)),
            ],
          ],
        ),
        _Facts(
          rows: [
            (l.family, [s.family, detail.familyCommonName].whereType<String>().join(' · ')),
            (l.origin, originLabel(detail.origin)),
            if (detail.maxLengthCm != null) (l.maxLength, '${detail.maxLengthCm!.toStringAsFixed(0)} cm'),
            if (aliases.isNotEmpty) (l.alsoKnownAs, aliases.join(', ')),
          ],
        ),
        if (detail.habitats.isNotEmpty)
          _Section(
            title: l.habitat,
            children: [
              Wrap(
                spacing: FdSpace.sm,
                runSpacing: FdSpace.sm,
                children: [
                  for (final h in detail.habitats)
                    Chip(
                      label: Text(h.name),
                      avatar: const Icon(Icons.water_rounded, size: 16, color: FdColors.lagoon),
                    ),
                ],
              ),
            ],
          ),
        _Section(
          title: l.distribution,
          children: [
            Text(
              detail.regions.isEmpty ? l.allStates : detail.regions.map((r) => r.name).join(', '),
              style: const TextStyle(color: FdColors.mist),
            ),
          ],
        ),
        _Section(
          title: l.conservation,
          children: [
            if (detail.conservation.isEmpty)
              Text(l.conservationNone, style: const TextStyle(color: FdColors.mist))
            else
              for (final c in detail.conservation)
                Text(
                  '${c.authority.toUpperCase()}: ${c.status}${c.year != null ? ' (${c.year})' : ''}',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
          ],
        ),
        if (detail.lookalikes.isNotEmpty)
          _Section(
            title: l.lookalikes,
            children: [
              for (final la in detail.lookalikes)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.compare_arrows_rounded, color: FdColors.sand),
                  title: Text(la.names.primary(locale)),
                  subtitle: Text(la.scientificName, style: const TextStyle(fontStyle: FontStyle.italic)),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () => context.push('/catalogue/${la.id}'),
                ),
            ],
          ),
        if (detail.images.any((i) => i.attribution != null)) ...[
          const SizedBox(height: FdSpace.xl),
          for (final i in detail.images.where((i) => i.attribution != null))
            Text('Photo: ${i.attribution} (${i.license})', style: theme.textTheme.bodySmall?.copyWith(color: FdColors.mist)),
        ],
      ],
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    if (children.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(top: FdSpace.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title.toUpperCase(),
            style: const TextStyle(color: FdColors.glow, fontSize: 12, fontWeight: FontWeight.w800, letterSpacing: 1.2),
          ),
          const SizedBox(height: FdSpace.sm),
          ...children,
        ],
      ),
    );
  }
}

class _Facts extends StatelessWidget {
  const _Facts({required this.rows});

  final List<(String, String)> rows;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: FdSpace.xl),
    child: Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: FdSpace.lg, vertical: FdSpace.sm),
        child: Column(
          children: [
            for (final (label, value) in rows)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: FdSpace.sm),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 120,
                      child: Text(label, style: const TextStyle(color: FdColors.mist)),
                    ),
                    Expanded(
                      child: Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
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
