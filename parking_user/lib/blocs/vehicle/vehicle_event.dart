part of 'vehicle_bloc.dart';

class VehicleEvent {}

class LoadVehiclesEvent extends VehicleEvent {}

class RemoveVehicleEvent extends VehicleEvent {
  final String vehicleId;

  RemoveVehicleEvent({required this.vehicleId});
}

class AddVehicleEvent extends VehicleEvent {
  final Vehicle vehicle;

  AddVehicleEvent({required this.vehicle});
}
