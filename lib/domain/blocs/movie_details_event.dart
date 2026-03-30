import 'package:flutter/material.dart';
import 'package:kino/ui/widgets/movie_details/movie_details_cubit.dart';


abstract class MovieDetailsEvent {
  const MovieDetailsEvent();
}

class MovieDetailsSetupLocaleEvent extends MovieDetailsEvent {
  final BuildContext context;
  final Locale locale;

  const MovieDetailsSetupLocaleEvent({
    required this.context,
    required this.locale,
  });
}


class MovieDetailsLoadEvent extends MovieDetailsEvent {
  final BuildContext context;

  const MovieDetailsLoadEvent({required this.context});
}

class MovieDetailsToggleFavoriteEvent extends MovieDetailsEvent {
  final BuildContext context;

  const MovieDetailsToggleFavoriteEvent({required this.context});
}

class MovieDetailsToggleWatchListEvent extends MovieDetailsEvent {
  final BuildContext context;

  const MovieDetailsToggleWatchListEvent({required this.context});
}






abstract class MovieDetailsState {
  const MovieDetailsState();
}

class MovieDetailsInitialState extends MovieDetailsState {
  const MovieDetailsInitialState();
}

class MovieDetailsLoadingState extends MovieDetailsState {
  const MovieDetailsLoadingState();
}

class MovieDetailsLoadedState extends MovieDetailsState {
  final DetailsData data;

  const MovieDetailsLoadedState({required this.data});
}

class MovieDetailsErrorState extends MovieDetailsState {
  final String message;

  const MovieDetailsErrorState({required this.message});
}