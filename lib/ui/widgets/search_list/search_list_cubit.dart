import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:kino/domain/blocs/movie_list_bloc.dart';
import 'package:kino/domain/blocs/tv_show_list_bloc.dart';
import 'package:kino/domain/entity/movie.dart';
import 'package:kino/domain/entity/tv.dart';

class ListRowData {
  final int id;
  final String? posterPath;
  final String title;
  final String releaseDate;
  final String overview;

  ListRowData({
    required this.id,
    required this.posterPath,
    required this.title,
    required this.releaseDate,
    required this.overview,
  });
}

class GeneralState {
  final List<ListRowData> items;
  final String localeTag;

  const GeneralState({required this.items, required this.localeTag});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GeneralState &&
          runtimeType == other.runtimeType &&
          items == other.items &&
          localeTag == other.localeTag;

  @override
  int get hashCode => items.hashCode ^ localeTag.hashCode;

  GeneralState copyWith({List<ListRowData>? items, String? localeTag}) {
    return GeneralState(
      items: items ?? this.items,
      localeTag: localeTag ?? this.localeTag,
    );
  }
}

abstract class BaseListCubit<Entity, PState> extends Cubit<GeneralState> {
  final Bloc<dynamic, PState> generalBloc;
  late final StreamSubscription<PState> generalSubscription;
  late DateFormat _dateFormat;
  Timer? searchDebounce;

  BaseListCubit({required this.generalBloc})
    : super(const GeneralState(items: <ListRowData>[], localeTag: "")) {
    Future.microtask(() {
      _onState(generalBloc.state);
      generalSubscription = generalBloc.stream.listen(_onState);
    });
  }

  List<Entity> getEntitiesFromState(PState state);
  ListRowData makeRowData(Entity entity, DateFormat dateFormat);
  void sendLoadNextPageEvent(String localeTag);
  void sendLoadResetEvent();
  void sendSearchEvent(String text);

  void _onState(PState state) {
    final entities = getEntitiesFromState(state);
    final items = entities.map((e) => makeRowData(e, _dateFormat)).toList();
    emit(this.state.copyWith(items: items));
  }

  void setupLocale(String localeTag) {
    if (state.localeTag == localeTag) return;
    _dateFormat = DateFormat.yMMMMd(localeTag);
    emit(state.copyWith(localeTag: localeTag));

    sendLoadResetEvent();
    sendLoadNextPageEvent(localeTag);
  }

  void showedItemAtIndex(int index) {
    if (index < state.items.length - 1) return;
    sendLoadNextPageEvent(state.localeTag);
  }

  void search(String text) {
    searchDebounce?.cancel();
    searchDebounce = Timer(const Duration(milliseconds: 300), () {
      sendSearchEvent(text);
      sendLoadNextPageEvent(state.localeTag);
    });
  }

  @override
  Future<void> close() {
    generalSubscription.cancel();
    searchDebounce?.cancel();
    return super.close();
  }
}

class MovieListCubit extends BaseListCubit<Movie, MovieListState> {
  MovieListCubit({required MovieListBloc movieListBloc})
    : super(generalBloc: movieListBloc);

  @override
  List<Movie> getEntitiesFromState(MovieListState state) => state.movies;

  @override
  ListRowData makeRowData(Movie movie, DateFormat dateFormat) {
    return ListRowData(
      id: movie.id,
      posterPath: movie.posterPath,
      title: movie.title,
      releaseDate: movie.releaseDate != null
          ? dateFormat.format(movie.releaseDate!)
          : '',
      overview: movie.overview,
    );
  }

  @override
  void sendLoadNextPageEvent(String localeTag) =>
      generalBloc.add(MovieListEventLoadNextPage(localeTag));
  @override
  void sendLoadResetEvent() => generalBloc.add(MovieListEventLoadReset());
  @override
  void sendSearchEvent(String text) =>
      generalBloc.add(MovieListEventLoadSearchMovie(text));
}

class TVShowListCubit extends BaseListCubit<TV, TVShowListState> {
  TVShowListCubit({required TVShowListBloc tvShowListBloc})
    : super(generalBloc: tvShowListBloc);

  @override
  List<TV> getEntitiesFromState(TVShowListState state) => state.tvShows;

  @override
  ListRowData makeRowData(TV tvShow, DateFormat dateFormat) {
    return ListRowData(
      id: tvShow.id,
      posterPath: tvShow.posterPath,
      title: tvShow.name,
      releaseDate: tvShow.firstAirDate != null
          ? dateFormat.format(tvShow.firstAirDate!)
          : '',
      overview: tvShow.overview,
    );
  }

  @override
  void sendLoadNextPageEvent(String localeTag) =>
      generalBloc.add(TVShowListEventLoadNextPage(localeTag));
  @override
  void sendLoadResetEvent() => generalBloc.add(TVShowListEventLoadReset());
  @override
  void sendSearchEvent(String text) => generalBloc.add(
    TVShowListEventLoadSearchMovie.TVShowListEventLoadSearchTV(text),
  );
}
