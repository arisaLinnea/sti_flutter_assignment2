import 'dart:convert';
import 'dart:io';

import 'package:dart_server/models/parking_lot.dart';
import 'package:dart_server/repositories/repository.dart';
import 'package:shared/shared.dart';

class ParkingLotRepository extends Repository<ParkingLot> {
  static final ParkingLotRepository _instance =
      ParkingLotRepository._internal();

  ParkingLotRepository._internal();
  final String _storageName = 'parkinglots';

  factory ParkingLotRepository() => _instance;

  @override
  Future<String?> addToList({required dynamic json}) async {
    try {
      ParkingLot parkinglot = deserialize(json);
      File file = File(super.filePath);

      var {'list': serverList, 'map': jsonmap} =
          await super.getServerList(file: file, name: _storageName);
      if (serverList == null || jsonmap == null) {
        throw StateError('Server list or map is null');
      }
      final int initialLength = serverList.length;
      Map<String, dynamic> newlot = ParkingLotFactory.toServerJson(parkinglot);
      serverList.add(newlot);
      if (serverList.length == initialLength) {
        return null;
      }
      jsonmap[_storageName] = serverList;
      await file.writeAsString(jsonEncode(jsonmap));
      return newlot['id'];
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ParkingLot?> getElementById({required String id}) async {
    try {
      File file = File(super.filePath);
      var serverData =
          await super.getServerList(file: file, name: _storageName);
      List<dynamic> serverList = serverData['list'];
      List<ParkingLot> lotList = await Future.wait(
          serverList.map((json) => ParkingLotFactory.fromServerJson(json)));
      ParkingLot foundLot = lotList.firstWhere((lot) => lot.id == id);
      return foundLot;
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
      List<ParkingLot> lotList = await Future.wait(
          serverList.map((json) => ParkingLotFactory.fromServerJson(json)));
      List<Map<String, dynamic>> resultList = lotList.map(serialize).toList();

      return resultList;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> update({required String id, required dynamic json}) async {
    try {
      ParkingLot parkinglot = deserialize(json);
      File file = File(super.filePath);

      var {'list': serverList, 'map': jsonmap} =
          await super.getServerList(file: file, name: _storageName);
      if (serverList == null || jsonmap == null) {
        throw StateError(
            'Server list or map is null. Could not update owner data.');
      }

      bool parkinglotFound = false;
      List<dynamic> updatedList = serverList.map((json) {
        if (json['id'] == id) {
          parkinglotFound = true;
          return ParkingLotFactory.toServerJson(parkinglot);
        }
        return json;
      }).toList();

      if (!parkinglotFound) {
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
  ParkingLot deserialize(Map<String, dynamic> json) =>
      ParkingLot.fromJson(json);

  @override
  Map<String, dynamic> serialize(ParkingLot item) => item.toJson();

  @override
  String itemAsString() {
    return 'ParkingLot';
  }
}
