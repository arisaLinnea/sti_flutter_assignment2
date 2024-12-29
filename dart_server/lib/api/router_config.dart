import 'dart:convert';

import 'package:dart_server/api/routes.dart';
import 'package:dart_server/repositories/login_repository.dart';

import 'package:dart_server/repositories/owner_repository.dart';
import 'package:dart_server/repositories/parking_lot_repository.dart';
import 'package:dart_server/repositories/parking_repository.dart';
import 'package:dart_server/repositories/vehicle_repository.dart';
import 'package:logger/logger.dart';
import 'package:shared/shared.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

class ServerConfig {
  ServerConfig._privateConstructor() {
    initialize();
  }

  static final ServerConfig _instance = ServerConfig._privateConstructor();

  static ServerConfig get instance => _instance;

  late Router router;

  final OwnerRepository ownerRepo = OwnerRepository();
  final VehicleRepository vehicleRepo = VehicleRepository();
  final ParkingLotRepository parkingLotRepo = ParkingLotRepository();
  final ParkingRepository parkingRepo = ParkingRepository();
  final LoginRepository loginRepo = LoginRepository();

  var logger = Logger();

  Future initialize() async {
    // Configure routes.
    router = Router()
      ..mount('/api/owner', getRoutes(ownerRepo))
      ..mount('/api/vehicle', getRoutes(vehicleRepo))
      ..mount('/api/parkinglot', getRoutes(parkingLotRepo))
      ..mount('/api/parking', getRoutes(parkingRepo))
      ..mount('/api/login', loginHandler())
      ..mount('/*', wrongPathHandler());
  }

  Handler loginHandler() {
    Future<Response> checkLoginHandler(Request request) async {
      try {
        final data = await request.readAsString();
        final json = jsonDecode(data);
        String? ownerId = await loginRepo.checkLogin(json: json);
        if (ownerId != null) {
          Owner? owner = await ownerRepo.getElementById(id: ownerId);
          if (owner != null) {
            return Response.ok(jsonEncode(ownerRepo.serialize(owner)),
                headers: {'Content-Type': 'application/json'});
          }
          return Response.notFound({});
        } else {
          return Response.notFound({});
        }
      } catch (e) {
        logger.e("Error trying to login user: $e");
        return Response.internalServerError(
            body: jsonEncode({'message': 'Unexpected error: ${e.toString()}'}));
      }
    }

    Future<Response> addItemHandler(Request request) async {
      try {
        final data = await request.readAsString();
        final json = jsonDecode(data);

        String? newId = await loginRepo.addToList(json: json);
        if (newId != null) {
          return Response.ok(jsonEncode(newId),
              headers: {'Content-Type': 'application/json'});
        } else {
          return Response.internalServerError(
              body:
                  jsonEncode({'message': 'Failed to add ${json['userName']}'}));
        }
      } catch (ex) {
        logger.e(
            "Error adding item to list of ${loginRepo.itemAsString()}s: ${ex.toString()}");
        return Response.internalServerError(
            body: jsonEncode(
                {'message': 'Failed to add to ${loginRepo.itemAsString()}'}));
      }
    }

    final router = Router()
      ..post('/', checkLoginHandler)
      ..post('/add', addItemHandler);

    return router.call;
  }

  Handler wrongPathHandler() {
    Response rootHandler(Request req) {
      return Response.notFound('Wrong path');
    }

    final router = Router()
      ..get('/', rootHandler)
      ..post('/', rootHandler)
      ..put('/', rootHandler)
      ..delete('/', rootHandler);

    return router.call;
  }
}
