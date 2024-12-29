import 'package:shared/src/enums/car_type.dart';
import 'package:shared/src/models/owner.dart';

class Vehicle {
  String? _id;
  String registrationNo;
  CarBrand type;
  Owner? owner;

  Vehicle(
      {required this.registrationNo,
      required this.type,
      required this.owner,
      String? id})
      : _id = id;

  String get id => _id ?? '-1';

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    var typeIndex = json['type'];

    Vehicle vehicle = Vehicle(
      id: json['id'],
      registrationNo: json['registrationNo'],
      type: CarBrand.values[typeIndex],
      owner: json['owner'] != null ? Owner.fromJson(json['owner']) : null,
    );
    return vehicle;
  }

  Map<String, dynamic> toJson() => {
        'id': _id,
        'registrationNo': registrationNo,
        'type': type.index,
        'owner': owner?.toJson()
      };

  @override
  String toString() {
    return 'RegistrationNo: $registrationNo, type: $type, owner: (${owner.toString()})';
  }
}
