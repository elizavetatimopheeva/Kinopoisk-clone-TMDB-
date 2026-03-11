import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:intl/intl.dart';
import 'package:kino/domain/blocs/movie_list_bloc.dart';
import 'package:kino/domain/blocs/news_bloc.dart';
import 'package:kino/domain/entity/movie.dart';

class NewsRowData {
  final int id;
  final String? posterPath;
  final String title;
  final String releaseDate;
  final String overview;

  NewsRowData({
    required this.id,
    required this.posterPath,
    required this.title,
    required this.releaseDate,
    required this.overview,
  });
}

class NewsCubitState {
  final List<NewsRowData> movies;
  final String localeTag;

  const NewsCubitState({required this.movies, required this.localeTag});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NewsCubitState &&
          runtimeType == other.runtimeType &&
          movies == other.movies &&
          localeTag == other.localeTag;

  @override
  int get hashCode => movies.hashCode ^ localeTag.hashCode;

  NewsCubitState copyWith({
    List<NewsRowData>? movies,
    String? localeTag,
  }) {
    return NewsCubitState(
      movies: movies ?? this.movies,
      localeTag: localeTag ?? this.localeTag,
    );
  }
}

class NewsCubit extends Cubit<NewsCubitState> {
  final NewsBloc newsBloc;
  late final StreamSubscription<NewsState> movieListBlocSubscription;
  late DateFormat _dateFormat;
  Timer? searchDebounce;

  NewsCubit({required this.newsBloc})
    : super(
        const NewsCubitState(movies: <NewsRowData>[], localeTag: ""),
      ) {
    Future.microtask(() {
      _onState(newsBloc.state);
      movieListBlocSubscription = newsBloc.stream.listen(_onState);
    });
  }

  void _onState(NewsState state) {
    final movies = state.movies.map(_makeRowData).toList();
    final newState = this.state.copyWith(movies: movies);
    emit(newState);
  }

  void setupLocale(String localeTag) {
    if (state.localeTag == localeTag) return;
    final newState = state.copyWith(localeTag: localeTag);
    emit(newState);
    _dateFormat = DateFormat.yMMMMd(localeTag);
    newsBloc.add(NewsEventLoadReset());
    newsBloc.add(NewsEventLoadNextPage(localeTag));
  }

  void showedMovieAtIndex(int index) {
    if (index < state.movies.length - 1) return;
    newsBloc.add(NewsEventLoadNextPage(state.localeTag));
  }

  void searchMovie(String text) async {
    searchDebounce?.cancel();
    searchDebounce = Timer(const Duration(milliseconds: 300), () async {
      newsBloc.add(NewsEventLoadSearchMovie(text));
      newsBloc.add(NewsEventLoadNextPage(state.localeTag));
    });
  }

  @override
  Future<void> close() {
    movieListBlocSubscription.cancel();
    return super.close();
  }

  NewsRowData _makeRowData(Movie movie) {
    final releaseDate = movie.releaseDate;
    final releaseDateTitle = releaseDate != null
        ? _dateFormat.format(releaseDate)
        : '';
    return NewsRowData(
      id: movie.id,
      posterPath: movie.posterPath,
      title: movie.title,
      releaseDate: releaseDateTitle,
      overview: movie.overview,
    );
  }
}
