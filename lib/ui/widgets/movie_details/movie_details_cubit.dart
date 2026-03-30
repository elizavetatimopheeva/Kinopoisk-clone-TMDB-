import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kino/domain/api_client/account_api_client.dart';
import 'package:kino/domain/api_client/api_client_exception.dart';
import 'package:kino/domain/blocs/movie_details_event.dart';
import 'package:kino/domain/local_entity/movie_details_local.dart';
import 'package:kino/domain/services/auth_service.dart';
import 'package:kino/domain/services/movie_service.dart';
import 'package:kino/library/widgets/localized_model.dart';
import 'package:kino/ui/navigation/main_navigation.dart';
import 'package:kino/ui/widgets/movie_details/data_classes/movie_details_data_classes.dart';

class DetailsData {
  final String title;
  final bool isLoading;
  final String overview;
  final DetailsPosterData posterData;
  final DetailsNameData nameData;
  final DetailScoreData scoreData;
  final String summary;
  final String genres;
  final List<DetailsPeopleData> peopleData;
  final List<DetailsActorData> actorsData;
  final List<DetailsPhotoData> photos;

  DetailsData({
    required this.title,
    required this.isLoading,
    required this.overview,
    required this.posterData,
    required this.nameData,
    required this.scoreData,
    required this.summary,
    required this.genres,
    required this.peopleData,
    required this.actorsData,
    required this.photos,
  });

  DetailsData copyWith({
    String? title,
    bool? isLoading,
    String? overview,
    DetailsPosterData? posterData,
    DetailsNameData? nameData,
    DetailScoreData? scoreData,
    String? summary,
    String? genres,
    List<DetailsPeopleData>? peopleData,
    List<DetailsActorData>? actorsData,
    List<DetailsPhotoData>? photos,
  }) {
    return DetailsData(
      title: title ?? this.title,
      isLoading: isLoading ?? this.isLoading,
      overview: overview ?? this.overview,
      posterData: posterData ?? this.posterData,
      nameData: nameData ?? this.nameData,
      scoreData: scoreData ?? this.scoreData,
      summary: summary ?? this.summary,
      genres: genres ?? this.genres,
      peopleData: peopleData ?? this.peopleData,
      actorsData: actorsData ?? this.actorsData,
      photos: photos ?? this.photos,
    );
  }

  static DetailsData initial() {
    return DetailsData(
      title: "Загрузка...",
      isLoading: true,
      overview: '',
      posterData: DetailsPosterData(),
      nameData: DetailsNameData(name: '', year: ''),
      scoreData: DetailScoreData(voteAverage: 0),
      summary: '',
      genres: '',
      peopleData: const [],
      actorsData: const [],
      photos: const [],
    );
  }
}

abstract class BaseDetailsBloc<T>
    extends Bloc<MovieDetailsEvent, MovieDetailsState> {
  final _authService = AuthService();
  final int detailsId;
  final _localeStorage = LocalizedModelStorage();
  bool _isLocaleSet = false;

  BaseDetailsBloc({required this.detailsId})
    : super(MovieDetailsInitialState()) {
    on<MovieDetailsSetupLocaleEvent>(_onSetupLocale);
    on<MovieDetailsLoadEvent>(_onLoadDetails);
    on<MovieDetailsToggleFavoriteEvent>(_onToggleFavorite);
    on<MovieDetailsToggleWatchListEvent>(_onToggleWatchList);
  }


  Future<T> loadDetailsApi(int id, String locale);
  Future<void> updateFavoriteApi(int id, bool isFavorite);
  Future<void> updateWatchListApi(int id, bool isWatchList);
  DetailsData mapToDetailsData(T details, String locale);

  void setupLocale(BuildContext context, Locale locale) {
    add(MovieDetailsSetupLocaleEvent(context: context, locale: locale));
  }

  Future<void> _onSetupLocale(
    MovieDetailsSetupLocaleEvent event,
    Emitter<MovieDetailsState> emit,
  ) async {
    if (!_localeStorage.updateLocale(event.locale)) return;
    _isLocaleSet = true;
    add(MovieDetailsLoadEvent(context: event.context));
  }

  Future<void> _onLoadDetails(
    MovieDetailsLoadEvent event,
    Emitter<MovieDetailsState> emit,
  ) async {
    if (!_isLocaleSet) return;
    emit(MovieDetailsLoadingState());
    try {
      final details = await loadDetailsApi(detailsId, _localeStorage.localeTag);
      final data = mapToDetailsData(details, _localeStorage.localeTag);
      emit(MovieDetailsLoadedState(data: data));
    } catch (e) {
      _handleError(e, event.context, emit);
    }
  }

  Future<void> _onToggleFavorite(
    MovieDetailsToggleFavoriteEvent event,
    Emitter<MovieDetailsState> emit,
  ) async {
    if (state is! MovieDetailsLoadedState) return;
    final currentState = state as MovieDetailsLoadedState;
    final newStatus = !currentState.data.posterData.isFavorite;

    final updatedData = currentState.data.copyWith(
      posterData: currentState.data.posterData.copyWith(isFavorite: newStatus),
    );
    emit(MovieDetailsLoadedState(data: updatedData));

    try {
      await updateFavoriteApi(detailsId, newStatus);
    } catch (e) {
      emit(
        MovieDetailsLoadedState(data: currentState.data),
      );
    }
  }

  Future<void> _onToggleWatchList(
    MovieDetailsToggleWatchListEvent event,
    Emitter<MovieDetailsState> emit,
  ) async {
    if (state is! MovieDetailsLoadedState) return;
    final currentState = state as MovieDetailsLoadedState;
    final newStatus = !currentState.data.posterData.isWatchList;

    final updatedData = currentState.data.copyWith(
      posterData: currentState.data.posterData.copyWith(isWatchList: newStatus),
    );
    emit(MovieDetailsLoadedState(data: updatedData));

    try {
      await updateWatchListApi(detailsId, newStatus);
    } catch (e) {
      emit(MovieDetailsLoadedState(data: currentState.data));
    }
  }

  void _handleError(
    Object e,
    BuildContext context,
    Emitter<MovieDetailsState> emit,
  ) {
    if (e is ApiClientException &&
        e.type == ApiClientExceptionType.sessionExpired) {
      _authService.logout();
      MainNavigation.resetNavigation(context);
    }
    emit(MovieDetailsErrorState(message: e.toString()));
  }
}

class MovieDetailsBloc extends BaseDetailsBloc<MovieDetailsLocal> {
  final _movieService = MovieService();

  MovieDetailsBloc({required int movieId}) : super(detailsId: movieId);

  @override
  Future<MovieDetailsLocal> loadDetailsApi(int id, String locale) =>
      _movieService.loadMovieDetails(movieId: id, locale: locale);

  @override
  Future<void> updateFavoriteApi(int id, bool isFavorite) =>
      _movieService.updateFavorite(
        mediaId: id,
        isFavorite: isFavorite,
        type: MediaType.movie,
      );

  @override
  Future<void> updateWatchListApi(int id, bool isWatchList) =>
      _movieService.updateWatchList(
        mediaId: id,
        isWatchList: isWatchList,
        type: MediaType.movie,
      );

  @override
  DetailsData mapToDetailsData(MovieDetailsLocal details, String locale) {
    final movie = details.details;

    final year = movie.releaseDate != null ? ' ${movie.releaseDate!.year}' : '';

    return DetailsData(
      title: movie.title,
      isLoading: false,
      overview: movie.overview ?? '',
      posterData: DetailsPosterData(
        backdropPath: movie.backdropPath,
        posterPath: movie.posterPath,
        isFavorite: details.isFavorite,
        isWatchList: details.isWatchList,
        rating: details.rating,
      ),
      nameData: DetailsNameData(name: movie.title, year: year),
      scoreData: DetailScoreData(
        voteAverage: movie.voteAverage * 10,
        voteCount: NumberFormat(
          '#,###',
          locale,
        ).format(movie.voteCount).replaceAll(',', ' '),
      ),
      summary:
          "${movie.productionCountries.firstOrNull?.iso ?? ''}, ${movie.runtime} мин",
      genres: movie.genres.map((e) => e.name).join(', '),
      peopleData: movie.credits.crew
          .map((e) => DetailsPeopleData(name: e.name, job: e.job))
          .toList(),
      actorsData: movie.credits.cast
          .map(
            (e) => DetailsActorData(
              name: e.name,
              character: e.character,
              profilePath: e.profilePath,
            ),
          )
          .toList(),
      photos: movie.images.backdrops
          .map((e) => DetailsPhotoData(filePath: e.filePath))
          .toList(),
    );
  }
}

class TVDetailsBloc extends BaseDetailsBloc<TVDetailsLocal> {
  final _movieService = MovieService();

  TVDetailsBloc({required int tvId}) : super(detailsId: tvId);

  @override
  Future<TVDetailsLocal> loadDetailsApi(int id, String locale) =>
      _movieService.loadTVShowDetails(seriesId: id, locale: locale);

  @override
  Future<void> updateFavoriteApi(int id, bool isFavorite) => _movieService
      .updateFavorite(mediaId: id, isFavorite: isFavorite, type: MediaType.tv);

  @override
  Future<void> updateWatchListApi(int id, bool isWatchList) =>
      _movieService.updateWatchList(
        mediaId: id,
        isWatchList: isWatchList,
        type: MediaType.tv,
      );

  @override
  DetailsData mapToDetailsData(TVDetailsLocal details, String locale) {
    final tv = details.details;

    final year = tv.firstAirDate != null ? ' ${tv.firstAirDate!.year}' : '';

    return DetailsData(
      title: tv.name, 
      isLoading: false,
      overview: tv.overview,
      posterData: DetailsPosterData(
        backdropPath: tv.backdropPath,
        posterPath: tv.posterPath,
        isFavorite: details.isFavorite,
        isWatchList: details.isWatchList,
        rating: details.rating,
      ),
      nameData: DetailsNameData(name: tv.name, year: year),
      scoreData: DetailScoreData(
        voteAverage: tv.voteAverage * 10,
        voteCount: tv.voteCount.toString(),
      ),
      summary:
          "${tv.originCountry.firstOrNull ?? ''}, серии: ${tv.numberOfEpisodes}",
      genres: tv.genres.map((e) => e.name).join(', '),
      peopleData: tv.credits.crew
          .map((e) => DetailsPeopleData(name: e.name, job: e.job))
          .toList(),
      actorsData: tv.credits.cast
          .map(
            (e) => DetailsActorData(
              name: e.name,
              character: e.character,
              profilePath: e.profilePath,
            ),
          )
          .toList(),
      photos: tv.images.backdrops
          .map((e) => DetailsPhotoData(filePath: e.filePath))
          .toList(),
    );
  }
}
