import 'package:flutter/material.dart';
import 'package:kino/domain/api_client/image_downloader.dart';
import 'package:kino/widgets/elements/ratial_score_widget.dart';
import 'package:kino/widgets/movie_details/movie_details_model.dart';
import 'package:kino/widgets/navigation/main_navigation.dart';
import 'package:provider/provider.dart';

class MovieDetailsMainInfoWidget extends StatelessWidget {
  const MovieDetailsMainInfoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _TopPosterWidget(),
        Padding(padding: const EdgeInsets.all(15.0), child: _MovieNameWidget()),
        _ScoreWidget(),
        _SummaryWidget(),
        Padding(padding: const EdgeInsets.all(10.0), child: _OverviewWidget()),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: _DescriptionWidget(),
        ),
        SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: _PeopleWidget(),
        ),
      ],
    );
  }
}

class _DescriptionWidget extends StatelessWidget {
  const _DescriptionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final overview = context.select(
      (MovieDetailsModel model) => model.data.overview,
    );
    return Text(overview, style: TextStyle(color: Colors.white, fontSize: 16));
  }
}

class _OverviewWidget extends StatelessWidget {
  const _OverviewWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Text('Обзор', style: TextStyle(color: Colors.white, fontSize: 16));
  }
}

class _TopPosterWidget extends StatelessWidget {
  const _TopPosterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final model = context.read<MovieDetailsModel>();
    final posterData = context.select(
      (MovieDetailsModel model) => model.data.posterData,
    );

    final backdropPath = posterData.backdropPath;
    final posterPath = posterData.posterPath;

    return AspectRatio(
      aspectRatio: 390 / 219,
      child: Stack(
        children: [
          if (backdropPath != null)
            Image.network(ImageDownloader.imageUrl(backdropPath)),
          if (posterPath != null)
            Positioned(
              top: 20,
              left: 20,
              bottom: 20,
              child: Image.network(ImageDownloader.imageUrl(posterPath)),
            ),
          Positioned(
            top: 5,
            right: 10,
            child: IconButton(
              onPressed: () => model.toggleFavorite(context),
              icon: Icon(posterData.favoriteIcon),
            ),
          ),
        ],
      ),
    );
  }
}

class _MovieNameWidget extends StatelessWidget {
  const _MovieNameWidget({super.key});

  @override
  Widget build(BuildContext context) {
    var movieNameData = context.select(
      (MovieDetailsModel model) => model.data.movieNameData,
    );

    return Center(
      child: RichText(
        maxLines: 3,
        textAlign: TextAlign.center,
        text: TextSpan(
          children: <TextSpan>[
            TextSpan(
              text: movieNameData.title,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 25),
            ),
            TextSpan(
              text: movieNameData.year,
              style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}

class _ScoreWidget extends StatelessWidget {
  const _ScoreWidget({super.key});

  @override
  Widget build(BuildContext context) {
    var movieScoreData = context.select(
      (MovieDetailsModel model) => model.data.movieScoreData,
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        TextButton(
          onPressed: () {},
          child: Row(
            children: [
              SizedBox(
                width: 40,
                height: 40,
                child: RadialPercentWidget(
                  percent: movieScoreData.voteAverage / 100.0,
                  fillColor: const Color.fromARGB(255, 10, 23, 25),
                  lineColor: const Color.fromARGB(255, 37, 203, 103),
                  freeColor: const Color.fromARGB(255, 25, 54, 31),
                  lineWidth: 3,
                  child: Text(
                    movieScoreData.voteAverage.toStringAsFixed(0),
                    style: TextStyle(color: Colors.white, fontSize: 11),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              const Text('Рейтинг'),
            ],
          ),
        ),
        Container(width: 1, height: 15, color: Colors.grey),
        movieScoreData.trailerKey != null
            ? TextButton(
                onPressed: () => Navigator.of(context).pushNamed(
                  MainNavigationRouteNames.movieTrailerWidget,
                  arguments: movieScoreData.trailerKey,
                ),
                child: Row(
                  children: [
                    Icon(Icons.play_arrow, color: Colors.white),
                    Text('Трейлер'),
                  ],
                ),
              )
            : Row(
                children: [
                  Icon(Icons.play_disabled, color: Colors.white),
                  Text(
                    'Трейлер отсутсвует',
                    style: TextStyle(color: Colors.deepPurple),
                  ),
                ],
              ),
      ],
    );
  }
}

class _SummaryWidget extends StatelessWidget {
  const _SummaryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final summary = context.select(
      (MovieDetailsModel model) => model.data.summary,
    );
    return ColoredBox(
      color: Color.fromRGBO(24, 23, 27, 1.0),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        child: Text(
          summary,
          maxLines: 3,
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white, fontSize: 14),
        ),
      ),
    );
  }
}

class _PeopleWidget extends StatelessWidget {
  const _PeopleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    var peopleData = context.select(
      (MovieDetailsModel model) => model.data.peopleData,
    );
    if (peopleData.isEmpty) return const SizedBox.shrink();

    return Column(
      children: peopleData
          .map(
            (chunk) => Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: _PeopleWidgetRow(employees: chunk),
            ),
          )
          .toList(),
    );
  }
}

class _PeopleWidgetRow extends StatelessWidget {
  final List<MovieDetailsMoviePeopleData> employees;
  const _PeopleWidgetRow({super.key, required this.employees});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      // mainAxisAlignment: MainAxisAlignment.sp,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: employees
          .map((employee) => _PeopleWidgetRowItem(employee: employee))
          .toList(),
    );
  }
}

class _PeopleWidgetRowItem extends StatelessWidget {
  final MovieDetailsMoviePeopleData employee;
  const _PeopleWidgetRowItem({super.key, required this.employee});

  @override
  Widget build(BuildContext context) {
    const nameStyle = TextStyle(color: Colors.white, fontSize: 16);

    const jobTitleStyle = TextStyle(color: Colors.white, fontSize: 16);
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(employee.name, style: nameStyle),
          Text(employee.job, style: jobTitleStyle),
        ],
      ),
    );
  }
}
