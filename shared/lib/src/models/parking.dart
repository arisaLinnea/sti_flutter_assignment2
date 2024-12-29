import 'package:shared/src/extensions/date_extension.dart';
import 'package:shared/src/models/parkinglot.dart';
import 'package:shared/src/models/vehicle.dart';

class Parking {
  String? _id;
  Vehicle? vehicle;
  ParkingLot? parkinglot;
  DateTime startTime;
  DateTime? endTime;

  Parking(
      {required this.vehicle,
      required this.parkinglot,
      required this.startTime,
      this.endTime,
      String? id})
      : _id = id;

  String get id => _id ?? '-1';

  bool get isActive => endTime == null || endTime!.isAfter(DateTime.now());

  factory Parking.fromJson(Map<String, dynamic> json) {
    return Parking(
        id: json['id'],
        vehicle:
            json['vehicle'] != null ? Vehicle.fromJson(json['vehicle']) : null,
        parkinglot: json['parkinglot'] != null
            ? ParkingLot.fromJson(json['parkinglot'])
            : null,
        startTime: DateTime.parse(json['startTime']),
        endTime:
            json['endTime'] != null ? DateTime.parse(json['endTime']) : null);
  }

  Map<String, dynamic> toJson() => {
        'id': _id,
        'vehicle': vehicle?.toJson(),
        'parkinglot': parkinglot?.toJson(),
        'startTime':
            startTime.toIso8601String(), // Convert DateTime to ISO 8601 string,
        'endTime': endTime?.toIso8601String()
      };

  @override
  String toString() {
    String formattedStartDate = startTime.parkingFormat();
    String? formattedEndDate = endTime?.parkingFormat();
    return 'Vehicle: ${vehicle.toString()}, Parking lot: ${parkinglot.toString()}, Starttime: $formattedStartDate, Endtime: ${formattedEndDate ?? '-'}';
  }
}
