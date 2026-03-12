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
  List<Movie> get movies =>
       popularMovieContainer.movies;

  const NewsState.inital()
      : popularMovieContainer = const NewsContainer.inital();
   

  NewsState({
    required this.popularMovieContainer,
    
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NewsState &&
          runtimeType == other.runtimeType &&
          popularMovieContainer == other.popularMovieContainer;
        

  @override
  int get hashCode =>
      popularMovieContainer.hashCode;
   

  NewsState copyWith({
    NewsContainer? popularMovieContainer,

  }) {
    return NewsState(
      popularMovieContainer:
          popularMovieContainer ?? this.popularMovieContainer,
    
    );
  }
}

class NewsBloc extends Bloc<NewsEvent, NewsState> {
  final _movieApiClient = MovieApiClient();

  NewsBloc(
    super.initialState,
  ) {
    on<NewsEvent>((event, emit) async {
      if (event is NewsEventLoadNextPage) {
        await onMovieListEventLoadNextPage(event, emit);
      } else if (event is NewsEventLoadReset) {
        await onMovieListEventLoadReset(event, emit);
      } 
    }, transformer: sequential());
  }

  Future<void> onMovieListEventLoadNextPage(
    NewsEventLoadNextPage event,
    Emitter<NewsState> emit,
  ) async {
    
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

