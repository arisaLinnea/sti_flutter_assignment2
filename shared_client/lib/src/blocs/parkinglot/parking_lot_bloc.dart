import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared/shared.dart';
import 'package:shared_client/src/repositories/parking_lot_repository.dart';

part 'parking_lot_event.dart';
part 'parking_lot_state.dart';

class ParkingLotBloc extends Bloc<ParkingLotEvent, ParkingLotState> {
  final ParkingLotRepository parkingLotRepository;
  List<ParkingLot> _parkingsLots = [];

  ParkingLotBloc({required this.parkingLotRepository})
      : super(ParkingLotInitial()) {
    on<ParkingLotEvent>((event, emit) async {
      try {
        if (event is LoadParkingLotsEvent) {
          await _handleLoadParkingLots(emit);
        } else if (event is RemoveParkingLotEvent) {
          await _handleRemoveParkingLot(event, emit);
        } else if (event is AddParkingLotEvent) {
          await _handleAddParkingLot(event, emit);
        }
        // else if (event is EditParkingLotEvent) {
        //   await parkingLotRepository.update(item: event.lot);
        //   await _handleLoadParkingLots(emit);
        // }
      } catch (e) {
        emit(ParkingLotFailure(e.toString()));
      }
    });
  }

  Future<void> _handleLoadParkingLots(Emitter<ParkingLotState> emit) async {
    print('LOAD PARKING LOTS');
    emit(ParkingLotLoading());
    _parkingsLots = await parkingLotRepository.getList();
    emit(ParkingLotLoaded(parkingLots: _parkingsLots));
  }

  Future<void> _handleRemoveParkingLot(
      RemoveParkingLotEvent event, Emitter<ParkingLotState> emit) async {
    emit(ParkingLotLoading());
    bool success = await parkingLotRepository.remove(id: event.lotId);
    if (success) {
      emit(ParkingLotSuccess('Parking lot removed successfully'));
      await _handleLoadParkingLots(emit);
    } else {
      emit(ParkingLotFailure('Failed to remove parking lot'));
    }
  }

  Future<void> _handleAddParkingLot(
      AddParkingLotEvent event, Emitter<ParkingLotState> emit) async {
    emit(ParkingLotLoading());
    String? lotId = await parkingLotRepository.addToList(item: event.lot);
    if (lotId != null) {
      emit(ParkingLotSuccess('Parking lot added successfully'));
      await _handleLoadParkingLots(emit);
    } else {
      emit(ParkingLotFailure('Failed to add parking lot'));
    }
  }

  List<ParkingLot> getFreeParkingLots(List<Parking> allParkings) {
    List<Parking> activeParkings = allParkings
        .where((lot) =>
            (lot.endTime == null || lot.endTime!.isAfter(DateTime.now())))
        .toList();
    print('activeParkings: $activeParkings');
    return _parkingsLots.where((lot) {
      return !activeParkings.any((parking) => parking.parkinglot?.id == lot.id);
    }).toList();
  }
}