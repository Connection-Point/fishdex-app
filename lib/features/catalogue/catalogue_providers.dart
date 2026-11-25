import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import 'data/catalogue_repository.dart';
import 'data/species.dart';

/// Current search + filters on the catalogue screen.
final speciesQueryProvider = NotifierProvider<SpeciesQueryController, SpeciesQuery>(SpeciesQueryController.new);

class SpeciesQueryController extends Notifier<SpeciesQuery> {
  @override
  SpeciesQuery build() => const SpeciesQuery();

  void update(SpeciesQuery query) => state = query;
}

class SpeciesListState {
  const SpeciesListState({this.items = const [], this.nextCursor, this.loadingMore = false, this.loadMoreError});

  final List<SpeciesSummary> items;
  final String? nextCursor;
  final bool loadingMore;
  final Object? loadMoreError;

  bool get hasMore => nextCursor != null;
}

/// Cursor-paginated species list; rebuilds when the query changes.
final speciesListProvider = AsyncNotifierProvider<SpeciesListController, SpeciesListState>(SpeciesListController.new);

class SpeciesListController extends AsyncNotifier<SpeciesListState> {
  @override
  Future<SpeciesListState> build() async {
    final query = ref.watch(speciesQueryProvider);
    final page = await ref.watch(catalogueRepositoryProvider).search(query);
    return SpeciesListState(items: page.items, nextCursor: page.nextCursor);
  }

  Future<void> loadMore() async {
    final current = state.value;
    if (current == null || !current.hasMore || current.loadingMore) return;

    state = AsyncData(SpeciesListState(items: current.items, nextCursor: current.nextCursor, loadingMore: true));
    try {
      final page = await ref.read(catalogueRepositoryProvider).search(ref.read(speciesQueryProvider), cursor: current.nextCursor);
      state = AsyncData(SpeciesListState(items: [...current.items, ...page.items], nextCursor: page.nextCursor));
    } catch (e) {
      state = AsyncData(SpeciesListState(items: current.items, nextCursor: current.nextCursor, loadMoreError: e));
    }
  }
}

/// Species detail, re-fetched when the UI language changes (names/habitats are localised server-side).
final speciesDetailProvider = FutureProvider.autoDispose.family<SpeciesDetail, String>((ref, id) {
  ref.watch(localeCodeProvider);
  return ref.watch(catalogueRepositoryProvider).detail(id);
});
