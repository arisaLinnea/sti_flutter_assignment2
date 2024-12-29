import 'package:shared/shared.dart';
import 'package:shared_client/src/repositories/repository.dart';

class ParkingRepository extends Repository<Parking> {
  static final ParkingRepository _instance =
      ParkingRepository._internal(path: 'parking');

  ParkingRepository._internal({required super.path});

  factory ParkingRepository() => _instance;

  @override
  Parking deserialize(Map<String, dynamic> json) => Parking.fromJson(json);

  @override
  Map<String, dynamic> serialize(Parking item) => item.toJson();
}
