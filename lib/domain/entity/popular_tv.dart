import 'package:json_annotation/json_annotation.dart';
import 'package:kino/domain/entity/tv.dart';

part 'popular_tv.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class PopularTVResponse {
  final int page;
  @JsonKey(name: 'results') 
  final List<TV> tv;
  final int totalPages;
  final int totalResults;

  PopularTVResponse({
    required this.page,
    required this.tv,
    required this.totalPages,
    required this.totalResults,
  });
  
   factory PopularTVResponse.fromJson(Map<String, dynamic> json) =>
      _$PopularTVResponseFromJson(json);

  Map<String, dynamic> toJson() => _$PopularTVResponseToJson(this);

  }
