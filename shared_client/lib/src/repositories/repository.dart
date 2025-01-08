import 'dart:convert';

import 'package:http/http.dart' as http;

abstract class Repository<T> {
  final String _path;

  Uri uri = Uri(scheme: 'http', host: 'localhost', port: 8080);

  Repository({required String path}) : _path = path;

  Map<String, dynamic> serialize(T item);
  T deserialize(Map<String, dynamic> json);

  void handleError(Object e) {
    // if (e is SocketException) {
    //   printError('Error talking with the server. Server probably down.');
    // } else if (e is HttpException) {
    //   printError('Error in server data');
    // } else {
    //   printError('Unexpected error when talking to the server');
    // }
  }

  Future<String?> addToList({required T item}) async {
    Uri updatedUri = uri.replace(path: '/api/$_path');
    print('item: $item');
    try {
      final response = await http.post(updatedUri,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(serialize(item)));
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        var body = jsonDecode(response.body);
        // printError('${body['message']}');
        return null;
      }
    } catch (e) {
      handleError(e);
      return null;
    }
  }

  Future<List<T>> getList() async {
    Uri updatedUri = uri.replace(path: '/api/$_path');
    try {
      final response = await http.get(
        updatedUri,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return (json as List).map((item) => deserialize(item)).toList();
      } else {
        var body = jsonDecode(response.body);
        // printError('${body['message']}');
        Future<List<T>> emptyFutureList = Future.value([]);
        return emptyFutureList;
      }
    } catch (e) {
      handleError(e);
      Future<List<T>> emptyFutureList = Future.value([]);
      return emptyFutureList;
    }
  }

  Future<T> getElementById({required String id}) async {
    Uri updatedUri = uri.replace(path: '/api/$_path/$id');
    try {
      final response = await http.get(
        updatedUri,
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return deserialize(json);
      } else {
        var body = jsonDecode(response.body);
        // printError('${body['message']}');
        return Future.value(null);
      }
    } catch (e) {
      handleError(e);
      return Future.value(null);
    }
  }

  Future<bool> update({required String id, required T item}) async {
    Uri updatedUri = uri.replace(path: '/api/$_path/$id');
    try {
      final response = await http.put(updatedUri,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(serialize(item)));
      if (response.statusCode == 200) {
        return true;
      } else {
        var body = jsonDecode(response.body);
        // printError('${body['message']}');
        return false;
      }
    } catch (e) {
      handleError(e);
      return false;
    }
  }

  Future<bool> remove({required String id}) async {
    Uri updatedUri = uri.replace(path: '/api/$_path/$id');
    try {
      final response = await http
          .delete(updatedUri, headers: {'Content-Type': 'application/json'});
      if (response.statusCode == 200) {
        return true;
      } else {
        var body = jsonDecode(response.body);
        // printError('${body['message']}');
        return false;
      }
    } catch (e) {
      handleError(e);
      return false;
    }
  }
}
