import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:kino/configuration/configuration.dart';
import 'package:kino/domain/api_client/movie_api_client.dart';
import 'package:kino/domain/entity/popular_tv.dart';
import 'package:kino/domain/entity/tv.dart';

abstract class TVShowListEvent {}

class TVShowListEventLoadNextPage extends TVShowListEvent {
  final String locale;

  TVShowListEventLoadNextPage(this.locale);
}

class TVShowListEventLoadReset extends TVShowListEvent {}

class TVShowListEventLoadSearchMovie extends TVShowListEvent {
  final String query;

  TVShowListEventLoadSearchMovie.TVShowListEventLoadSearchTV(this.query);
}

class TVShowListContainer {
  final List<TV> tvShows;
  final int currentPage;
  final int totalPage;

  bool get isComplete => currentPage >= totalPage;

  const TVShowListContainer.inital()
    : tvShows = const <TV>[],
      currentPage = 0,
      totalPage = 1;

  TVShowListContainer({
    required this.tvShows,
    required this.currentPage,
    required this.totalPage,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TVShowListContainer &&
          runtimeType == other.runtimeType &&
          tvShows == other.tvShows &&
          currentPage == other.currentPage &&
          totalPage == other.totalPage;

  @override
  int get hashCode =>
      tvShows.hashCode ^ currentPage.hashCode ^ totalPage.hashCode;

  TVShowListContainer copyWith({
    List<TV>? tvShows,
    int? currentPage,
    int? totalPage,
  }) {
    return TVShowListContainer(
      tvShows: tvShows ?? this.tvShows,
      currentPage: currentPage ?? this.currentPage,
      totalPage: totalPage ?? this.totalPage,
    );
  }
}

class TVShowListState {
  final TVShowListContainer popularTVShowsContainer;
  final TVShowListContainer searchTVShowsContainer;
  final String searchQuery;

  bool get isSearchMode => searchQuery.isNotEmpty;
  List<TV> get tvShows => isSearchMode
      ? searchTVShowsContainer.tvShows
      : popularTVShowsContainer.tvShows;

  const TVShowListState.inital()
    : popularTVShowsContainer = const TVShowListContainer.inital(),
      searchTVShowsContainer = const TVShowListContainer.inital(),
      searchQuery = "";

  TVShowListState({
    required this.popularTVShowsContainer,
    required this.searchTVShowsContainer,
    required this.searchQuery,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TVShowListState &&
          runtimeType == other.runtimeType &&
          popularTVShowsContainer == other.popularTVShowsContainer &&
          searchTVShowsContainer == other.searchTVShowsContainer &&
          searchQuery == other.searchQuery;

  @override
  int get hashCode =>
      popularTVShowsContainer.hashCode ^
      searchTVShowsContainer.hashCode ^
      searchQuery.hashCode;

  TVShowListState copyWith({
    TVShowListContainer? popularTVSHowsContainer,
    TVShowListContainer? searchTVSHowsContainer,
    String? searchQuery,
  }) {
    return TVShowListState(
      popularTVShowsContainer:
          popularTVSHowsContainer ?? this.popularTVShowsContainer,
      searchTVShowsContainer:
          searchTVSHowsContainer ?? this.searchTVShowsContainer,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

class TVShowListBloc extends Bloc<TVShowListEvent, TVShowListState> {
  final _movieApiClient = MovieApiClient();

  TVShowListBloc(TVShowListState initialState) : super(initialState) {
    on<TVShowListEvent>((event, emit) async {
      if (event is TVShowListEventLoadNextPage) {
        await onTVShowListEventLoadNextPage(event, emit);
      } else if (event is TVShowListEventLoadReset) {
        await onTVShowListEventLoadReset(event, emit);
      } else if (event is TVShowListEventLoadSearchMovie) {
        await onTVShowListEventLoadSearchMovie(event, emit);
      }
    }, transformer: sequential());
  }

  Future<void> onTVShowListEventLoadNextPage(
    TVShowListEventLoadNextPage event,
    Emitter<TVShowListState> emit,
  ) async {
    if (state.isSearchMode) {
      final container = await _loadNextPage(state.searchTVShowsContainer, (
        nextPage,
      ) async {
        final result = await _movieApiClient.searchTVShow(
          nextPage,
          event.locale,
          state.searchQuery,
          Configuration.apiKey,
        );
        return result;
      });
      if (container != null) {
        final newState = state.copyWith(searchTVSHowsContainer: container);
        emit(newState);
      }
    } else {
      final container = await _loadNextPage(state.popularTVShowsContainer, (
        nextPage,
      ) async {
        final result = await _movieApiClient.popularTV(
          nextPage,
          event.locale,
          Configuration.apiKey,
        );
        return result;
      });
      if (container != null) {
        final newState = state.copyWith(popularTVSHowsContainer: container);
        emit(newState);
      }
    }
  }

  Future<TVShowListContainer?> _loadNextPage(
    TVShowListContainer container,
    Future<PopularTVResponse> Function(int) loader,
  ) async {
    if (container.isComplete) return null;
    final nextPage = container.currentPage + 1;
    final result = await loader(nextPage);
    final tv = List<TV>.from(container.tvShows)..addAll(result.tv);
    final newContainer = container.copyWith(
      tvShows: tv,
      currentPage: result.page,
      totalPage: result.totalPages,
    );
    return newContainer;
  }

  Future<void> onTVShowListEventLoadReset(
    TVShowListEventLoadReset event,
    Emitter<TVShowListState> emit,
  ) async {
    emit(const TVShowListState.inital());
  }

  Future<void> onTVShowListEventLoadSearchMovie(
    TVShowListEventLoadSearchMovie event,
    Emitter<TVShowListState> emit,
  ) async {
    if (state.searchQuery == event.query) return;
    final newState = state.copyWith(
      searchQuery: event.query,
      searchTVSHowsContainer: const TVShowListContainer.inital(),
    );
    emit(newState);
  }
}
