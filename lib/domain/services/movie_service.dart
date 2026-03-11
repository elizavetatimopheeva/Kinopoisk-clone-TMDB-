import 'package:kino/configuration/configuration.dart';
import 'package:kino/domain/api_client/account_api_client.dart';
import 'package:kino/domain/api_client/movie_api_client.dart';
import 'package:kino/domain/data_provider/session_data_provider.dart';
import 'package:kino/domain/entity/popular_movie_response.dart';
import 'package:kino/domain/local_entity/movie_details_local.dart';

class MovieService {
  final _movieApiClient = MovieApiClient();
  final _sessionDataProvider = SessionDataProvider();
  final _accountApiClient = AccountApiClient();

  Future<PopularMovieResponse> popularMovie(int page, String locale) async =>
      _movieApiClient.popularMovie(page, locale, Configuration.apiKey);

  Future<PopularMovieResponse> searchMovie(
    int page,
    String locale,
    String query,
  ) async =>
      _movieApiClient.searchMovie(page, locale, query, Configuration.apiKey);

  Future<MovieDetailsLocal> loadDetails({
    required int movieId,
    required String locale,
  }) async {
    final movieDetails = await _movieApiClient.movieDetails(movieId, locale);
    final sessionId = await _sessionDataProvider.getSessionId();
    var isFavorite = false;
    if (sessionId != null) {
      isFavorite = await _movieApiClient.isFavorite(movieId, sessionId);
    }
    return MovieDetailsLocal(details: movieDetails, isFavorite: isFavorite);
  }

  // Future<void> toggleFavorite(BuildContext context) async {
  //   final sessionId = await _sessionDataProvider.getSessionId();
  //   final accountId = await _sessionDataProvider.getAccountId();

  //   if (sessionId == null || accountId == null) return;

  //   data.posterData = data.posterData.copyWith(
  //     isFavorite: !data.posterData.isFavorite,
  //   );
  //   notifyListeners();
  //   try {
  //     await _accountApiClient.markAsFavorite(
  //       accountId: accountId,
  //       sessionId: sessionId,
  //       mediaType: MediaType.movie,
  //       mediaId: movieId,
  //       isFavorite: data
  //           .posterData
  //           .isFavorite, //через восклицательный знак конвертим. если уже в фаворит то уберем, если нет то добавим
  //     );
  //   } on ApiCLientException catch (e) {
  //     _handleApiCLientException(e, context);
  //   }
  // }

  Future<void> updateFavorite({
    required bool isFavorite,
    required int movieId,
  }) async {
    final sessionId = await _sessionDataProvider.getSessionId();
    final accountId = await _sessionDataProvider.getAccountId();

    if (sessionId == null || accountId == null) return;

    await _accountApiClient.markAsFavorite(
      accountId: accountId,
      sessionId: sessionId,
      mediaType: MediaType.movie,
      mediaId: movieId,
      isFavorite:
          isFavorite, //через восклицательный знак конвертим. если уже в фаворит то уберем, если нет то добавим
    );
  }
}
