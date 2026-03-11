import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:kino/domain/services/auth_service.dart';

enum LoaderViewCubitState { unknown, authorized, notAuthorized }

class LoaderViewCubit extends Cubit<LoaderViewCubitState> {
  
  final AuthBloc authBloc;
  late final StreamSubscription<AuthState> authBlocSubscription;

  LoaderViewCubit(super.initialState, this.authBloc) {
    authBloc.add(AuthCheckStatusEvent());
    _onState(authBloc.state);
    authBlocSubscription = authBloc.stream.listen(_onState);
  }

  void _onState(AuthState state) {
    if (state is AuthAuthorizedState) {
      emit(LoaderViewCubitState.authorized);
    } else if (state is AuthUnauthorizedState) {
      emit(LoaderViewCubitState.notAuthorized);
    }
  }

  @override
  Future<void> close() {
    authBlocSubscription.cancel();
    return super.close();
  }
}











// class LoaderViewModel {
//   final BuildContext context;
//   final _authService = AuthService();

//   LoaderViewModel(this.context) {
//     asyncInit();
//   }

//   Future<void> asyncInit() async {
//     await checkAuth();
//   }

//   Future<void> checkAuth() async {
//     final isAuth = await _authService.isAuth();

//     final nextScreen = isAuth
//         ? MainNavigationRouteNames.mainScreen
//         : MainNavigationRouteNames.auth;

//     Navigator.of(context).pushReplacementNamed(nextScreen);
//   }
// }
