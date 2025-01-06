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
        } else if (event is AuthRegisterEvent) {
          await _handleRegisterToState(event, emit);
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
    Owner? loginUser = await UserLoginRepository().canUserLogin(user: data);

    if (loginUser != null) {
      emit(AuthAuthenticatedState(newUser: loginUser));
      // Utils.toastMessage('Login Successful');
    } else {
      emit(AuthFailedState(message: 'Login Failed'));
      emit(AuthUnauthorizedState());
      // Utils.toastMessage('Login Failed');
    }
  }

  Future<void> _handleRegisterToState(
      AuthRegisterEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoadingState());

    // yield AuthRegistrationState(status: RegStatus.loading);
    // try {
    //   Owner newOwner = Owner(name: event.name, ssn: event.ssn);
    //   String? uuid = await OwnerRepository().addToList(item: newOwner);
    //   if (uuid != null) {
    //     UserLogin newLoginUser = UserLogin(
    //         ownerId: uuid, userName: event.username, pwd: event.password);
    //     String? response =
    //         await UserLoginRepository().addToList(item: newLoginUser);
    //     if (response != null) {
    //       Utils.toastMessage('Account successfully created');
    //       yield AuthRegistrationState(status: RegStatus.ok);
    //     } else {
    //       yield AuthRegistrationState(status: RegStatus.ok);
    //       Utils.toastMessage('Failed to add account');
    //     }
    //   } else {
    //     yield AuthRegistrationState(status: RegStatus.ok);
    //     Utils.toastMessage('Failed to add account');
    //   }
    // } catch (e) {
    //   yield AuthRegistrationState(status: RegStatus.ok);
    //   Utils.toastMessage('Failed to add account');
    // }
  }

  Future<void> _handleLogoutToState(Emitter<AuthState> emit) async {
    emit(AuthUnauthorizedState());
  }
}
