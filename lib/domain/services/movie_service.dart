import 'package:kino/domain/api_client/account_api_client.dart';
import 'package:kino/domain/api_client/movie_api_client.dart';
import 'package:kino/domain/data_provider/session_data_provider.dart';
import 'package:kino/domain/local_entity/movie_details_local.dart';

class MovieService {
  final _movieApiClient = MovieApiClient();
  final _sessionDataProvider = SessionDataProvider();
  final _accountApiClient = AccountApiClient();


  Future<MovieDetailsLocal> loadMovieDetails({required int movieId, required String locale}) async {
    final movieDetails = await _movieApiClient.movieDetails(movieId, locale);
    final sessionId = await _sessionDataProvider.getSessionId();
     var isFavorite = false;
    var isWatchList = false;
    var rating = 0.0;
    if (sessionId != null) {
      isFavorite = await _movieApiClient.isMovieFavorite(movieId, sessionId);
      isWatchList = await _movieApiClient.isMovieWatchList(movieId, sessionId);
      rating = await _movieApiClient.isMovieRated(movieId, sessionId);
    }
    return MovieDetailsLocal(details: movieDetails, isFavorite: isFavorite, isWatchList: isWatchList, rating: rating);
  }

  Future<TVDetailsLocal> loadTVShowDetails({required int seriesId, required String locale}) async {
    final tvShowDetails = await _movieApiClient.tvDetails(seriesId, locale);
    final sessionId = await _sessionDataProvider.getSessionId();
     var isFavorite = false;
    var isWatchList = false;
    var rating = 0.0;
    if (sessionId != null) {
      isFavorite = await _movieApiClient.isTVShowFavorite(seriesId, sessionId);
      isWatchList = await _movieApiClient.isTVShowWatchList(seriesId, sessionId);
      rating = await _movieApiClient.isTVShowRated(seriesId, sessionId);}
    return TVDetailsLocal(details: tvShowDetails, isFavorite: isFavorite, isWatchList: isWatchList, rating: rating);
  }


  Future<void> updateFavorite({required int mediaId, required bool isFavorite, required MediaType type}) =>
      _updateMediaStatus(mediaId: mediaId, value: isFavorite, type: type, isFavoriteAction: true);

  Future<void> updateWatchList({required int mediaId, required bool isWatchList, required MediaType type}) =>
      _updateMediaStatus(mediaId: mediaId, value: isWatchList, type: type, isFavoriteAction: false);

  Future<void> _updateMediaStatus({
    required int mediaId,
    required bool value,
    required MediaType type,
    required bool isFavoriteAction,
  }) async {
    final sessionId = await _sessionDataProvider.getSessionId();
    final accountId = await _sessionDataProvider.getAccountId();
    if (sessionId == null || accountId == null) return;

    if (isFavoriteAction) {
      await _accountApiClient.markAsFavorite(
        accountId: accountId, sessionId: sessionId, mediaType: type, mediaId: mediaId, isFavorite: value,
      );
    } else {
      await _accountApiClient.markAsWatchList(
        accountId: accountId, sessionId: sessionId, mediaType: type, mediaId: mediaId, isWatchList: value,
      );
    }
  }
}