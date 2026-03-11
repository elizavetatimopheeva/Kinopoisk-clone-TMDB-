import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:kino/configuration/configuration.dart';
import 'package:kino/domain/api_client/movie_api_client.dart';
import 'package:kino/domain/entity/movie.dart';
import 'package:kino/domain/entity/popular_movie_response.dart';


abstract class NewsEvent {}

class NewsEventLoadNextPage extends NewsEvent {
  final String locale;

  NewsEventLoadNextPage(this.locale);
}

class NewsEventLoadReset extends NewsEvent {}

class NewsEventLoadSearchMovie extends NewsEvent {
  final String query;

  NewsEventLoadSearchMovie(this.query);
}

class NewsContainer {
  final List<Movie> movies;
  final int currentPage;
  final int totalPage;

  bool get isComplete => currentPage >= totalPage;

  const NewsContainer.inital()
      : movies = const <Movie>[],
        currentPage = 0,
        totalPage = 1;

  NewsContainer({
    required this.movies,
    required this.currentPage,
    required this.totalPage,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NewsContainer &&
          runtimeType == other.runtimeType &&
          movies == other.movies &&
          currentPage == other.currentPage &&
          totalPage == other.totalPage;

  @override
  int get hashCode =>
      movies.hashCode ^ currentPage.hashCode ^ totalPage.hashCode;

  NewsContainer copyWith({
    List<Movie>? movies,
    int? currentPage,
    int? totalPage,
  }) {
    return NewsContainer(
      movies: movies ?? this.movies,
      currentPage: currentPage ?? this.currentPage,
      totalPage: totalPage ?? this.totalPage,
    );
  }
}

class NewsState {
  final NewsContainer popularMovieContainer;
  final NewsContainer searchMovieContainer;
  final String searchQuery;

  bool get isSearchMode => searchQuery.isNotEmpty;
  List<Movie> get movies =>
      isSearchMode ? searchMovieContainer.movies : popularMovieContainer.movies;

  const NewsState.inital()
      : popularMovieContainer = const NewsContainer.inital(),
        searchMovieContainer = const NewsContainer.inital(),
        searchQuery = "";

  NewsState({
    required this.popularMovieContainer,
    required this.searchMovieContainer,
    required this.searchQuery,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NewsState &&
          runtimeType == other.runtimeType &&
          popularMovieContainer == other.popularMovieContainer &&
          searchMovieContainer == other.searchMovieContainer &&
          searchQuery == other.searchQuery;

  @override
  int get hashCode =>
      popularMovieContainer.hashCode ^
      searchMovieContainer.hashCode ^
      searchQuery.hashCode;

  NewsState copyWith({
    NewsContainer? popularMovieContainer,
    NewsContainer? searchMovieContainer,
    String? searchQuery,
  }) {
    return NewsState(
      popularMovieContainer:
          popularMovieContainer ?? this.popularMovieContainer,
      searchMovieContainer: searchMovieContainer ?? this.searchMovieContainer,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

class NewsBloc extends Bloc<NewsEvent, NewsState> {
  final _movieApiClient = MovieApiClient();

  NewsBloc(
    NewsState initialState,
  ) : super(initialState) {
    on<NewsEvent>((event, emit) async {
      if (event is NewsEventLoadNextPage) {
        await onMovieListEventLoadNextPage(event, emit);
      } else if (event is NewsEventLoadReset) {
        await onMovieListEventLoadReset(event, emit);
      } else if (event is NewsEventLoadSearchMovie) {
        await onMovieListEventLoadSearchMovie(event, emit);
      }
    }, transformer: sequential());
  }

  Future<void> onMovieListEventLoadNextPage(
    NewsEventLoadNextPage event,
    Emitter<NewsState> emit,
  ) async {
    if (state.isSearchMode) {
      final container = await _loadNextPage(
        state.searchMovieContainer,
        (nextPage) async {
          final result = await _movieApiClient.searchMovie(
            nextPage,
            event.locale,
            state.searchQuery,
            Configuration.apiKey,
          );
          return result;
        },
      );
      if (container != null) {
        final newState = state.copyWith(searchMovieContainer: container);
        emit(newState);
      }
    } else {
      final container = await _loadNextPage(
        state.popularMovieContainer,
        (nextPage) async {
          final result = await _movieApiClient.popularMovie(
            nextPage,
            event.locale,
            Configuration.apiKey,
          );
          return result;
        },
      );
      if (container != null) {
        final newState = state.copyWith(popularMovieContainer: container);
        emit(newState);
      }
    }
  }

  Future<NewsContainer?> _loadNextPage(
    NewsContainer container,
    Future<PopularMovieResponse> Function(int) loader,
  ) async {
    if (container.isComplete) return null;
    final nextPage = container.currentPage + 1;
    final result = await loader(nextPage);
    final movies = List<Movie>.from(container.movies)..addAll(result.movies);
    final newContainer = container.copyWith(
      movies: movies,
      currentPage: result.page,
      totalPage: result.totalPages,
    );
    return newContainer;
  }

  Future<void> onMovieListEventLoadReset(
    NewsEventLoadReset event,
    Emitter<NewsState> emit,
  ) async {
    emit(const NewsState.inital());
  }

  Future<void> onMovieListEventLoadSearchMovie(
    NewsEventLoadSearchMovie event,
    Emitter<NewsState> emit,
  ) async {
    if (state.searchQuery == event.query) return;
    final newState = state.copyWith(
      searchQuery: event.query,
      searchMovieContainer: const NewsContainer.inital(),
    );
    emit(newState);
  }
}