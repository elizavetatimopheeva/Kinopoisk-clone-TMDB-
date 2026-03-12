import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kino/ui/widgets/news/news_cubit.dart';
import 'package:kino/ui/widgets/news/news_widget_free_to_watch.dart';
import 'package:kino/ui/widgets/news/news_widget_leaderboards.dart';
import 'package:kino/ui/widgets/news/news_widget_popular.dart';
import 'package:kino/ui/widgets/news/news_widget_trailers.dart';
import 'package:kino/ui/widgets/news/news_widget_trandings.dart';
import 'package:kino/ui/widgets/news/tv_cubit.dart';

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
    context.read<TVCubit>().setupLocale(locale.languageCode);
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const NewsWidgetPopular(),
        const NewsWidgetUpcoming(),
        const NewsWidgetTrailers(),
        const NewsWidgetTrandings(),
        const NewsWidgetLeaderboards(),
      ],
    );
  }
}
