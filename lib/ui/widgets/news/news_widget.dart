import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kino/domain/api_client/image_downloader.dart';
import 'package:kino/ui/widgets/elements/ratial_score_widget.dart';
import 'package:kino/ui/widgets/news/news_cubit.dart';
import 'package:kino/ui/widgets/news/news_widget_free_to_watch.dart';
import 'package:kino/ui/widgets/news/news_widget_leaderboards.dart';
import 'package:kino/ui/widgets/news/news_widget_popular.dart';
import 'package:kino/ui/widgets/news/news_widget_trailers.dart';
import 'package:kino/ui/widgets/news/news_widget_trandings.dart';

class NewsWidget extends StatefulWidget {
  const NewsWidget({Key? key}) : super(key: key);

  @override
  State<NewsWidget> createState() => _NewsWidgetState();
}

class _NewsWidgetState extends State<NewsWidget> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final locale = Localizations.localeOf(context);
    context.read<NewsCubit>().setupLocale(locale.languageCode);
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const NewsWidgetUpcoming(),
        const NewsWidgetPopular(),
        
        const NewsWidgetTrailers(),
        const NewsWidgetTrandings(),
        const NewsWidgetLeaderboards(),
      ],
    );
  }
}

// class NewsWidgetPopular extends StatelessWidget {
//   const NewsWidgetPopular({Key? key}) : super(key: key);

//   final _category = 'movies';

//   @override
//   Widget build(BuildContext context) {
//     final cubit = context.watch<NewsCubit>();

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Padding(
//           padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               const Text(
//                 'What`s Popular',
//                 style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
//               ),
//               DropdownButton<String>(
//                 value: _category,
//                 onChanged: (category) {},
//                 items: [
//                   const DropdownMenuItem(
//                     value: 'movies',
//                     child: Text('Movies'),
//                   ),
//                   const DropdownMenuItem(value: 'tv', child: Text('TV')),
//                   const DropdownMenuItem(
//                     value: 'tvShows',
//                     child: Text('TVShows'),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//         const SizedBox(height: 20),
//         SizedBox(
//           height: 350,
//           child: ListView.builder(
//             scrollDirection: Axis.horizontal,
//             itemCount: cubit.state.movies.length,
//             itemExtent: 150,
//             itemBuilder: (BuildContext context, int index) {
//               cubit.showedMovieAtIndex(index);
//               return _MovieListItem(index: index);
//             },
//           ),
//         ),
//       ],
//     );
//   }
// }

// class _MovieListItem extends StatelessWidget {
//   final int index;
//   const _MovieListItem({super.key, required this.index});

//   @override
//   Widget build(BuildContext context) {
//     final cubit = context.read<NewsCubit>();
//     final movie = cubit.state.movies[index];
//     final posterPath = movie.posterPath;
//     return Padding(
//       padding: const EdgeInsets.all(10.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Stack(
//             children: [
//               Padding(
//                 padding: const EdgeInsets.only(bottom: 20),
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.circular(8),
//                   child: posterPath != null
//                       ? Image.network(
//                           ImageDownloader.imageUrl(posterPath),
//                           width: 95,
//                         )
//                       : SizedBox.shrink(),
//                 ),
//               ),
//               Positioned(
//                 top: 15,
//                 right: 15,
//                 child: Container(
//                   decoration: BoxDecoration(
//                     color: Colors.grey.withOpacity(0.7),
//                     borderRadius: BorderRadius.circular(20),
//                   ),
//                   child: const Icon(Icons.more_horiz),
//                 ),
//               ),
//               Positioned(
//                 left: 10,
//                 bottom: 0,
//                 child: SizedBox(
//                   width: 40,
//                   height: 40,
//                   child: RadialPercentWidget(
//                     percent: 0.68,
//                     fillColor: const Color.fromARGB(255, 10, 23, 25),
//                     lineColor: const Color.fromARGB(255, 37, 203, 103),
//                     freeColor: const Color.fromARGB(255, 25, 54, 31),
//                     lineWidth: 3,
//                     child: const Text(
//                       '68%',
//                       style: TextStyle(color: Colors.white, fontSize: 11),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           Padding(
//             padding: EdgeInsets.only(left: 10, top: 10, right: 10),
//             child: Text(
//               movie.title,
//               maxLines: 2,
//               style: TextStyle(fontWeight: FontWeight.w800),
//             ),
//           ),
//           Padding(
//             padding: EdgeInsets.only(left: 10, top: 10, right: 10),
//             child: Text(movie.releaseDate),
//           ),
//         ],
//       ),
//     );
//   }
// }
