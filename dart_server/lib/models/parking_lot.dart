import 'package:shared/shared.dart';
import 'package:uuid/uuid.dart';

class ParkingLotFactory {
  static Future<ParkingLot> fromServerJson(Map<String, dynamic> json) async {
    Address address = Address(
        street: json['street'], zipCode: json['zipCode'], city: json['city']);
    return ParkingLot(
        id: json['id'], address: address, hourlyPrice: json['hourlyPrice']);
  }

  static Map<String, dynamic> toServerJson(ParkingLot parkinglot) {
    return {
      'id': parkinglot.id != '-1' ? parkinglot.id : Uuid().v4(),
      'hourlyPrice': parkinglot.hourlyPrice,
      'street': parkinglot.address?.street,
      'zipCode': parkinglot.address?.zipCode,
      'city': parkinglot.address?.city
    };
  }
}
