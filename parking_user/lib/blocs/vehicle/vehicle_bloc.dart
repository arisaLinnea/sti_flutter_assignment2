import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_client/shared_client.dart';
import 'package:shared/shared.dart';
import 'package:equatable/equatable.dart';

part 'vehicle_event.dart';
part 'vehicle_state.dart';

// The BLoC class
class VehicleBloc extends Bloc<VehicleEvent, VehicleState> {
  final VehicleRepository vehicleRepository;

  VehicleBloc({required this.vehicleRepository}) : super(VehicleInitial()) {
    // on<RemoveVehicleEvent>(_handleRemoveVehicle);
    // on<AddVehicleEvent>(_handleAddVehicle);
    on<VehicleEvent>((event, emit) async {
      try {
        if (event is RemoveVehicleEvent) {
          await _handleRemoveVehicle(event, emit);
        } else if (event is AddVehicleEvent) {
          await _handleAddVehicle(event, emit);
        } else if (event is LoadVehiclesEvent) {
          await _handleLoadVehicle(event, emit);
        }
      } catch (e) {
        emit(VehicleFailure(e.toString()));
      }
    });
  }

  Future<void> _handleLoadVehicle(
      LoadVehiclesEvent event, Emitter<VehicleState> emit) async {
    emit(VehicleLoading());
    List<Vehicle> vehicleList = await vehicleRepository.getList();
    emit(VehicleLoaded(vehicles: vehicleList));
  }

  Future<void> _handleRemoveVehicle(
      RemoveVehicleEvent event, Emitter<VehicleState> emit) async {
    emit(VehicleLoading());

    bool success = await vehicleRepository.remove(id: event.vehicleId);

    if (success) {
      emit(VehicleSuccess('Vehicle removed successfully'));
      List<Vehicle> vehicleList = await vehicleRepository.getList();
      emit(VehicleLoaded(vehicles: vehicleList));
    } else {
      emit(VehicleFailure('Failed to remove vehicle'));
    }
  }

  Future<void> _handleAddVehicle(
      AddVehicleEvent event, Emitter<VehicleState> emit) async {
    emit(VehicleLoading());
    Vehicle v = event.vehicle;
    String? vehicleid = await vehicleRepository.addToList(item: event.vehicle);

    if (vehicleid != null) {
      emit(VehicleSuccess('Vehicle added successfully'));
      List<Vehicle> vehicleList = await vehicleRepository.getList();
      emit(VehicleLoaded(vehicles: vehicleList));
    } else {
      emit(VehicleFailure('Failed to add vehicle'));
    }
  }

  // @override
  // Stream<VehicleState> mapEventToState(VehicleEvent event) async* {
  //   if (event is RemoveVehicleEvent) {
  //     yield VehicleLoading();

  //     bool success = await vehicleRepository.remove(id: event.vehicleId);

  //     if (success) {
  //       yield VehicleSuccess('Vehicle removed successfully');
  //     } else {
  //       yield VehicleFailure('Failed to remove vehicle');
  //     }
  //   }
  // }
}
