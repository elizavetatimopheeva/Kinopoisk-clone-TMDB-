import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kino/domain/api_client/image_downloader.dart';
import 'package:kino/domain/blocs/movie_details_event.dart';

import 'package:kino/ui/theme/app_colors.dart';
import 'package:kino/ui/widgets/movie_details/movie_details_cubit.dart';

class MovieDetailsPhotosWidget extends StatelessWidget {
  const MovieDetailsPhotosWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Изображения',
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
          height: 160,
          child: Scrollbar(child: _PhotosListWidget()),
        ),
      ],
    );
  }
}

class _PhotosListWidget extends StatelessWidget {
  const _PhotosListWidget();

  @override
  Widget build(BuildContext context) {
    final state = context.read<BaseDetailsBloc>().state;
    if (state is! MovieDetailsLoadedState) {
      return const SizedBox.shrink();
    }

    final photos = state.data.photos;
    final count = photos.length > 20 ? 20 : photos.length;
    final totalCount = count + 1;

    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: totalCount,
      itemBuilder: (BuildContext context, int index) {
        if (index == count) {
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
          width: 230,
          child: Padding(
            padding: const EdgeInsets.only(right: 20),
            child: _PhotoItemWidget(photoIndex: index),
          ),
        );
      },
    );
  }
}

class _PhotoItemWidget extends StatelessWidget {
  final int photoIndex;
  const _PhotoItemWidget({required this.photoIndex});

  @override
  Widget build(BuildContext context) {
    final state = context.read<BaseDetailsBloc>().state;
    if (state is! MovieDetailsLoadedState) {
      return const SizedBox.shrink();
    }

    final photo = state.data.photos[photoIndex];
    final filePath = photo.filePath;

    return  Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: ClipRRect(
            child: Image.network(
              ImageDownloader.imageUrl(filePath),
              width: 200,
              height: 112,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                width: 200,
                height: 112,
                color: const Color(0xFF202020),
                child: const Icon(
                  Icons.broken_image,
                  color: AppColors.greyText,
                  size: 40,
                ),
              ),
            ),
          ),
        ),
      ],
      // ),
    );
  }
}
