part of 'vehicle_bloc.dart';

// Define the States
abstract class VehicleState extends Equatable {}

class VehicleInitial extends VehicleState {
  @override
  List<Object?> get props => [];
}

class VehicleLoading extends VehicleState {
  @override
  List<Object?> get props => [];
}

class VehicleLoaded extends VehicleState {
  final List<Vehicle> vehicles;

  VehicleLoaded({required this.vehicles});

  @override
  List<Object?> get props => [vehicles];
}

class VehicleSuccess extends VehicleState {
  final String message;

  VehicleSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class VehicleFailure extends VehicleState {
  final String error;

  VehicleFailure(this.error);

  @override
  List<Object?> get props => [error];
}
