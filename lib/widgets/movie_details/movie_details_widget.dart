import 'package:flutter/material.dart';
import 'package:kino/widgets/movie_details/movie_details_main_info_widget.dart';
import 'package:kino/widgets/movie_details/movie_details_main_screen_cast_widget.dart';
import 'package:kino/widgets/movie_details/movie_details_model.dart';
import 'package:provider/provider.dart';

class MovieDetailsWidget extends StatefulWidget {
  const MovieDetailsWidget({super.key});

  @override
  State<MovieDetailsWidget> createState() => _MovieDetailsWidgetState();
}

class _MovieDetailsWidgetState extends State<MovieDetailsWidget> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final locale = Localizations.localeOf(context);
    Future.microtask(
      () => context.read<MovieDetailsModel>().setupLocale(context, locale),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const _TitleWidget(),
        titleTextStyle: TextStyle(
          color: const Color.fromARGB(255, 255, 255, 255),
          fontSize: 20,
        ),
        centerTitle: true,
        iconTheme: IconThemeData(
          color: const Color.fromARGB(255, 255, 255, 255),
        ),
      ), //спецом вынесли тайтл в другой виджет чтобы не перезагружался весь экран потому что у нас и так там много всего еще после будет
      body: const ColoredBox(
        color: Color.fromRGBO(24, 23, 27, 1.0),
        child: BodyWidget(),
      ),
    );
  }
}

class _TitleWidget extends StatelessWidget {
  const _TitleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final title = context.select((MovieDetailsModel model) => model.data.title);
    return Text(title);
  }
}

class BodyWidget extends StatelessWidget {
  const BodyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final isLoading = context.select(
      (MovieDetailsModel model) => model.data.isLoading,
    );
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    return ListView(
      children: const [
        MovieDetailsMainInfoWidget(),
        SizedBox(height: 30),
        MovieDetailsMainScreenCastWidget(),
      ],
    );
  }
}
