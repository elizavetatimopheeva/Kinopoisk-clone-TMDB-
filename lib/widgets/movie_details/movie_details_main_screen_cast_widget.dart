import 'package:flutter/material.dart';
import 'package:kino/domain/api_client/image_downloader.dart';
import 'package:kino/widgets/movie_details/movie_details_model.dart';
import 'package:provider/provider.dart';

class MovieDetailsMainScreenCastWidget extends StatelessWidget {
  const MovieDetailsMainScreenCastWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              'В главных ролях',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
          ),
          const SizedBox(
            height: 300,
            child: Scrollbar(child: _ActorListWidget()),
          ),
          Padding(
            padding: const EdgeInsets.all(3.0),
            child: TextButton(
              onPressed: () {},
              child: const Text('Полный актёрский и съёмочный состав'),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActorListWidget extends StatelessWidget {
  const _ActorListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    var movieActorData = context.select(
      (MovieDetailsModel model) => model.data.movieActorData,
    );
    if (movieActorData.isEmpty) return const SizedBox.shrink();
    return ListView.builder(
      itemCount: movieActorData.length,
      itemExtent: 120,
      scrollDirection: Axis.horizontal,
      itemBuilder: (BuildContext context, int index) {
        return _ActorListItemWidget(actorIndex: index);
      },
    );
  }
}

class _ActorListItemWidget extends StatelessWidget {
  final int actorIndex;
  const _ActorListItemWidget({super.key, required this.actorIndex});

  @override
  Widget build(BuildContext context) {
    final model = context.read<MovieDetailsModel>();
    final actor = model.data.movieActorData[actorIndex];
    final profilePath = actor.profilePath;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.black.withValues(alpha: 0.12)),
          borderRadius: BorderRadius.all(Radius.circular(10)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          clipBehavior: Clip.hardEdge,
          child: Column(
            children: [
              profilePath != null
                  ? Image.network(ImageDownloader.imageUrl(profilePath))
                  : const SizedBox.shrink(),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(actor.name, maxLines: 2),
                    SizedBox(height: 8),
                    Text(actor.character, maxLines: 2),
                    SizedBox(height: 5),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
