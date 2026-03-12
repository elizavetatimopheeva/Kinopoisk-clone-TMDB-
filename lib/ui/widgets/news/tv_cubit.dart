import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:intl/intl.dart';
import 'package:kino/domain/blocs/tv_bloc.dart';
import 'package:kino/domain/entity/tv.dart';

class TVRowData {
  final int id;
  final String? posterPath;
  final String title;
  final String firsrAirDate;
  final String overview;
  final double voteAverage;

  TVRowData({
    required this.id,
    required this.posterPath,
    required this.title,
    required this.firsrAirDate,
    required this.overview,
    required this.voteAverage,
  });
}

class TVCubitState {
  final List<TVRowData> tv;
  final String localeTag;

  const TVCubitState({required this.tv, required this.localeTag});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TVCubitState &&
          runtimeType == other.runtimeType &&
          tv == other.tv &&
          localeTag == other.localeTag;

  @override
  int get hashCode => tv.hashCode ^ localeTag.hashCode;

  TVCubitState copyWith({
    List<TVRowData>? tv,
    String? localeTag,
  }) {
    return TVCubitState(
      tv: tv ?? this.tv,
      localeTag: localeTag ?? this.localeTag,
    );
  }
}

class TVCubit extends Cubit<TVCubitState> {
  final TVBloc tvBloc;
  late final StreamSubscription<TVState> tvListBlocSubscription;
  late DateFormat _dateFormat;
  Timer? searchDebounce;

  TVCubit({required this.tvBloc})
    : super(
        const TVCubitState(tv: <TVRowData>[], localeTag: ""),
      ) {
    Future.microtask(() {
      _onState(tvBloc.state);
      tvListBlocSubscription = tvBloc.stream.listen(_onState);
    });
  }

  void _onState(TVState state) {
    final tv = state.tv.map(_makeRowData).toList();
    final newState = this.state.copyWith(tv: tv);
    emit(newState);
  }

  void setupLocale(String localeTag) {
    if (state.localeTag == localeTag) return;
    final newState = state.copyWith(localeTag: localeTag);
    emit(newState);
    _dateFormat = DateFormat.yMMMd(localeTag);
    tvBloc.add(TVEventLoadReset());
    tvBloc.add(TVEventLoadNextPage(localeTag));
  }

  void showedMovieAtIndex(int index) {
    if (index < state.tv.length - 1) return;
    tvBloc.add(TVEventLoadNextPage(state.localeTag));
  }

  @override
  Future<void> close() {
    tvListBlocSubscription.cancel();
    return super.close();
  }

  TVRowData _makeRowData(TV tv) {
    final releaseDate = tv.firstAirDate;
    final releaseDateTitle = releaseDate != null
        ? _dateFormat.format(releaseDate)
        : '';
    return TVRowData(
      id: tv.id,
      posterPath: tv.posterPath,
      title: tv.originalName,
      firsrAirDate: releaseDateTitle,
      overview: tv.overview,
      voteAverage: tv.voteAverage,
    );
  }
}