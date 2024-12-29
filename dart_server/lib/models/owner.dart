import 'package:shared/shared.dart';
import 'package:uuid/uuid.dart';

class OwnerFactory {
  static Future<Owner> fromServerJson(Map<String, dynamic> json) async {
    return Owner(
      id: json['id'],
      name: json['name'],
      ssn: json['ssn'],
    );
  }

  static Map<String, dynamic> toServerJson(Owner owner) {
    return {
      'id': owner.id != '-1' ? owner.id : Uuid().v4(),
      'name': owner.name,
      'ssn': owner.ssn
    };
  }
}
