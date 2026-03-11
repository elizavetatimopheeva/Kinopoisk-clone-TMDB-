import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kino/domain/api_client/api_client_exception.dart';
import 'package:kino/domain/entity/movie_details.dart';
import 'package:kino/domain/services/auth_service.dart';
import 'package:kino/domain/services/movie_service.dart';
import 'package:kino/library/widgets/localized_model.dart';
import 'package:kino/widgets/navigation/main_navigation.dart';

class MovieDetailsPosterData {
  final String? backdropPath;
  final String? posterPath;
  final bool isFavorite;
  IconData get favoriteIcon =>
      isFavorite ? Icons.favorite : Icons.favorite_outline;

  MovieDetailsPosterData({
    this.backdropPath,
    this.posterPath,
    this.isFavorite = false,
  });

  MovieDetailsPosterData copyWith({
    String? backdropPath,
    String? posterPath,
    bool? isFavorite,
  }) {
    return MovieDetailsPosterData(
      backdropPath: backdropPath ?? this.backdropPath,
      posterPath: posterPath ?? this.posterPath,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}

class MovieDetailsMovieNameData {
  final String title;
  final String year;

  MovieDetailsMovieNameData({required this.title, required this.year});
}

class MovieDetailsMovieScoreData {
  final double voteAverage;
  final String? trailerKey;

  MovieDetailsMovieScoreData({required this.voteAverage, this.trailerKey});
}

class MovieDetailsMovieActorData {
  final String name;
  final String character;
  final String? profilePath;

  MovieDetailsMovieActorData({
    required this.name,
    required this.character,
    this.profilePath,
  });
}

class MovieDetailsMoviePeopleData {
  final String name;
  final String job;

  MovieDetailsMoviePeopleData({required this.name, required this.job});
}

class MovieDetailsData {
  String title = "Загрузка..";
  bool isLoading = true;
  String overview = "";
  MovieDetailsPosterData posterData = MovieDetailsPosterData();
  MovieDetailsMovieNameData movieNameData = MovieDetailsMovieNameData(
    title: "",
    year: "",
  );
  MovieDetailsMovieScoreData movieScoreData = MovieDetailsMovieScoreData(
    voteAverage: 0.0,
  );

  String summary = "";

  List<List<MovieDetailsMoviePeopleData>> peopleData =
      const <List<MovieDetailsMoviePeopleData>>[];

  List<MovieDetailsMovieActorData> movieActorData =
      const <MovieDetailsMovieActorData>[];
}

class MovieDetailsModel extends ChangeNotifier {
  final _authService = AuthService();
  final _movieService = MovieService();

  final int movieId;
  final data = MovieDetailsData();
  final _localeStorage = LocalizedModelStorage();
  late DateFormat _dateFormat;

  MovieDetailsModel(this.movieId);

  Future<void> setupLocale(BuildContext context, Locale locale) async {
    if (!_localeStorage.updateLocale(locale)) return;
    _dateFormat = DateFormat.yMMMMd(_localeStorage.localeTag);
    updateData(null, false);
    await loadDetails(context);
  }

  void updateData(MovieDetails? details, bool isFavorite) {
    data.title = details?.title ?? "Загрузка..";
    data.isLoading = details == null;
    if (details == null) {
      notifyListeners();
      return;
    }

    data.overview = details.overview ?? "";
    data.posterData = MovieDetailsPosterData(
      backdropPath: details.backdropPath,
      posterPath: details.posterPath,
      isFavorite: isFavorite,
    );

    var year = details.releaseDate?.year.toString();
    year = year != null ? ' ($year)' : '';
    data.movieNameData = MovieDetailsMovieNameData(
      title: details.title,
      year: year,
    );

    final videos = details.videos.results.where(
      (video) => video.site == 'YouTube' && video.type == 'Trailer',
    );
    final trailerKey = videos.isNotEmpty == true ? videos.first.key : null;
    data.movieScoreData = MovieDetailsMovieScoreData(
      voteAverage: details.voteAverage * 10,
      trailerKey: trailerKey,
    );
    data.summary = makeSummary(details);
    data.peopleData = makePeopleData(details);
    data.movieActorData = details.credits.cast
        .map(
          (e) => MovieDetailsMovieActorData(
            name: e.name,
            character: e.character,
            profilePath: e.profilePath,
          ),
        )
        .toList();

    notifyListeners();
  }

  List<List<MovieDetailsMoviePeopleData>> makePeopleData(MovieDetails details) {
    var crew = details.credits.crew
        .map(
          (crew) => MovieDetailsMoviePeopleData(name: crew.name, job: crew.job),
        )
        .toList();

    crew = crew.length > 4 ? crew.sublist(0, 4) : crew;

    var crewChunks =
        <List<MovieDetailsMoviePeopleData>>[]; //массив массивов эмплои
    for (var i = 0; i < crew.length; i += 2) {
      crewChunks.add(
        crew.sublist(i, i + 2 > crew.length ? crew.length : i + 2),
      );
    }
    return crewChunks;
  }

  String makeSummary(MovieDetails details) {
    var texts = <String>[];

    final releaseDate = details.releaseDate;
    if (releaseDate != null) {
      texts.add(_dateFormat.format(releaseDate));
    }

    if (details.productionCountries.isNotEmpty) {
      texts.add('(${details.productionCountries.first.iso})');
    }

    final runtime = details.runtime ?? 0;

    final duration = Duration(minutes: runtime);
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    texts.add('${hours}h ${minutes}m');

    if (details.genres.isNotEmpty) {
      var genresNames = <String>[];
      for (var genr in details.genres) {
        genresNames.add(genr.name);
      }
      texts.add(genresNames.join(', '));
    }
    return texts.join(' ');
  }

  Future<void> loadDetails(BuildContext context) async {
    try {
      final details = await _movieService.loadDetails(
        movieId: movieId,
        locale: _localeStorage.localeTag,
      );

      updateData(details.details, details.isFavorite);
    } on ApiCLientException catch (e) {
      _handleApiCLientException(e, context);
    }
  }

  Future<void> toggleFavorite(BuildContext context) async {
    data.posterData = data.posterData.copyWith(
      isFavorite: !data.posterData.isFavorite,
    );
    notifyListeners();
    try {
      await _movieService.updateFavorite(
        isFavorite: data.posterData.isFavorite,
        movieId: movieId,
      );
    } on ApiCLientException catch (e) {
      _handleApiCLientException(e, context);
    }
  }

  void _handleApiCLientException(
    ApiCLientException exeption,
    BuildContext context,
  ) {
    switch (exeption.type) {
      case ApiCLientExceptionType.sessionExpired:
        _authService.logout();
        MainNavigation.resetNavigation(context);
        break;
      default:
        print(exeption);
    }
  }
}
