import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared/shared.dart';
import 'package:shared_client/src/repositories/parking_repository.dart';

part 'parking_event.dart';
part 'parking_state.dart';

class ParkingBloc extends Bloc<ParkingEvent, ParkingState> {
  final ParkingRepository parkingRepository;
  List<Parking> _parkings = [];

  ParkingBloc({required this.parkingRepository}) : super(ParkingInitial()) {
    on<ParkingEvent>((event, emit) async {
      try {
        if (event is LoadParkingsEvent) {
          await _handleLoadParkings(emit);
        } else if (event is RemoveParkingEvent) {
          await _handleRemoveParking(event, emit);
        } else if (event is AddParkingEvent) {
          await _handleAddParking(event, emit);
        }
        // else if (event is EditParkingLotEvent) {
        //   await parkingLotRepository.update(item: event.lot);
        //   await _handleLoadParkingLots(emit);
        // }
      } catch (e) {
        emit(ParkingFailure(e.toString()));
      }
    });
  }

  Future<void> _handleLoadParkings(Emitter<ParkingState> emit) async {
    print('LOAD PARKINGs');
    emit(ParkingLoading());
    _parkings = await parkingRepository.getList();
    emit(ParkingLoaded(parkings: _parkings));
  }

  Future<void> _handleRemoveParking(
      RemoveParkingEvent event, Emitter<ParkingState> emit) async {
    emit(ParkingLoading());
    bool success = await parkingRepository.remove(id: event.parkingId);
    if (success) {
      emit(ParkingSuccess('Parking removed successfully'));
      await _handleLoadParkings(emit);
    } else {
      emit(ParkingFailure('Failed to remove parking'));
    }
  }

  Future<void> _handleAddParking(
      AddParkingEvent event, Emitter<ParkingState> emit) async {
    emit(ParkingLoading());
    String? lotId = await parkingRepository.addToList(item: event.parking);
    if (lotId != null) {
      emit(ParkingSuccess('Parking added successfully'));
      await _handleLoadParkings(emit);
    } else {
      emit(ParkingFailure('Failed to add parking'));
    }
  }

  List<Parking> getUserParkings({required Owner owner}) {
    List<Parking> userParkings =
        _parkings.where((park) => park.vehicle?.owner?.id == owner.id).toList();
    return userParkings;
  }

  List<Parking> getUserActiveParkings({required Owner owner}) {
    List<Parking> userParkings = getUserParkings(owner: owner);
    List<Parking> activeParkings = userParkings
        .where((lot) =>
            (lot.endTime == null || lot.endTime!.isAfter(DateTime.now())))
        .toList();
    return activeParkings;
  }

  List<Parking> getUserEndedParkings({required Owner owner}) {
    List<Parking> userParkings = getUserParkings(owner: owner);
    List<Parking> endedParkings = userParkings
        .where((lot) =>
            (lot.endTime != null && lot.endTime!.isBefore(DateTime.now())))
        .toList();
    return endedParkings;
  }
}
