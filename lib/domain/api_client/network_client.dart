import 'dart:convert';
import 'dart:io';
import 'package:kino/configuration/configuration.dart';
import 'package:kino/domain/api_client/api_client_exception.dart';

class NetworkClient {
  final _client = HttpClient();


  Uri _makeUri(
    String path, [
    Map<String, dynamic>? parameters,
  ]) //параметров может и не быть у запроса, поэтому они в квадратных скобках и ? потому что опциональные
  {
    final uri = Uri.parse('${Configuration.host}$path');
    if (parameters != null) {
      return uri.replace(queryParameters: parameters);
    } else {
      return uri;
    }
  }

  Future<T> get<T>(
    String path,
    T Function(dynamic json) parser, [
    Map<String, dynamic>? parameters,
  ]) async {
    final url = _makeUri(path, parameters);

    try {
      final request = await _client.getUrl(
        url,
      ); //здесь отвалимся если нет интернета
      final response = await request
          .close(); // здесь если сервер недоступен потому что не получим данные
      final dynamic json = (await response
          .jsonDecode()); // здесь если неправильный парсинг
      _validateResponse(response, json);
      final result = parser(json);
      return result;
    } on SocketException {
      throw ApiCLientException(ApiCLientExceptionType.network);
    } on ApiCLientException {
      rethrow;
    } catch (_) {
      throw ApiCLientException(ApiCLientExceptionType.other);
    }
  }

  Future<T> post<T>(
    String path,
    Map<String, dynamic> bodyParameters,
    T Function(dynamic json) parser, [
    Map<String, dynamic>? urlParameters,
  ]) async {
    try {
      final url = _makeUri(path, urlParameters);

      final request = await _client.postUrl(url);
      request.headers.contentType = ContentType
          .json; // вместо request.headers.set('Content-type', 'application/json; charset=UTF-8');

      request.write(jsonEncode(bodyParameters));
      final response = await request.close();
      // if (response.statusCode==201){

      // }
      final dynamic json = (await response.jsonDecode());
      _validateResponse(response, json);
      final result = parser(json);
      return result;
    } on SocketException {
      throw ApiCLientException(ApiCLientExceptionType.network);
    } on ApiCLientException {
      rethrow;
    } catch (e) {
      throw ApiCLientException(ApiCLientExceptionType.other);
    }
  }

  void _validateResponse(HttpClientResponse response, dynamic json) {
    if (response.statusCode == 401) {
      final dynamic status = json['status_code'];
      final code = status is int ? status : 0;
      if (code == 30) {
        throw ApiCLientException(ApiCLientExceptionType.auth);
      } else if (code == 3) {
        throw ApiCLientException(ApiCLientExceptionType.sessionExpired);
      } else {
        throw ApiCLientException(ApiCLientExceptionType.other);
      }
    }
  }
}

extension HttpClientResponseJsonDecode on HttpClientResponse {
  Future<dynamic> jsonDecode() async {
    return transform(utf8.decoder)
        .toList()
        .then((value) => value.join())
        .then<dynamic>((v) => json.decode(v));
  }
}
