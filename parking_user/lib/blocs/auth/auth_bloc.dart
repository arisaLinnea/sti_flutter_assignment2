import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared/shared.dart';
import 'package:shared_client/shared_client.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserLoginRepository userLoginRepository;
  AuthBloc({required this.userLoginRepository}) : super(AuthInitialState()) {
    on<AuthEvent>((event, emit) async {
      try {
        if (event is AuthLoginEvent) {
          await _handleLoginToState(event, emit);
        } else if (event is AuthLogoutEvent) {
          await _handleLogoutToState(emit);
        }
      } catch (e) {
        emit(AuthUnauthorizedState());
      }
    });
  }

  Future<void> _handleLoginToState(
      AuthLoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoadingState());
    var data = UserLogin(userName: event.email, pwd: event.password);
    Owner? loginUser = await userLoginRepository.canUserLogin(user: data);

    if (loginUser != null) {
      emit(AuthAuthenticatedState(newUser: loginUser));
    } else {
      emit(AuthFailedState(message: 'Login Failed'));
      emit(AuthUnauthorizedState());
    }
  }

  Future<void> _handleLogoutToState(Emitter<AuthState> emit) async {
    emit(AuthUnauthorizedState());
  }
}
