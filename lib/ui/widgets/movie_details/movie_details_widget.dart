import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kino/domain/blocs/movie_details_event.dart';
import 'package:kino/ui/widgets/movie_details/movie_details_cubit.dart';
import 'package:kino/ui/widgets/movie_details/movie_details_info_widget.dart';
import 'package:kino/ui/widgets/movie_details/movie_details_main_screen_cast_widget.dart';
import 'package:kino/ui/widgets/movie_details/movie_details_photos_widget.dart';

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
    final bloc = context.read<BaseDetailsBloc>();
    Future.microtask(() => bloc.setupLocale(context, locale));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BaseDetailsBloc, MovieDetailsState>(
      builder: (context, state) {
        if (state is MovieDetailsLoadingState) {
          return const Scaffold(
            backgroundColor: Colors.black,
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (state is MovieDetailsErrorState) {
          return Scaffold(
            backgroundColor: Colors.black,
            body: Center(
              child: Text(
                'Упс, что-то пошло не так',
                style: const TextStyle(color: Colors.white, fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ),
          );
        }

        if (state is MovieDetailsLoadedState) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.black,
              surfaceTintColor: Colors.black,
              title: const _TitleWidget(),
              titleTextStyle: const TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
              centerTitle: true,
              iconTheme: const IconThemeData(color: Colors.white),
            ),

            body: const ColoredBox(color: Colors.black, child: BodyWidget()),
          );
        }

        return const Scaffold(
          backgroundColor: Colors.black,
          body: Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}

class _TitleWidget extends StatelessWidget {
  const _TitleWidget();

  @override
  Widget build(BuildContext context) {
    final state = context.watch<BaseDetailsBloc>().state;
    if (state is MovieDetailsLoadedState) {
      return Text(state.data.title);
    }
    return const Text('Загрузка...');
  }
}

class BodyWidget extends StatelessWidget {
  const BodyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const BouncingScrollPhysics(),
      children: const [
        MovieDetailsInfoWidget(),
        SizedBox(height: 30),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: MovieDetailsMainScreenCastWidget(),
        ),
        SizedBox(height: 30),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: MovieDetailsPhotosWidget(),
        ),
        SizedBox(height: 10),
      ],
    );
  }
}
