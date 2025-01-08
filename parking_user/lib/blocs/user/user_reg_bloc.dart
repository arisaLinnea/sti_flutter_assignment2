import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared/shared.dart';
import 'package:shared_client/shared_client.dart';

part 'user_reg_event.dart';
part 'user_reg_state.dart';

class UserRegBloc extends Bloc<UserRegEvent, UserRegState> {
  final UserLoginRepository userLoginRepository;
  final OwnerRepository ownerRepository;
  UserRegBloc(
      {required this.userLoginRepository, required this.ownerRepository})
      : super(UserRegInitialState()) {
    on<UserRegEvent>((event, emit) async {
      try {
        if (event is UserRegisterEvent) {
          await _handleRegisterToState(event, emit);
        }
      } catch (e) {
        emit(UserRegFailedState(message: 'Failed to register'));
      }
    });
  }

  Future<void> _handleRegisterToState(
      UserRegisterEvent event, Emitter<UserRegState> emit) async {
    emit(UserRegLoadingState());
    Owner newOwner = Owner(id: '123', name: event.name, ssn: event.ssn);
    String? uuid = await ownerRepository.addToList(item: newOwner);
    if (uuid != null) {
      UserLogin newLoginUser = UserLogin(
          ownerId: uuid, userName: event.username, pwd: event.password);
      String? response =
          await userLoginRepository.addToList(item: newLoginUser);
      if (response != null) {
        emit(AuthRegistrationState());
      } else {
        emit(UserRegFailedState(message: 'Failed to add account'));
      }
    } else {
      emit(UserRegFailedState(message: 'Failed to add account'));
    }
  }
}
