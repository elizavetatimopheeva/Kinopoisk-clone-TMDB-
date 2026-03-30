import 'package:json_annotation/json_annotation.dart';
part 'movie_rating.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class MovieRating {
  final int? value;
  

  MovieRating({
    required this.value,
  });

  factory MovieRating.fromJson(Map<String, dynamic> json) => _$MovieRatingFromJson(json);

  Map<String, dynamic> toJson() => _$MovieRatingToJson(this);
}
