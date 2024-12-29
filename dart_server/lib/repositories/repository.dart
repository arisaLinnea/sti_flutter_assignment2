import 'dart:io';

import 'package:dart_server/repositories/file_repository.dart';

abstract class Repository<T> with FileRepository {
  Repository() {
    File file = File(filePath);
    if (!file.existsSync()) {
      print('Create storage file');
      file.createSync(
          recursive: true); //recursive: true creates the directory too
    }
  }

  Future<String?> addToList({required dynamic json});

  Future<T?> getElementById({required String id});

  Future<List<Map<String, dynamic>>> getList();

  Future<bool> update({required String id, required dynamic json});

  Future<bool> remove({required String id});

  T deserialize(Map<String, dynamic> json);

  Map<String, dynamic> serialize(T item);

  String itemAsString();
}
