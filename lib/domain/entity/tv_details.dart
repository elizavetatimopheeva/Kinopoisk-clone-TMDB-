import 'package:json_annotation/json_annotation.dart';
import 'package:kino/domain/entity/movie_date_parser.dart';
import 'package:kino/domain/entity/movie_details_cast.dart';
import 'package:kino/domain/entity/movie_details_photo.dart';

part 'tv_details.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class TvShowDetails {
  final bool? adult;
  final String? backdropPath;
  final List<CreatedBy> createdBy;
  final List<int>? episodeRunTime;
  @JsonKey(fromJson: parseMovieDateFromString)
  final DateTime? firstAirDate;
  final List<Genre> genres;
  final String? homepage;
  final int? id;
  final bool? inProduction;
  final List<String>? languages;
  @JsonKey(fromJson: parseMovieDateFromString)
  final DateTime? lastAirDate;
  final Episode? lastEpisodeToAir;
  final String name;
  final Episode? nextEpisodeToAir;
  final List<Network>? networks;
  final int? numberOfEpisodes;
  final int? numberOfSeasons;
  final List<String> originCountry;
  final String? originalLanguage;
  final String? originalName;
  final String overview;
  final double? popularity;
  final String? posterPath;
  final List<ProductionCompany>? productionCompanies;
  final List<ProductionCountry>? productionCountries;
  final List<Season>? seasons;
  final List<SpokenLanguage>? spokenLanguages;
  final String? status;
  final String? tagline;
  final String? type;
  final double voteAverage;
  final int? voteCount;
  final DetailsCredits credits;
  final DetailsPhotos images;

  TvShowDetails({
    required this.adult,
    required this.backdropPath,
    required this.createdBy,
    required this.episodeRunTime,
    required this.firstAirDate,
    required this.genres,
    required this.homepage,
    required this.id,
    required this.inProduction,
    required this.languages,
    required this.lastAirDate,
    required this.lastEpisodeToAir,
    required this.name,
    required this.nextEpisodeToAir,
    required this.networks,
    required this.numberOfEpisodes,
    required this.numberOfSeasons,
    required this.originCountry,
    required this.originalLanguage,
    required this.originalName,
    required this.overview,
    required this.popularity,
    required this.posterPath,
    required this.productionCompanies,
    required this.productionCountries,
    required this.seasons,
    required this.spokenLanguages,
    required this.status,
    required this.tagline,
    required this.type,
    required this.voteAverage,
    required this.voteCount,
    required this.credits,
    required this.images,
  });

  factory TvShowDetails.fromJson(Map<String, dynamic> json) =>
      _$TvShowDetailsFromJson(json);
  Map<String, dynamic> toJson() => _$TvShowDetailsToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class CreatedBy {
  final int? id;
  final String? creditId;
  final String? name;
  final int? gender;
  final String? profilePath;

  CreatedBy({this.id, this.creditId, this.name, this.gender, this.profilePath});

  factory CreatedBy.fromJson(Map<String, dynamic> json) =>
      _$CreatedByFromJson(json);
  Map<String, dynamic> toJson() => _$CreatedByToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class Genre {
  final int? id;
  final String? name;

  Genre({this.id, this.name});

  factory Genre.fromJson(Map<String, dynamic> json) => _$GenreFromJson(json);
  Map<String, dynamic> toJson() => _$GenreToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class Episode {
  final int? id;
  final String? name;
  final String? overview;
  final double? voteAverage;
  final int? voteCount;
  final String? airDate;
  final int? episodeNumber;
  final String? productionCode;
  final int? runtime;
  final int? seasonNumber;
  final int? showId;
  final String? stillPath;

  Episode({
    this.id,
    this.name,
    this.overview,
    this.voteAverage,
    this.voteCount,
    this.airDate,
    this.episodeNumber,
    this.productionCode,
    this.runtime,
    this.seasonNumber,
    this.showId,
    this.stillPath,
  });

  factory Episode.fromJson(Map<String, dynamic> json) =>
      _$EpisodeFromJson(json);
  Map<String, dynamic> toJson() => _$EpisodeToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class Network {
  final int? id;
  final String? logoPath;
  final String? name;
  final String? originCountry;

  Network({this.id, this.logoPath, this.name, this.originCountry});

  factory Network.fromJson(Map<String, dynamic> json) =>
      _$NetworkFromJson(json);
  Map<String, dynamic> toJson() => _$NetworkToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class ProductionCompany {
  final int? id;
  final String? logoPath;
  final String? name;
  final String? originCountry;

  ProductionCompany({this.id, this.logoPath, this.name, this.originCountry});

  factory ProductionCompany.fromJson(Map<String, dynamic> json) =>
      _$ProductionCompanyFromJson(json);
  Map<String, dynamic> toJson() => _$ProductionCompanyToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class ProductionCountry {
  @JsonKey(name: 'iso_3166_1')
  final String? iso31661;
  final String? name;

  ProductionCountry({this.iso31661, this.name});

  factory ProductionCountry.fromJson(Map<String, dynamic> json) =>
      _$ProductionCountryFromJson(json);
  Map<String, dynamic> toJson() => _$ProductionCountryToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class Season {
  final String? airDate;
  final int? episodeCount;
  final int? id;
  final String? name;
  final String? overview;
  final String? posterPath;
  final int? seasonNumber;
  final double? voteAverage;

  Season({
    this.airDate,
    this.episodeCount,
    this.id,
    this.name,
    this.overview,
    this.posterPath,
    this.seasonNumber,
    this.voteAverage,
  });

  factory Season.fromJson(Map<String, dynamic> json) => _$SeasonFromJson(json);
  Map<String, dynamic> toJson() => _$SeasonToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class SpokenLanguage {
  final String? englishName;
  @JsonKey(name: 'iso_639_1') // Исключение для стандарта ISO
  final String? iso6391;
  final String? name;

  SpokenLanguage({this.englishName, this.iso6391, this.name});

  factory SpokenLanguage.fromJson(Map<String, dynamic> json) =>
      _$SpokenLanguageFromJson(json);
  Map<String, dynamic> toJson() => _$SpokenLanguageToJson(this);
}
