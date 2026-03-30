import 'package:kino/domain/entity/movie_details.dart';
import 'package:kino/domain/entity/tv_details.dart';

class MovieDetailsLocal {
  final MovieDetails details;
  final bool isFavorite;
  final bool isWatchList;
  final double rating;

  MovieDetailsLocal({
    required this.details,
    required this.isFavorite,
    required this.isWatchList,
    required this.rating,
  });
}



class TVDetailsLocal {
  final TvShowDetails details;
  final bool isFavorite;
  final bool isWatchList;
  final double rating;

  TVDetailsLocal({
    required this.details,
    required this.isFavorite,
    required this.isWatchList,
    required this.rating,
  });
}
