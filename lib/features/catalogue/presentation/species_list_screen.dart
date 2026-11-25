import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../../app/providers.dart';
import '../../../design_system/tokens.dart';
import '../../../design_system/widgets/feedback.dart';
import '../../../design_system/widgets/rarity_badge.dart';
import '../../../l10n/app_localizations.dart';
import '../catalogue_providers.dart';
import '../data/species.dart';

class SpeciesListScreen extends ConsumerStatefulWidget {
  const SpeciesListScreen({super.key});

  @override
  ConsumerState<SpeciesListScreen> createState() => _SpeciesListScreenState();
}

class _SpeciesListScreenState extends ConsumerState<SpeciesListScreen> {
  final _search = TextEditingController();
  final _scroll = ScrollController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _search.text = ref.read(speciesQueryProvider).q ?? '';
    _scroll.addListener(() {
      if (_scroll.position.pixels > _scroll.position.maxScrollExtent - 400) {
        ref.read(speciesListProvider.notifier).loadMore();
      }
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _search.dispose();
    _scroll.dispose();
    super.dispose();
  }

  void _onSearch(String text) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 350), () {
      final query = ref.read(speciesQueryProvider);
      ref.read(speciesQueryProvider.notifier).update(query.copyWith(q: text.trim()));
    });
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final list = ref.watch(speciesListProvider);
    final locale = ref.watch(localeCodeProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l.navCatalogue)),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(FdSpace.lg, 0, FdSpace.lg, FdSpace.sm),
            child: TextField(
              key: const Key('catalogue.search'),
              controller: _search,
              onChanged: _onSearch,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                hintText: l.searchHint,
                prefixIcon: const Icon(Icons.search_rounded),
                suffixIcon: _search.text.isEmpty
                    ? null
                    : IconButton(
                        icon: const Icon(Icons.close_rounded),
                        onPressed: () {
                          _search.clear();
                          _onSearch('');
                          setState(() {});
                        },
                      ),
              ),
            ),
          ),
          const _FilterBar(),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () => ref.refresh(speciesListProvider.future),
              child: AsyncValueView<SpeciesListState>(
                value: list,
                onRetry: () => ref.invalidate(speciesListProvider),
                data: (state) {
                  if (state.items.isEmpty) {
                    return ListView(
                      children: [
                        const SizedBox(height: 80),
                        EmptyState(icon: Icons.search_off_rounded, message: l.noSpeciesFound),
                      ],
                    );
                  }
                  return ListView.separated(
                    controller: _scroll,
                    padding: const EdgeInsets.fromLTRB(FdSpace.lg, FdSpace.sm, FdSpace.lg, FdSpace.xxl),
                    itemCount: state.items.length + (state.hasMore ? 1 : 0),
                    separatorBuilder: (_, _) => const SizedBox(height: FdSpace.sm),
                    itemBuilder: (context, i) {
                      if (i >= state.items.length) {
                        return const Padding(
                          padding: EdgeInsets.all(FdSpace.lg),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }
                      return SpeciesTile(species: state.items[i], locale: locale);
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterBar extends ConsumerWidget {
  const _FilterBar();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final q = ref.watch(speciesQueryProvider);
    final notifier = ref.read(speciesQueryProvider.notifier);

    Widget chip(String label, bool selected, VoidCallback onTap, {Key? key}) => Padding(
      padding: const EdgeInsets.only(right: FdSpace.sm),
      child: FilterChip(key: key, label: Text(label), selected: selected, onSelected: (_) => onTap(), showCheckmark: false),
    );

    final waters = {'freshwater': l.freshwater, 'brackish': l.brackish, 'marine': l.marine};
    final origins = {'native': l.native, 'introduced': l.introduced};

    return SizedBox(
      height: 44,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: FdSpace.lg),
        children: [
          chip(l.filterAll, !q.isFiltered, () => notifier.update(q.copyWith(waterType: null, origin: null, rarity: null, habitat: null))),
          for (final e in waters.entries)
            chip(
              e.value,
              q.waterType == e.key,
              () => notifier.update(q.copyWith(waterType: q.waterType == e.key ? null : e.key)),
              key: Key('filter.${e.key}'),
            ),
          for (final e in origins.entries)
            chip(e.value, q.origin == e.key, () => notifier.update(q.copyWith(origin: q.origin == e.key ? null : e.key))),
        ],
      ),
    );
  }
}

class SpeciesTile extends StatelessWidget {
  const SpeciesTile({super.key, required this.species, required this.locale});

  final SpeciesSummary species;
  final String locale;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final s = species;
    final stateLabel = switch (s.userState) {
      UserSpeciesState.collected => l.stateCollected,
      UserSpeciesState.seen => l.stateSeen,
      UserSpeciesState.unseen => null,
    };

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.push('/catalogue/${s.id}'),
        child: Padding(
          padding: const EdgeInsets.all(FdSpace.md),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(color: FdColors.reef, borderRadius: BorderRadius.circular(12)),
                clipBehavior: Clip.antiAlias,
                child: s.thumbnailUrl == null
                    ? const Icon(Icons.set_meal_rounded, color: FdColors.mist)
                    : CachedNetworkImage(imageUrl: s.thumbnailUrl!, fit: BoxFit.cover),
              ),
              const SizedBox(width: FdSpace.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      s.names.primary(locale),
                      style: Theme.of(context).textTheme.titleMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (s.names.secondary(locale) != null)
                      Text(
                        s.names.secondary(locale)!,
                        style: const TextStyle(color: FdColors.sand, fontSize: 13),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    Text(
                      s.scientificName,
                      style: const TextStyle(color: FdColors.mist, fontStyle: FontStyle.italic, fontSize: 13),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  RarityBadge(rarity: s.rarity),
                  if (stateLabel != null) ...[
                    const SizedBox(height: FdSpace.xs),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          s.userState == UserSpeciesState.collected ? Icons.style_rounded : Icons.visibility_outlined,
                          size: 14,
                          color: FdColors.lagoon,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          stateLabel,
                          style: const TextStyle(color: FdColors.lagoon, fontSize: 12, fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
