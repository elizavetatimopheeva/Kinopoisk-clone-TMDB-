// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';

import 'package:kino/domain/api_client/account_api_client.dart';
import 'package:kino/domain/api_client/auth_api_client.dart';
import 'package:kino/domain/data_provider/session_data_provider.dart';

abstract class AuthEvent {}

class AuthCheckStatusEvent extends AuthEvent {}

class AuthLogoutEvent extends AuthEvent {}

class AuthLoginEvent extends AuthEvent {
  final String login;
  final String password;

  AuthLoginEvent({required this.login, required this.password});
}

enum AuthStateStatus { authorized, notAuthorized, inProgress }

abstract class AuthState {}

class AuthUnauthorizedState extends AuthState {
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AuthUnauthorizedState && runtimeType == other.runtimeType;

  @override
  int get hashCode => 0;
}

class AuthAuthorizedState extends AuthState {
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AuthUnauthorizedState && runtimeType == other.runtimeType;

  @override
  int get hashCode => 0;
}

class AuthFailureState extends AuthState {
  final Object error;

  AuthFailureState(this.error);

  @override
  bool operator ==(covariant AuthFailureState other) {
    if (identical(this, other)) return true;

    return other.error == error;
  }

  @override
  int get hashCode => error.hashCode;
}

class AuthInProgressState extends AuthState {
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AuthInProgressState && runtimeType == other.runtimeType;

  @override
  int get hashCode => 0;
}

class AuthCheckInProgressState extends AuthState {
    @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AuthCheckInProgressState && runtimeType == other.runtimeType;

  @override
  int get hashCode => 0;
}

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final _authApiClient = AuthApiClient();
  final _accountApiClient = AccountApiClient();
  final _sessionDataProvider = SessionDataProvider();

  AuthBloc(AuthState initialState) : super(initialState) {
    on<AuthEvent>((event, emit) async {
      if (event is AuthCheckStatusEvent) {
        await onAuthCheckStatusEvent(event, emit);
      } else if (event is AuthLoginEvent) {
       await onAuthLoginEvent(event, emit);
      } else if (event is AuthLogoutEvent) {
        await onAuthLogoutEvent(event, emit);
      }
    }, transformer: sequential());
    add(AuthCheckStatusEvent());
  }

  Future<void> onAuthCheckStatusEvent(
    AuthCheckStatusEvent event,
    Emitter<AuthState> emit,
  ) async {
    final sessionId = await _sessionDataProvider.getSessionId();
    final newState = sessionId != null
        ? AuthAuthorizedState()
        : AuthUnauthorizedState();
    emit(newState);
  }

  Future<void> onAuthLoginEvent(AuthLoginEvent event, Emitter<AuthState> emit) async {
    try {
      final sessionId = await _authApiClient.auth(
        username: event.login,
        password: event.password,
      );
      final accountId = await _accountApiClient.getAccountInfo(sessionId);
      await _sessionDataProvider.setSessionId(sessionId);
      await _sessionDataProvider.setAccountId(accountId);
      emit(AuthAuthorizedState());
    } catch (e) {
      emit(AuthFailureState(e));
    }
  }

  Future<void> onAuthLogoutEvent(AuthLogoutEvent event, Emitter<AuthState> emit) async {
    try {
      await _sessionDataProvider.deleteSessionId();
      await _sessionDataProvider.deleteAccountId();
    } catch (e) {
      emit(AuthFailureState(e));
    }
  }
}

class AuthService {
  final _sessionDataProvider = SessionDataProvider();
  final _authApiClient = AuthApiClient();
  final _accountApiClient = AccountApiClient();

  Future<bool> isAuth() async {
    final sessionId = await _sessionDataProvider.getSessionId();
    final isAuth = sessionId != null;
    return isAuth;
  }

  Future<void> login(String login, String password) async {
    final sessionId = await _authApiClient.auth(
      username: login,
      password: password,
    );
    final accountId = await _accountApiClient.getAccountInfo(sessionId);

    await _sessionDataProvider.setSessionId(sessionId);
    await _sessionDataProvider.setAccountId(accountId);
  }

  Future<void> logout() async {
    await _sessionDataProvider.deleteSessionId();
    await _sessionDataProvider.deleteAccountId();
  }
}


















// class AuthService {
//   final _sessionDataProvider = SessionDataProvider();
//   final _authApiClient = AuthApiClient();
//   final _accountApiClient = AccountApiClient();

//   Future<bool> isAuth() async {
//     final sessionId = await _sessionDataProvider.getSessionId();
//     final isAuth = sessionId != null;
//     return isAuth;
//   }

//   Future<void> login(String login, String password) async {
//     final sessionId = await _authApiClient.auth(
//       username: login,
//       password: password,
//     );
//     final accountId = await _accountApiClient.getAccountInfo(sessionId);

//     await _sessionDataProvider.setSessionId(sessionId);
//     await _sessionDataProvider.setAccountId(accountId);
//   }


//   Future<void> logout() async{
//     await _sessionDataProvider.deleteSessionId();
//     await _sessionDataProvider.deleteAccountId();
//   }

// }
