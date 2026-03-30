import 'package:json_annotation/json_annotation.dart';

part 'movie_details_photo.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class DetailsPhotos {
  final List<Backdrops> backdrops;
  final List<Logos> logos;
  final List<Posters> posters;
  DetailsPhotos({
    required this.backdrops,
    required this.logos,
    required this.posters,
  });

  factory DetailsPhotos.fromJson(Map<String, dynamic> json) =>
      _$DetailsPhotosFromJson(json);

  Map<String, dynamic> toJson() => _$DetailsPhotosToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class Backdrops {
  final double aspectRatio;
  final int height;
  @JsonKey(name: 'iso_639_1')
  final String? iso;
  final String filePath;
  final double voteAverage;
  final int voteCount;
  final int width;

  Backdrops({
    required this.height,
    required this.filePath,
    required this.width,
    required this.aspectRatio,
    required this.iso,
    required this.voteAverage,
    required this.voteCount,
  });
  factory Backdrops.fromJson(Map<String, dynamic> json) =>
      _$BackdropsFromJson(json);

  Map<String, dynamic> toJson() => _$BackdropsToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class Logos {
  final double aspectRatio;
  final int height;
  @JsonKey(name: 'iso_639_1')
  final String? iso;
  final String filePath;
  final double voteAverage;
  final int voteCount;
  final int width;

  Logos({
    required this.height,
    required this.filePath,
    required this.width,
    required this.aspectRatio,
    required this.iso,
    required this.voteAverage,
    required this.voteCount,
  });
  factory Logos.fromJson(Map<String, dynamic> json) => _$LogosFromJson(json);

  Map<String, dynamic> toJson() => _$LogosToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class Posters {
  final double aspectRatio;
  final int height;
  @JsonKey(name: 'iso_639_1')
  final String? iso;
  final String filePath;
  final double voteAverage;
  final int voteCount;
  final int width;

  Posters({
    required this.height,
    required this.filePath,
    required this.width,
    required this.aspectRatio,
    required this.iso,
    required this.voteAverage,
    required this.voteCount,
  });
  factory Posters.fromJson(Map<String, dynamic> json) =>
      _$PostersFromJson(json);

  Map<String, dynamic> toJson() => _$PostersToJson(this);
}
