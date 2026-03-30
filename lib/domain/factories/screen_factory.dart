import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kino/domain/blocs/auth_bloc.dart';
import 'package:kino/domain/blocs/movie_details_event.dart';
import 'package:kino/domain/blocs/movie_list_bloc.dart';
import 'package:kino/domain/blocs/news_bloc.dart';
import 'package:kino/domain/blocs/tv_bloc.dart';
import 'package:kino/domain/blocs/tv_show_list_bloc.dart';
import 'package:kino/ui/navigation/main_navigation.dart';
import 'package:kino/ui/widgets/auth/auth_view_cubit.dart';
import 'package:kino/ui/widgets/auth/auth_widget.dart';
import 'package:kino/ui/widgets/loader_widget/loader_view_cubit.dart';
import 'package:kino/ui/widgets/loader_widget/loader_widget.dart';
import 'package:kino/ui/widgets/main_screen/main_screen_widget.dart';
import 'package:kino/ui/widgets/movie_details/movie_details_cubit.dart';
import 'package:kino/ui/widgets/movie_details/movie_details_widget.dart';
import 'package:kino/ui/widgets/movie_trailer/movie_trailer_widget.dart';
import 'package:kino/ui/widgets/news/news_cubit.dart';
import 'package:kino/ui/widgets/news/news_widget.dart';
import 'package:kino/ui/widgets/news/tv_cubit.dart';
import 'package:kino/ui/widgets/search_list/search_list_cubit.dart';
import 'package:kino/ui/widgets/search_list/search_list_widget.dart';

enum DetailsType { movie, tv }

class MovieDetailsArguments {
  final int id;
  final DetailsType type;

  MovieDetailsArguments({required this.id, required this.type});
}


class ScreenFactory {
  AuthBloc? _authBloc;

  Widget makeLoader() {
    final authBloc = _authBloc ?? AuthBloc(AuthCheckStatusInProgressState());
    _authBloc = authBloc;
    return BlocProvider<LoaderViewCubit>(
      create: (_) => LoaderViewCubit(LoaderViewCubitState.unknown, authBloc),
      child: const LoaderWidget(),
    );
  }

  Widget makeAuth() {
    final authBloc = _authBloc ?? AuthBloc(AuthCheckStatusInProgressState());
    _authBloc = authBloc;

    return BlocProvider<AuthViewCubit>(
      create: (_) =>
          AuthViewCubit(AuthViewCubitFormFillInProgressState(), authBloc),
      child: const AuthWidget(),
    );
  }

  Widget makeMainScreen() {
    _authBloc?.close();
    _authBloc = null;
    return const MainScreenWidget();
  }


Widget makeDetails(int id, DetailsType type) {
    return BlocProvider(
      create: (context) {

        final BaseDetailsBloc bloc = (type == DetailsType.movie)
            ? MovieDetailsBloc(movieId: id)
            : TVDetailsBloc(tvId: id);
            
        return bloc..add(MovieDetailsLoadEvent(context: context));
      },
      child: const MovieDetailsWidget(), 
    );
  }


  Widget makeMovieTrailer(String youtubeKey) {
    return MovieTrailerWidget(youtubeKey: youtubeKey);
  }

  Widget makeNewsList() {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) =>
              NewsCubit(newsBloc: NewsBloc(const NewsState.inital())),
        ),
        BlocProvider(
          create: (_) => TVCubit(tvBloc: TVBloc(const TVState.inital())),
        ),
      ],
      child: const NewsWidget(),
    );
  }

  Widget makeTVShowList() {
    return BlocProvider<TVShowListCubit>(
      create: (_) => TVShowListCubit(
        tvShowListBloc: TVShowListBloc(const TVShowListState.inital()),
      ),
      child: const GeneralListWidget<TVShowListCubit>(
        title: 'Сериалы',
        routeName:
            MainNavigationRouteNames.movieDetails, detailsType: DetailsType.tv, 
      ),
    );
  }

  Widget makeMovieList() {
    return BlocProvider<MovieListCubit>(
      create: (_) => MovieListCubit(
        movieListBloc: MovieListBloc(const MovieListState.inital()),
      ),
      child: const GeneralListWidget<MovieListCubit>(
        title: 'Фильмы',
        routeName:
            MainNavigationRouteNames.movieDetails, detailsType: DetailsType.movie,
      ),
    );
  }

}
