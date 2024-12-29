import 'dart:convert';
import 'dart:io';
import 'package:collection/collection.dart';

import 'package:dart_server/models/owner.dart';
import 'package:dart_server/repositories/repository.dart';
import 'package:shared/shared.dart';

class OwnerRepository extends Repository<Owner> {
  static final OwnerRepository _instance = OwnerRepository._internal();

  OwnerRepository._internal();
  final String _storageName = 'owners';

  factory OwnerRepository() => _instance;

  @override
  Future<String?> addToList({required dynamic json}) async {
    try {
      Owner owner = deserialize(json);
      File file = File(super.filePath);

      var {'list': serverList, 'map': jsonmap} =
          await super.getServerList(file: file, name: _storageName);

      if (serverList == null || jsonmap == null) {
        throw StateError('Server list or map is null');
      }

      final int initialLength = serverList.length;
      Map<String, dynamic> newOwner = OwnerFactory.toServerJson(owner);
      serverList.add(newOwner);

      if (serverList.length == initialLength) {
        return null;
      }

      jsonmap[_storageName] = serverList;
      await file.writeAsString(jsonEncode(jsonmap));
      return newOwner['id'];
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Owner?> getElementById({required String id}) async {
    try {
      File file = File(super.filePath);
      var serverData =
          await super.getServerList(file: file, name: _storageName);
      List<dynamic> serverList = serverData['list'];
      List<Owner> ownersList = await Future.wait(
          serverList.map((json) => OwnerFactory.fromServerJson(json)));

      Owner? foundOwner =
          ownersList.firstWhereOrNull((owner) => owner.id == id);
      return foundOwner;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getList() async {
    try {
      File file = File(super.filePath);
      var serverData =
          await super.getServerList(file: file, name: _storageName);
      List<dynamic> serverList = serverData['list'];
      List<Owner> ownersList = await Future.wait(
          serverList.map((json) => OwnerFactory.fromServerJson(json)));
      List<Map<String, dynamic>> resultList =
          ownersList.map(serialize).toList();

      return resultList;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> update({required String id, required dynamic json}) async {
    try {
      Owner owner = deserialize(json);
      File file = File(super.filePath);

      var {'list': serverList, 'map': jsonmap} =
          await super.getServerList(file: file, name: _storageName);
      if (serverList == null || jsonmap == null) {
        throw StateError(
            'Server list or map is null. Could not update owner data.');
      }

      bool ownerFound = false;
      List<dynamic> updatedList = serverList.map((json) {
        if (json['id'] == id) {
          ownerFound = true;
          return OwnerFactory.toServerJson(owner);
        }
        return json;
      }).toList();
      if (!ownerFound) {
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
  Owner deserialize(Map<String, dynamic> json) => Owner.fromJson(json);

  @override
  Map<String, dynamic> serialize(Owner item) => item.toJson();

  @override
  String itemAsString() {
    return 'Owner';
  }
}
