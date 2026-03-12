import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kino/domain/api_client/image_downloader.dart';
import 'package:kino/ui/navigation/main_navigation.dart';
import 'package:kino/ui/widgets/elements/ratial_score_widget.dart';
import 'package:kino/ui/widgets/news/news_cubit.dart';
import 'package:kino/ui/widgets/news/tv_cubit.dart';

class NewsWidgetPopular extends StatefulWidget {
  const NewsWidgetPopular({super.key});

  @override
  State<NewsWidgetPopular> createState() => _NewsWidgetPopularState();
}

class _NewsWidgetPopularState extends State<NewsWidgetPopular> {
  String? _category = 'movies';

  @override
  Widget build(BuildContext context) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'What`s Popular',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
              ),
              DropdownButton<String>(
                value: _category,
                onChanged: (String? newValue) {
                  setState(() {
                    _category = newValue;
                  });
                },
                items: [
                  const DropdownMenuItem(
                    value: 'movies',
                    child: Text('Movies'),
                  ),
                  const DropdownMenuItem(value: 'tv', child: Text('TV')),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(height: 300, child: _getSelectedWidget()),
      ],
    );
  }

  Widget _getSelectedWidget() {
    switch (_category) {
      case 'movies':
        return _PopularMoviesWidget();
      case 'tv':
        return _PopularTvWidget();
      default:
        return _PopularMoviesWidget();
    }
  }
}

class _PopularMoviesWidget extends StatelessWidget {
  const _PopularMoviesWidget();

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<NewsCubit>();
    return Column(
      children: [
        SizedBox(
          height: 300,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: cubit.state.movies.length,
            itemExtent: 160,
            itemBuilder: (BuildContext context, int index) {
              cubit.showedMovieAtIndex(index);
              return _MovieListItem(index: index);
            },
          ),
        ),
      ],
    );
  }
}

class _PopularTvWidget extends StatelessWidget {
  const _PopularTvWidget();

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<TVCubit>();
    return Column(
      children: [
        SizedBox(
          height: 300,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: cubit.state.tv.length,
            itemExtent: 180,
            itemBuilder: (BuildContext context, int index) {
              cubit.showedMovieAtIndex(index);
              return _TVListItem(index: index);
            },
          ),
        ),
      ],
    );
  }
}

class _MovieListItem extends StatelessWidget {
  final int index;
  const _MovieListItem({required this.index});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<NewsCubit>();
    final movie = cubit.state.movies[index];
    final posterPath = movie.posterPath;
    final voteAverage = (movie.voteAverage) * 10;
    return GestureDetector(
      onTap: () => _onMovieTap(context, movie.id),
      child: Padding(
        padding: const EdgeInsets.only(
          top: 10.0,
          right: 5,
          left: 20,
          bottom: 5,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: posterPath != null
                        ? Image.network(
                            ImageDownloader.imageUrl(posterPath),
                            width: 125,
                          )
                        : SizedBox.shrink(),
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(Icons.more_horiz),
                  ),
                ),
                Positioned(
                  left: 5,
                  bottom: 0,
                  child: SizedBox(
                    width: 40,
                    height: 40,
                    child: RadialPercentWidget(
                      percent: voteAverage / 100,
                      fillColor: const Color.fromARGB(255, 10, 23, 25),
                      lineColor: const Color.fromARGB(255, 37, 203, 103),
                      freeColor: const Color.fromARGB(255, 25, 54, 31),
                      lineWidth: 3,
                      child: Text(
                        '${voteAverage.toStringAsFixed(0)}%',
                        style: TextStyle(color: Colors.white, fontSize: 10),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(left: 0, top: 10, right: 10),
              child: Text(
                movie.title,
                maxLines: 1,
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 0, top: 10, right: 10),
              child: Text(movie.releaseDate, style: TextStyle(fontSize: 12)),
            ),
          ],
        ),
      ),
    );
  }

  void _onMovieTap(BuildContext context, int movieId) {
    Navigator.of(
      context,
    ).pushNamed(MainNavigationRouteNames.movieDetails, arguments: movieId);
  }
}

class _TVListItem extends StatelessWidget {
  final int index;
  const _TVListItem({required this.index});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<TVCubit>();
    final tv = cubit.state.tv[index];
    final posterPath = tv.posterPath;
    final voteAverage = (tv.voteAverage) * 10;
    return GestureDetector(
      // onTap: () => _onMovieTap(context, tv.id),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: posterPath != null
                        ? Image.network(
                            ImageDownloader.imageUrl(posterPath),
                            width: 125,
                          )
                        : SizedBox.shrink(),
                  ),
                ),
                Positioned(
                  top: 15,
                  right: 15,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(Icons.more_horiz),
                  ),
                ),
                Positioned(
                  left: 10,
                  bottom: 0,
                  child: SizedBox(
                    width: 40,
                    height: 40,
                    child: RadialPercentWidget(
                      percent: voteAverage / 100,
                      fillColor: const Color.fromARGB(255, 10, 23, 25),
                      lineColor: const Color.fromARGB(255, 37, 203, 103),
                      freeColor: const Color.fromARGB(255, 25, 54, 31),
                      lineWidth: 3,
                      child: Text(
                        '${voteAverage.toStringAsFixed(0)}%',
                        style: TextStyle(color: Colors.white, fontSize: 10),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(left: 10, top: 10, right: 10),
              child: Text(
                tv.title,
                maxLines: 1,

                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 10, top: 10, right: 10),
              child: Text(tv.firsrAirDate, style: TextStyle(fontSize: 12)),
            ),
          ],
        ),
      ),
    );
  }

  // void _onMovieTap(BuildContext context, int movieId) {
  //   Navigator.of(
  //     context,
  //   ).pushNamed(MainNavigationRouteNames.movieDetails, arguments: movieId);
  // }
}
