import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:kino/configuration/configuration.dart';
import 'package:kino/domain/api_client/movie_api_client.dart';
import 'package:kino/domain/entity/popular_tv.dart';
import 'package:kino/domain/entity/tv.dart';


abstract class TVEvent {}

class TVEventLoadNextPage extends TVEvent {
  final String locale;

  TVEventLoadNextPage(this.locale);
}

class TVEventLoadReset extends TVEvent {}


class TVContainer {
  final List<TV> tv;
  final int currentPage;
  final int totalPage;

  bool get isComplete => currentPage >= totalPage;

  const TVContainer.inital()
      : tv = const <TV>[],
        currentPage = 0,
        totalPage = 1;

  TVContainer({
    required this.tv,
    required this.currentPage,
    required this.totalPage,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TVContainer &&
          runtimeType == other.runtimeType &&
          tv == other.tv &&
          currentPage == other.currentPage &&
          totalPage == other.totalPage;

  @override
  int get hashCode =>
      tv.hashCode ^ currentPage.hashCode ^ totalPage.hashCode;

  TVContainer copyWith({
    List<TV>? tv,
    int? currentPage,
    int? totalPage,
  }) {
    return TVContainer(
      tv: tv ?? this.tv,
      currentPage: currentPage ?? this.currentPage,
      totalPage: totalPage ?? this.totalPage,
    );
  }
}

class TVState {
  final TVContainer popularTVContainer;
  List<TV> get tv =>
       popularTVContainer.tv;

  const TVState.inital()
      : popularTVContainer = const TVContainer.inital();

  TVState({
    required this.popularTVContainer,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TVState &&
          runtimeType == other.runtimeType &&
          popularTVContainer == other.popularTVContainer;

  @override
  int get hashCode =>
      popularTVContainer.hashCode;

  TVState copyWith({
    TVContainer? popularTVContainer,
  }) {
    return TVState(
      popularTVContainer:
          popularTVContainer ?? this.popularTVContainer,
    );
  }
}

class TVBloc extends Bloc<TVEvent, TVState> {
  final _tvApiClient = MovieApiClient();

  TVBloc(
    TVState initialState,
  ) : super(initialState) {
    on<TVEvent>((event, emit) async {
      if (event is TVEventLoadNextPage) {
        await onTVListEventLoadNextPage(event, emit);
      } else if (event is TVEventLoadReset) {
        await onTVListEventLoadReset(event, emit);
      } 
    }, transformer: sequential());
  }

  Future<void> onTVListEventLoadNextPage(
    TVEventLoadNextPage event,
    Emitter<TVState> emit,
  ) async {
  
      final container = await _loadNextPage(
        state.popularTVContainer,
        (nextPage) async {
          final result = await _tvApiClient.popularTV(
            nextPage,
            event.locale,
            Configuration.apiKey,
          );
          return result;
        },
      );
      if (container != null) {
        final newState = state.copyWith(popularTVContainer: container);
        emit(newState);
      }
    }
  }

  Future<TVContainer?> _loadNextPage(
    TVContainer container,
    Future<PopularTVResponse> Function(int) loader,
  ) async {
    if (container.isComplete) return null;
    final nextPage = container.currentPage + 1;
    final result = await loader(nextPage);
    final tv = List<TV>.from(container.tv)..addAll(result.tv);
    final newContainer = container.copyWith(
      tv: tv,
      currentPage: result.page,
      totalPage: result.totalPages,
    );
    return newContainer;
  }

  Future<void> onTVListEventLoadReset(
    TVEventLoadReset event,
    Emitter<TVState> emit,
  ) async {
    emit(const TVState.inital());
  }
