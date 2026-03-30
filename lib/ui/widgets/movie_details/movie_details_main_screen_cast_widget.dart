import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kino/domain/api_client/image_downloader.dart';
import 'package:kino/domain/blocs/movie_details_event.dart';
import 'package:kino/ui/theme/app_colors.dart';
import 'package:kino/ui/widgets/movie_details/movie_details_cubit.dart';

class MovieDetailsMainScreenCastWidget extends StatelessWidget {
  const MovieDetailsMainScreenCastWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [_ActorsWidget(), _CrewWidget()],
    );
  }
}

class _CrewWidget extends StatelessWidget {
  const _CrewWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.read<BaseDetailsBloc>().state;
    if (state is! MovieDetailsLoadedState) {
      return const SizedBox.shrink();
    }
    var data = state.data.peopleData;
    if (data.isEmpty) {
      return const SizedBox.shrink();
    }
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Съёмочная группа',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            Text(
              'Все',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppColors.orange,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        const SizedBox(height: 80, child: Scrollbar(child: _CrewListWidget())),
      ],
    );
  }
}

class _ActorsWidget extends StatelessWidget {
  const _ActorsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.read<BaseDetailsBloc>().state;
    if (state is! MovieDetailsLoadedState) {
      return const SizedBox.shrink();
    }
    var data = state.data.actorsData;
    if (data.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Актёры',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            Text(
              'Все',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppColors.orange,
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 250,
          child: Scrollbar(child: _ActorListWidget()),
        ),
        const SizedBox(height: 30),
      ],
    );
  }
}

class _ActorListWidget extends StatelessWidget {
  const _ActorListWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = context.read<BaseDetailsBloc>().state;
    if (state is! MovieDetailsLoadedState) {
      return const SizedBox.shrink();
    }

    var data = state.data.actorsData;
    if (data.isEmpty) return const SizedBox.shrink();

    final int actorsCount = data.length > 12 ? 12 : data.length;
    final int groupsCount = (actorsCount / 3).ceil();
    final int totalItems = groupsCount + 1;

    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: totalItems,
      itemBuilder: (BuildContext context, int index) {
        if (index == groupsCount) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 100,
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: AppColors.orange,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    onPressed: () {
                      print('Показать ещё');
                    },
                    icon: const Icon(Icons.arrow_forward, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Показать ещё',
                style: TextStyle(color: AppColors.greyText, fontSize: 12),
              ),
            ],
          );
        }

        return SizedBox(
          width: 220,
          child: Column(
            children: List.generate(3, (positionInGroup) {
              int itemIndex = index * 3 + positionInGroup;
              if (itemIndex < actorsCount) {
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: _ActorListItemWidget(actorIndex: itemIndex),
                  ),
                );
              } else {
                return const Expanded(child: SizedBox.shrink());
              }
            }),
          ),
        );
      },
    );
  }
}

class _ActorListItemWidget extends StatelessWidget {
  final int actorIndex;
  const _ActorListItemWidget({Key? key, required this.actorIndex})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = context.read<BaseDetailsBloc>().state;
    if (state is! MovieDetailsLoadedState) {
      return const SizedBox.shrink();
    }

    final actor = state.data.actorsData[actorIndex];
    final profilePath = actor.profilePath;

    return Row(
      children: [
        if (profilePath != null)
          ClipRRect(
            child: Image.network(
              ImageDownloader.imageUrl(profilePath),
              width: 40,
              height: 60,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                width: 40,
                height: 60,
                color: const Color(0xFF141414),
                child: const Icon(
                  Icons.person,
                  color: AppColors.greyText,
                  size: 20,
                ),
              ),
            ),
          )
        else
          Container(
            width: 40,
            height: 60,
            color: const Color(0xFF141414),
            child: const Icon(
              Icons.person,
              color: AppColors.greyText,
              size: 20,
            ),
          ),

        const SizedBox(width: 10),

        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  actor.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  actor.character,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.greyText,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _CrewListWidget extends StatelessWidget {
  const _CrewListWidget();

  @override
  Widget build(BuildContext context) {
    final state = context.read<BaseDetailsBloc>().state;
    if (state is! MovieDetailsLoadedState) {
      return const SizedBox.shrink();
    }

    var data = state.data.peopleData;
    if (data.isEmpty) return const SizedBox.shrink();

    final int crewCount = data.length > 12 ? 12 : data.length;
    final int totalItems = crewCount + 1;

    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: totalItems,
      itemBuilder: (BuildContext context, int index) {
        if (index == crewCount) {
          return SizedBox(
            width: 100,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: AppColors.orange,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    onPressed: () {
                      print('Показать ещё');
                    },
                    icon: const Icon(Icons.arrow_forward, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Показать ещё',
                  style: TextStyle(color: AppColors.greyText, fontSize: 12),
                ),
              ],
            ),
          );
        }

        return SizedBox(
          width: 230,
          child: Padding(
            padding: const EdgeInsets.only(right: 20),
            child: _CrewListItemWidget(crewIndex: index),
          ),
        );
      },
    );
  }
}

class _CrewListItemWidget extends StatelessWidget {
  final int crewIndex;
  const _CrewListItemWidget({super.key, required this.crewIndex});

  @override
  Widget build(BuildContext context) {
    final state = context.read<BaseDetailsBloc>().state;
    if (state is! MovieDetailsLoadedState) {
      return const SizedBox.shrink();
    }

    final crew = state.data.peopleData[crewIndex];
    final profilePath = crew.profilePath;

    return ColoredBox(
      color: AppColors.darkGreybackground,
      child: Row(
        children: [
          if (profilePath != null)
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: ClipRRect(
                child: Image.network(
                  ImageDownloader.imageUrl(profilePath),
                  width: 40,
                  height: 60,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 40,
                    height: 60,
                    color: const Color(0xFF202020),
                    child: const Icon(
                      Icons.person,
                      color: AppColors.greyText,
                      size: 20,
                    ),
                  ),
                ),
              ),
            )
          else
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Container(
                width: 40,
                height: 60,
                color: const Color(0xFF202020),
                child: const Icon(
                  Icons.person,
                  color: AppColors.greyText,
                  size: 20,
                ),
              ),
            ),

          const SizedBox(width: 10),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    crew.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    crew.job,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.greyText,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
