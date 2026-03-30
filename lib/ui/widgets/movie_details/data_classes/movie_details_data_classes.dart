import 'package:flutter/material.dart';
import 'package:kino/ui/theme/app_colors.dart';

class DetailsPosterData {
  final String? backdropPath;
  final String? posterPath;
  final bool isFavorite;
  IconData get favoriteIcon =>
      isFavorite ? Icons.favorite : Icons.favorite_outline;
  Color get favColor => isFavorite ? AppColors.orange : AppColors.greyText;
  final bool isWatchList;
  IconData get watchListIcon =>
      isWatchList ? Icons.bookmark_added : Icons.bookmark_add_outlined;
  Color get watchListColor =>
      isWatchList ? AppColors.orange : AppColors.greyText;
  final double? rating;
  String get ratingStatus => rating != -1 ? 'Оценено' : 'Оценить';

  DetailsPosterData({
    this.backdropPath,
    this.posterPath,
    this.isFavorite = false,
    this.isWatchList = false,
    this.rating = 0.0,
  });

  DetailsPosterData copyWith({
    String? backdropPath,
    String? posterPath,
    bool? isFavorite,
    bool? isWatchList,
    double? rating,
  }) {
    return DetailsPosterData(
      backdropPath: backdropPath ?? this.backdropPath,
      posterPath: posterPath ?? this.posterPath,
      isFavorite: isFavorite ?? this.isFavorite,
      isWatchList: isWatchList ?? this.isWatchList,
      rating: rating ?? this.rating,
    );
  }
}

class DetailsNameData {
  final String name;
  final String year;

  DetailsNameData({required this.name, required this.year});
}

class DetailScoreData {
  final double voteAverage;
  final String? trailerKey;
  final String? voteCount;

  DetailScoreData({required this.voteAverage, this.trailerKey, this.voteCount});
}

class DetailsPeopleData {
  final String? profilePath;
  final String name;
  final String job;

  DetailsPeopleData({required this.name, required this.job, this.profilePath});
}

class DetailsActorData {
  final String name;
  final String character;
  final String? profilePath;

  DetailsActorData({
    required this.name,
    required this.character,
    this.profilePath,
  });
}

class DetailsPhotoData {
  final String filePath;

  DetailsPhotoData({required this.filePath});
}
