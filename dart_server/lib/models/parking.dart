import 'package:dart_server/repositories/parking_lot_repository.dart';
import 'package:dart_server/repositories/vehicle_repository.dart';
import 'package:shared/shared.dart';
import 'package:uuid/uuid.dart';

class ParkingFactory {
  static Future<Parking> fromServerJson(Map<String, dynamic> json) async {
    return Parking(
        id: json['id'],
        startTime: DateTime.parse(json['startTime']),
        endTime:
            json['endTime'] != null ? DateTime.parse(json['endTime']) : null,
        vehicle:
            await VehicleRepository().getElementById(id: json['vehicleId']),
        parkinglot: await ParkingLotRepository()
            .getElementById(id: json['parkinglotId']));
  }

  static Map<String, dynamic> toServerJson(Parking parking) {
    return {
      'id': parking.id != '-1' ? parking.id : Uuid().v4(),
      'vehicleId': parking.vehicle?.id,
      'parkinglotId': parking.parkinglot?.id,
      'startTime': parking.startTime
          .toIso8601String(), // Convert DateTime to ISO 8601 string,
      'endTime': parking.endTime?.toIso8601String()
    };
  }
}
