import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kino/domain/api_client/image_downloader.dart';
import 'package:kino/domain/blocs/movie_details_event.dart';
import 'package:kino/ui/theme/app_colors.dart';
import 'package:kino/ui/widgets/elements/ratial_score_widget.dart';
import 'package:kino/ui/widgets/movie_details/movie_details_cubit.dart';

class MovieDetailsInfoWidget extends StatelessWidget {
  const MovieDetailsInfoWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        _TopPosterWidget(),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15),
          child: _MovieNameWidget(),
        ),
        _MovieDescriptionWidget(),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 55.0, vertical: 20),
          child: ActionsWidget(),
        ),
        Padding(padding: EdgeInsets.all(20.0), child: _DescriptionWidget()),
        SizedBox(height: 20),
        _RatingWidget(),
        SizedBox(height: 20),
      ],
    );
  }
}

class _DescriptionWidget extends StatelessWidget {
  const _DescriptionWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = context.read<BaseDetailsBloc>().state;
    String overview = '';
    if (state is MovieDetailsLoadedState) {
      overview = state.data.overview;
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          overview,
          maxLines: 3,
          overflow: TextOverflow.fade,
          style: const TextStyle(
            color: AppColors.white,
            fontSize: 13,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          'Все детали',
          style: TextStyle(
            color: AppColors.orange,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _RatingWidget extends StatelessWidget {
  const _RatingWidget();

  @override
  Widget build(BuildContext context) {
    final state = context.watch<BaseDetailsBloc>().state;
    if (state is! MovieDetailsLoadedState) return const SizedBox.shrink();

    final scoreData = state.data.scoreData;
    final score = scoreData.voteAverage / 10;

    final Color color = getScoreColor(score);
    final Color backgroundColor = getScoreBgColor(score);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Рейтинг',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            color: AppColors.darkGreybackground,
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              children: [
                SizedBox(
                  width: 80,
                  height: 80,
                  child: RadialPercentWidget(
                    percent: scoreData.voteAverage / 100,
                    fillColor: AppColors.darkGreybackground,
                    lineColor: color,
                    freeColor: backgroundColor,
                    lineWidth: 7,
                    child: Text(
                      score.toStringAsFixed(1),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  '${scoreData.voteCount} оценок',
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.greyText,
                  ),
                ),
                const SizedBox(height: 15),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 15,
                    ),
                    backgroundColor: AppColors.orange,
                    foregroundColor: AppColors.white,
                    textStyle: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text('Оценить'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TopPosterWidget extends StatelessWidget {
  const _TopPosterWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = context.read<BaseDetailsBloc>().state;
    String? posterPath;
    if (state is MovieDetailsLoadedState) {
      posterPath = state.data.posterData.posterPath;
    }
    return Padding(
      padding: const EdgeInsets.only(top: 30),
      child: AspectRatio(
        aspectRatio: 350 / 219,
        child: (posterPath != null)
            ? Image.network(ImageDownloader.imageUrl(posterPath))
            : const SizedBox.shrink(),
      ),
    );
  }
}

class _MovieNameWidget extends StatelessWidget {
  const _MovieNameWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = context.watch<BaseDetailsBloc>().state;
    String name = '';
    if (state is MovieDetailsLoadedState) {
      name = state.data.nameData.name;
    }
    return Center(
      child: Text(
        name,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    );
  }
}

class _MovieDescriptionWidget extends StatelessWidget {
  const _MovieDescriptionWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = context.watch<BaseDetailsBloc>().state;
    if (state is! MovieDetailsLoadedState) return const SizedBox.shrink();

    final data = state.data;
    final score = data.scoreData.voteAverage / 10;
    final Color color = getScoreColor(score);
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            RichText(
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              text: TextSpan(
                style: TextStyle(fontFamily: 'Satoshi'),
                children: <TextSpan>[
                  TextSpan(
                    text: score.toStringAsFixed(1),
                    style: TextStyle(
                      color: color,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: ' ${data.nameData.year}, ${data.genres}',
                    style: TextStyle(color: AppColors.greyText, fontSize: 14),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 2),
            Text(
              data.summary,
              style: const TextStyle(color: AppColors.greyText, fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class ActionsWidget extends StatelessWidget {
  const ActionsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<BaseDetailsBloc>();
    final state = context.watch<BaseDetailsBloc>().state;

    if (state is! MovieDetailsLoadedState) return const SizedBox.shrink();

    final posterData = state.data.posterData;
    final rating = posterData.rating;
    final ratingStatus = posterData.ratingStatus;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          children: [
            (rating! < 0)
                ? const Icon(
                    Icons.star_border_outlined,
                    size: 28,
                    color: AppColors.greyText,
                  )
                : Text(
                    "$rating",
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: AppColors.orange,
                    ),
                  ),
            Text(
              ratingStatus,
              style: const TextStyle(fontSize: 10, color: AppColors.greyText),
            ),
          ],
        ),
        GestureDetector(
          onTap: () =>
              bloc.add(MovieDetailsToggleWatchListEvent(context: context)),
          child: Column(
            children: [
              Icon(
                posterData.watchListIcon,
                size: 28,
                color: posterData.watchListColor,
              ),
              const Text(
                'Буду смотреть',
                style: TextStyle(fontSize: 10, color: AppColors.greyText),
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: () =>
              bloc.add(MovieDetailsToggleFavoriteEvent(context: context)),
          child: Column(
            children: [
              Icon(
                posterData.favoriteIcon,
                size: 28,
                color: posterData.favColor,
              ),
              const Text(
                'В избранное',
                style: TextStyle(fontSize: 10, color: AppColors.greyText),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

Color getScoreColor(double score) {
  if (score >= 7) return Colors.green;
  if (score >= 5) return Colors.amber;
  return Colors.red;
}

Color getScoreBgColor(double score) {
  if (score >= 7) return const Color.fromARGB(255, 25, 54, 31);
  if (score >= 5) return const Color.fromARGB(255, 54, 49, 25);
  return const Color.fromARGB(255, 54, 25, 25);
}
