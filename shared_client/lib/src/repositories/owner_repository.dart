import 'package:shared/shared.dart';
import 'package:shared_client/src/repositories/repository.dart';

class OwnerRepository extends Repository<Owner> {
  static final OwnerRepository _instance =
      OwnerRepository._internal(path: 'owner');

  OwnerRepository._internal({required super.path});

  factory OwnerRepository() => _instance;

  @override
  Owner deserialize(Map<String, dynamic> json) => Owner.fromJson(json);

  @override
  Map<String, dynamic> serialize(Owner item) => item.toJson();
}
