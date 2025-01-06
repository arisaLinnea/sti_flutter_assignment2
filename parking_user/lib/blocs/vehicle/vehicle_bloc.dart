import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parking_user/blocs/auth/auth_bloc.dart';
import 'package:shared_client/shared_client.dart';
import 'package:shared/shared.dart';
import 'package:equatable/equatable.dart';

part 'vehicle_event.dart';
part 'vehicle_state.dart';

// The BLoC class
class VehicleBloc extends Bloc<VehicleEvent, VehicleState> {
  final VehicleRepository vehicleRepository;
  final AuthBloc authBloc;

  VehicleBloc({required this.vehicleRepository, required this.authBloc})
      : super(VehicleInitial()) {
    on<VehicleEvent>((event, emit) async {
      final user = authBloc.state.user;

      try {
        if (event is RemoveVehicleEvent) {
          await _handleRemoveVehicle(event, emit, user);
        } else if (event is AddVehicleEvent) {
          await _handleAddVehicle(event, emit, user);
        } else if (event is LoadVehiclesEvent) {
          await _handleLoadVehicle(emit, user);
        }

        // final authState = authBloc.state;
        // if (authState is AuthAuthenticatedState) {
        //   // Set the user in the state
        //   final user = authState.user;
        //   await _handleLoadVehicle(emit, user);
        // }
      } catch (e) {
        emit(VehicleFailure(e.toString()));
      }
    });
  }

  Future<void> _handleLoadVehicle(Emitter<VehicleState> emit, owner) async {
    print('LOAD VEHICLE');
    emit(VehicleLoading());
    // Owner owner = event.owner;
    // emit(VehicleOwnerLoaded(uId: owner.id));
    List<Vehicle> list = await vehicleRepository.getList();
    List<Vehicle> vehicleList =
        list.where((v) => v.owner?.id == owner.id).toList();
    emit(VehicleLoaded(vehicles: vehicleList));
  }

  Future<void> _handleRemoveVehicle(
      RemoveVehicleEvent event, Emitter<VehicleState> emit, owner) async {
    emit(VehicleLoading());

    bool success = await vehicleRepository.remove(id: event.vehicleId);

    if (success) {
      print('Remove vehicle success');
      emit(VehicleSuccess('Vehicle removed successfully'));
      print('Remove vehicle success end');
      await _handleLoadVehicle(emit, owner);
      // List<Vehicle> list = await vehicleRepository.getList();
      // List<Vehicle> vehicleList =
      //     list.where((v) => v.owner?.id == state.userId).toList();
      // emit(VehicleLoaded(vehicles: vehicleList));
    } else {
      emit(VehicleFailure('Failed to remove vehicle'));
    }
  }

  Future<void> _handleAddVehicle(
      AddVehicleEvent event, Emitter<VehicleState> emit, owner) async {
    emit(VehicleLoading());
    String? vehicleid = await vehicleRepository.addToList(item: event.vehicle);

    if (vehicleid != null) {
      emit(VehicleSuccess('Vehicle added successfully'));
      await _handleLoadVehicle(emit, owner);
      // List<Vehicle> list = await vehicleRepository.getList();
      // print('state: $state');
      // List<Vehicle> vehicleList =
      //     list.where((v) => v.owner?.id == state.userId).toList();
      // emit(VehicleLoaded(vehicles: vehicleList));
    } else {
      emit(VehicleFailure('Failed to add vehicle'));
    }
  }
}
