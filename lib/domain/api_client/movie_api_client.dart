import 'package:kino/configuration/configuration.dart';
import 'package:kino/domain/api_client/network_client.dart';
import 'package:kino/domain/entity/movie_details.dart';
import 'package:kino/domain/entity/popular_movie_response.dart';
import 'package:kino/domain/entity/popular_tv.dart';
import 'package:kino/domain/entity/tv_details.dart';

/*
1)нет сети
2)нет ответа, таймаут соединения

3) сервер недоступен
4) сервер не может обработать запрашиваемый запрос
5) сервер ответил не то что мы ожидали

6) сервер ответил ожидаемой ошибкой
 */

class MovieApiClient {
  final _networkClient = NetworkClient();

  Future<PopularMovieResponse> popularMovie(
    int page,
    String locale,
    String apiKey,
  ) async {
    PopularMovieResponse parser(dynamic json) {
      final jsonMap = json as Map<String, dynamic>;
      final response = PopularMovieResponse.fromJson(jsonMap);
      return response;
    }

    final result = _networkClient.get(
      '/movie/popular',
      parser,
      <String, dynamic>{
        'api_key': apiKey,
        'page': page.toString(),
        'language': locale,
      },
    );
    return result;
  }

  Future<PopularTVResponse> popularTV(
    int page,
    String locale,
    String apiKey,
  ) async {
    PopularTVResponse parser(dynamic json) {
      final jsonMap = json as Map<String, dynamic>;
      final response = PopularTVResponse.fromJson(jsonMap);
      return response;
    }

    final result = _networkClient.get('/tv/popular', parser, <String, dynamic>{
      'api_key': apiKey,
      'page': page.toString(),
      'language': locale,
    });
    return result;
  }

  Future<PopularTVResponse> searchTVShow(
    int page,
    String locale,
    String query,
    String apiKey,
  ) async {
    PopularTVResponse parser(dynamic json) {
      final jsonMap = json as Map<String, dynamic>;
      final response = PopularTVResponse.fromJson(jsonMap);
      return response;
    }

    final result = _networkClient.get('/search/tv', parser, <String, dynamic>{
      'api_key': apiKey,
      'page': page.toString(),
      'language': locale,
      'query': query,
      'include_adult': true.toString(),
    });
    return result;
  }

  Future<PopularMovieResponse> searchMovie(
    int page,
    String locale,
    String query,
    String apiKey,
  ) async {
    PopularMovieResponse parser(dynamic json) {
      final jsonMap = json as Map<String, dynamic>;
      final response = PopularMovieResponse.fromJson(jsonMap);
      return response;
    }

    final result = _networkClient
        .get('/search/movie', parser, <String, dynamic>{
          'api_key': apiKey,
          'page': page.toString(),
          'language': locale,
          'query': query,
          'include_adult': true.toString(),
        });
    return result;
  }

  Future<MovieDetails> movieDetails(int movieId, String locale) async {
    MovieDetails parser(dynamic json) {
      final jsonMap = json as Map<String, dynamic>;
      final response = MovieDetails.fromJson(jsonMap);
      return response;
    }

    final result = _networkClient
        .get('/movie/$movieId', parser, <String, dynamic>{
          'append_to_response': 'credits,videos,images',
          'api_key': Configuration.apiKey,
          'language': locale,
          'include_image_language': 'en,null',
        });
    return result;
  }

  Future<TvShowDetails> tvDetails(int seriesId, String locale) async {
    TvShowDetails parser(dynamic json) {
      final jsonMap = json as Map<String, dynamic>;
      final response = TvShowDetails.fromJson(jsonMap);
      return response;
    }

    final result = _networkClient
        .get('/tv/$seriesId', parser, <String, dynamic>{
          'append_to_response': 'credits,videos,images',
          'api_key': Configuration.apiKey,
          'language': locale,
          'include_image_language': 'en,null',
        });
    return result;
  }

  Future<bool> isMovieFavorite(int movieId, String sessionId) async {
    bool parser(dynamic json) {
      final jsonMap = json as Map<String, dynamic>;
      final result = jsonMap['favorite'] as bool;
      return result;
    }

    final result = _networkClient.get(
      '/movie/$movieId/account_states',
      parser,
      <String, dynamic>{
        'api_key': Configuration.apiKey,
        'session_id': sessionId,
      },
    );
    return result;
  }

  Future<double> isMovieRated(int movieId, String sessionId) async {
    double parser(dynamic json) {
      final jsonMap = json as Map<String, dynamic>;
      final rated = jsonMap['rated'];

      if (rated == false) {
        return -1;
      }
      final response = rated as Map<String, dynamic>;
      final result = response['value'] as double;
      return result;
    }

    final result = _networkClient.get(
      '/movie/$movieId/account_states',
      parser,
      <String, dynamic>{
        'api_key': Configuration.apiKey,
        'session_id': sessionId,
      },
    );
    return result;
  }

  Future<bool> isMovieWatchList(int movieId, String sessionId) async {
    bool parser(dynamic json) {
      final jsonMap = json as Map<String, dynamic>;
      final result = jsonMap['watchlist'] as bool;
      return result;
    }

    final result = _networkClient.get(
      '/movie/$movieId/account_states',
      parser,
      <String, dynamic>{
        'api_key': Configuration.apiKey,
        'session_id': sessionId,
      },
    );
    return result;
  }


Future<bool> isTVShowFavorite(int seriesId, String sessionId) async {
    bool parser(dynamic json) {
      final jsonMap = json as Map<String, dynamic>;
      final result = jsonMap['favorite'] as bool;
      return result;
    }

    final result = _networkClient.get(
      '/tv/$seriesId/account_states',
      parser,
      <String, dynamic>{
        'api_key': Configuration.apiKey,
        'session_id': sessionId,
      },
    );
    return result;
  }

  Future<double> isTVShowRated(int seriesId, String sessionId) async {
    double parser(dynamic json) {
      final jsonMap = json as Map<String, dynamic>;
      final rated = jsonMap['rated'];

      if (rated == false) {
        return -1;
      }
      final response = rated as Map<String, dynamic>;
      final result = response['value'] as double;
      return result;
    }

    final result = _networkClient.get(
      '/tv/$seriesId/account_states',
      parser,
      <String, dynamic>{
        'api_key': Configuration.apiKey,
        'session_id': sessionId,
      },
    );
    return result;
  }

  Future<bool> isTVShowWatchList(int seriesId, String sessionId) async {
    bool parser(dynamic json) {
      final jsonMap = json as Map<String, dynamic>;
      final result = jsonMap['watchlist'] as bool;
      return result;
    }

    final result = _networkClient.get(
      '/tv/$seriesId/account_states',
      parser,
      <String, dynamic>{
        'api_key': Configuration.apiKey,
        'session_id': sessionId,
      },
    );
    return result;
  }
}
