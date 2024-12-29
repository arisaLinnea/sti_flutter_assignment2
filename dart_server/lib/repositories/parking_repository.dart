import 'dart:convert';
import 'dart:io';
import 'package:collection/collection.dart';

import 'package:dart_server/models/parking.dart';
import 'package:dart_server/repositories/repository.dart';
import 'package:shared/shared.dart';

class ParkingRepository extends Repository<Parking> {
  static final ParkingRepository _instance = ParkingRepository._internal();

  ParkingRepository._internal();
  final String _storageName = 'parkings';

  factory ParkingRepository() => _instance;

  @override
  Future<String?> addToList({required dynamic json}) async {
    try {
      Parking parking = deserialize(json);
      File file = File(super.filePath);

      var {'list': serverList, 'map': jsonmap} =
          await super.getServerList(file: file, name: _storageName);
      if (serverList == null || jsonmap == null) {
        throw StateError('Server list or map is null');
      }

      final int initialLength = serverList.length;
      Map<String, dynamic> newParking = ParkingFactory.toServerJson(parking);
      serverList.add(newParking);

      if (serverList.length == initialLength) {
        return null;
      }
      jsonmap[_storageName] = serverList;
      await file.writeAsString(jsonEncode(jsonmap));
      return newParking['id'];
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Parking?> getElementById({required String id}) async {
    try {
      File file = File(super.filePath);
      var serverData =
          await super.getServerList(file: file, name: _storageName);
      List<dynamic> serverList = serverData['list'];
      List<Parking> parkingList = await Future.wait(
          serverList.map((json) => ParkingFactory.fromServerJson(json)));

      Parking? foundParking =
          parkingList.firstWhereOrNull((parking) => parking.id == id);
      return foundParking;
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
      List<Parking> parkingList = await Future.wait(
          serverList.map((json) => ParkingFactory.fromServerJson(json)));
      List<Map<String, dynamic>> resultList =
          parkingList.map(serialize).toList();

      return resultList;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> update({required String id, required dynamic json}) async {
    try {
      Parking parking = deserialize(json);
      File file = File(super.filePath);

      var {'list': serverList, 'map': jsonmap} =
          await super.getServerList(file: file, name: _storageName);
      if (serverList == null || jsonmap == null) {
        throw StateError(
            'Server list or map is null. Could not update owner data.');
      }

      bool parkingFound = false;
      List<dynamic> updatedList = serverList.map((json) {
        if (json['id'] == id) {
          parkingFound = true;
          return ParkingFactory.toServerJson(parking);
        }
        return json;
      }).toList();
      if (!parkingFound) {
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
  Parking deserialize(Map<String, dynamic> json) => Parking.fromJson(json);

  @override
  Map<String, dynamic> serialize(Parking item) => item.toJson();

  @override
  String itemAsString() {
    return 'Parking';
  }
}
