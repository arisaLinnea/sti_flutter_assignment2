import 'package:shared/shared.dart';
import 'package:shared_client/src/repositories/repository.dart';

class VehicleRepository extends Repository<Vehicle> {
  static final VehicleRepository _instance =
      VehicleRepository._internal(path: 'vehicle');

  VehicleRepository._internal({required super.path});

  factory VehicleRepository() => _instance;

  @override
  Vehicle deserialize(Map<String, dynamic> json) => Vehicle.fromJson(json);

  @override
  Map<String, dynamic> serialize(Vehicle item) => item.toJson();
}
