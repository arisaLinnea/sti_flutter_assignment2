import 'dart:convert';
import 'dart:io';

mixin FileRepository {
  final String _filePath = 'db/fileStorage.json';

  String get filePath => _filePath;

  Future<Map<String, dynamic>> getServerList(
      {required File file, required String name}) async {
    String fileContentAsJson = await file.readAsString();
    Map<String, dynamic> jsonmap = {};
    if (fileContentAsJson.isNotEmpty) {
      try {
        jsonmap = jsonDecode(fileContentAsJson);
      } catch (e) {
        throw FormatException('');
      }
    }
    List<dynamic> jsonList = [];

    if (jsonmap.containsKey(name)) {
      jsonList = (jsonmap[name] as List);
    }

    return {
      'list': jsonList,
      'map': jsonmap,
    };
  }
}
