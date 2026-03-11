// import 'dart:async';
// import 'package:bloc/bloc.dart';
// import 'package:flutter/material.dart';
// import 'package:kino/domain/api_client/api_client_exception.dart';
// import 'package:kino/domain/services/auth_service.dart';
// import 'package:kino/widgets/navigation/main_navigation.dart';



// class AuthViewCubitState {
//   final String? errorMessage;
  
//   final bool _isAuthProgress;

//   AuthViewCubitState(this.errorMessage, bool  isAuthProgress):_isAuthProgress = isAuthProgress;
//   bool get canStartAuth => !_isAuthProgress;
//   bool get isAuthProgress => _isAuthProgress;
// }


// class AuthViewCubit extends Cubit<AuthViewCubitState> {
//   final AuthBloc authBloc;
//   late final StreamSubscription<AuthState> authBlocSubscription;

//   AuthViewCubit(super.initialState, this.authBloc);

//     bool _isValid(String login, String password) {
//     return login.isNotEmpty || password.isNotEmpty;
//   }


//   void auth({required String login, required String password}){
//      if (!_isValid(login, password)) {
//       final state = AuthViewCubitState('Заполните логин и пароль', false);
//       emit(state);
//       return;
//     }
//     authBloc.add(AuthLoginEvent(login: login, password: password));
//   }

//   void _onState(AuthState state) {
//     if (state is AuthUnauthorizedState) {
//       emit(AuthViewCubitState(null, true));
//     } else if (state is AuthAuthorizedState) {
//        emit(LoaderViewCubitState.notAuthorized);
//     }
//   }

//   @override
//   Future<void> close() {
//     authBlocSubscription.cancel();
//     return super.close();
//   }
// }









// class AuthViewModel extends ChangeNotifier {
//   final _authService = AuthService();

//   final loginTextController = TextEditingController();
//   final passwordTextController = TextEditingController();

//   String? _errorMessage;
//   String? get errorMessage => _errorMessage;

//   bool _isAuthProgress = false;
//   bool get canStartAuth => !_isAuthProgress;
//   bool get isAuthProgress => _isAuthProgress;

//   bool _isValid(String login, String password) {
//     return login.isNotEmpty || password.isNotEmpty;
//   }

//   Future<String?> _login(String login, String password) async {
//     try {
//       await _authService.login(login, password);
//     } on ApiCLientException catch (e) {
//       switch (e.type) {
//         case ApiCLientExceptionType.network:
//           return 'Сервер недоступен. Проверьте подключение к интернету';
//         case ApiCLientExceptionType.auth:
//           return 'Неправильный логин и пароль';
//         case ApiCLientExceptionType.other:
//           return 'Произошла ошибка. Поробуйте еще раз';
//         default:
//           return 'Неизвестная ошибка, повторите попытку';
//       }
//     } catch (e) {
//       return 'Неизвестная ошибка, повторите попытку';
//     }
//     return null;
//   }

//   Future<void> auth(BuildContext context) async {
//     final login = loginTextController.text;
//     final password = passwordTextController.text;

//     if (!_isValid(login, password)) {
//       _updateState('Заполните логин и пароль', false);
//       return;
//     }

//     _updateState(null, true);

//     _errorMessage = await _login(login, password);

//     if (_errorMessage == null) {
//       MainNavigation.resetNavigation(context);
//     } else {
//       _updateState(_errorMessage, false);
//     }
//   }

//   void _updateState(String? errorMessage, bool isAuthProgress) {
//     if (_errorMessage == errorMessage && _isAuthProgress == isAuthProgress) {
//       return;
//     }
//     _errorMessage = errorMessage;
//     _isAuthProgress = isAuthProgress;
//     notifyListeners();
//   }
// }


import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:kino/domain/services/auth_service.dart';

abstract class AuthViewCubitState {}

class AuthViewCubitFormFillInProgressState extends AuthViewCubitState {
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AuthViewCubitFormFillInProgressState &&
          runtimeType == other.runtimeType;

  @override
  int get hashCode => 0;
}

class AuthViewCubitErrorState extends AuthViewCubitState {
  final String errorMessage;

  AuthViewCubitErrorState(this.errorMessage);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AuthViewCubitErrorState &&
          runtimeType == other.runtimeType &&
          errorMessage == other.errorMessage;

  @override
  int get hashCode => errorMessage.hashCode;
}

class AuthViewCubitAuthProgressState extends AuthViewCubitState {
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AuthViewCubitAuthProgressState &&
          runtimeType == other.runtimeType;

  @override
  int get hashCode => 0;
}

class AuthViewCubitSuccessAuthState extends AuthViewCubitState {
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AuthViewCubitSuccessAuthState &&
          runtimeType == other.runtimeType;

  @override
  int get hashCode => 0;
}

class AuthViewCubit extends Cubit<AuthViewCubitState> {
  final AuthBloc authBloc;
  late final StreamSubscription<AuthState> authBlocSubscription;

  AuthViewCubit(
    AuthViewCubitState initialState,
    this.authBloc,
  ) : super(initialState) {
    _onState(authBloc.state);
    authBlocSubscription = authBloc.stream.listen(_onState);
  }

  bool _isValid(String login, String password) =>
      login.isNotEmpty && password.isNotEmpty;

  void auth({required String login, required String password}) {
    if (!_isValid(login, password)) {
      final state = AuthViewCubitErrorState('Заполните логин и пароль');
      emit(state);
      return;
    }
    authBloc.add(AuthLoginEvent(login: login, password: password));
  }

  void _onState(AuthState state) {
    if (state is AuthUnauthorizedState) {
      emit(AuthViewCubitFormFillInProgressState());
    } else if (state is AuthAuthorizedState) {
      authBlocSubscription.cancel();
      emit(AuthViewCubitSuccessAuthState());
    } else if (state is AuthFailureState) {
      final message = _mapErrorToMessage(state.error);
      emit(AuthViewCubitErrorState(message));
    } else if (state is AuthInProgressState) {
      emit(AuthViewCubitAuthProgressState());
    } else if (state is AuthCheckStatusInProgressState) {
      emit(AuthViewCubitAuthProgressState());
    }
  }

  String _mapErrorToMessage(Object error) {
    if (error is! ApiClientException) {
      return 'Неизвестная ошибка, поторите попытку';
    }
    switch (error.type) {
      case ApiClientExceptionType.network:
        return 'Сервер не доступен. Проверте подключение к интернету';
      case ApiClientExceptionType.auth:
        return 'Неправильный логин пароль!';
      case ApiClientExceptionType.sessionExpired:
      case ApiClientExceptionType.other:
        return 'Произошла ошибка. Попробуйте еще раз';
    }
  }

  @override
  Future<void> close() {
    authBlocSubscription.cancel();
    return super.close();
  }
}