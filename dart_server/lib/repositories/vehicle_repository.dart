import 'dart:convert';
import 'dart:io';

import 'package:dart_server/models/vehicle.dart';
import 'package:dart_server/repositories/repository.dart';
import 'package:shared/shared.dart';

class VehicleRepository extends Repository<Vehicle> {
  static final VehicleRepository _instance = VehicleRepository._internal();

  VehicleRepository._internal();
  final String _storageName = 'vehicles';

  factory VehicleRepository() => _instance;

  @override
  Future<String?> addToList({required dynamic json}) async {
    try {
      Vehicle vehicle = deserialize(json);
      File file = File(super.filePath);

      var {'list': serverList, 'map': jsonmap} =
          await super.getServerList(file: file, name: _storageName);
      if (serverList == null || jsonmap == null) {
        throw StateError('Server list or map is null');
      }

      final int initialLength = serverList.length;
      Map<String, dynamic> newVehicle = VehicleFactory.toServerJson(vehicle);
      serverList.add(newVehicle);

      if (serverList.length == initialLength) {
        return null;
      }

      jsonmap[_storageName] = serverList;
      await file.writeAsString(jsonEncode(jsonmap));
      return newVehicle['id'];
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Vehicle?> getElementById({required String id}) async {
    try {
      File file = File(super.filePath);
      var serverData =
          await super.getServerList(file: file, name: _storageName);
      List<dynamic> serverList = serverData['list'];
      List<Vehicle> vehicleList = await Future.wait(
          serverList.map((json) => VehicleFactory.fromServerJson(json)));
      Vehicle foundVehicle =
          vehicleList.firstWhere((vehicle) => vehicle.id == id);
      return foundVehicle;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getList() async {
    try {
      File file = File(super.filePath);
      var serverData =
          await super.getServerList(file: file, name: _storageName);
      List<dynamic> serverList = serverData['list'];
      List<Vehicle> vehicleList = await Future.wait(
          serverList.map((json) => VehicleFactory.fromServerJson(json)));
      List<Map<String, dynamic>> jsonList = vehicleList.map(serialize).toList();

      return jsonList;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> update({required String id, required dynamic json}) async {
    try {
      Vehicle vehicle = deserialize(json);
      File file = File(super.filePath);

      var {'list': serverList, 'map': jsonmap} =
          await super.getServerList(file: file, name: _storageName);
      if (serverList == null || jsonmap == null) {
        throw StateError(
            'Server list or map is null. Could not update owner data.');
      }

      bool vehicleFound = false;
      List<dynamic> updatedList = serverList.map((json) {
        if (json['id'] == id) {
          vehicleFound = true;
          return VehicleFactory.toServerJson(vehicle);
        }
        return json;
      }).toList();

      if (!vehicleFound) {
        return false;
      }

      jsonmap[_storageName] = updatedList;
      await file.writeAsString(jsonEncode(jsonmap));
      return true;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> remove({required String id}) async {
    try {
      File file = File(super.filePath);

      var {'list': serverList, 'map': jsonmap} =
          await super.getServerList(file: file, name: _storageName);
      if (serverList == null || jsonmap == null) {
        throw StateError('Server list or map is null');
      }

      final int initialLength = serverList.length;
      serverList.removeWhere((json) => json['id'] == id);
      if (serverList.length == initialLength) {
        return false;
      }

      jsonmap[_storageName] = serverList;
      await file.writeAsString(jsonEncode(jsonmap));
      return true;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Vehicle deserialize(Map<String, dynamic> json) => Vehicle.fromJson(json);

  @override
  Map<String, dynamic> serialize(Vehicle item) => item.toJson();

  @override
  String itemAsString() {
    return 'Vehicle';
  }
}
