import 'dart:convert';
import 'dart:io';
import 'package:logger/logger.dart';

import 'package:dart_server/repositories/repository.dart';
import 'package:shelf/shelf.dart';

var logger = Logger();

Response handleError(Object e, {String? customMessage}) {
  String message = customMessage ?? 'An unexpected error occurred';
  if (e is FormatException) {
    //jsonDecode
    return Response.badRequest(
        body: jsonEncode({'message': 'Failed to decode JSON'}));
  } else if (e is FileSystemException) {
    // Handle file-related errors (e.g., file not found, permission issues)
    return Response.internalServerError(
        body: jsonEncode({'message': 'Error with file'}));
  } else if (e is IOException) {
    //readAsString
    return Response.internalServerError(
        body: jsonEncode({'message': 'Error reading request data'}));
  } else if (e is StateError) {
    // Handle null or unexpected data structures
    return Response.internalServerError(
        body: jsonEncode(
            {'message': 'Unexpected error with data structure: ${e.message}'}));
  } else {
    return Response.internalServerError(
        body: jsonEncode({'message': message, 'error': e.toString()}));
  }
}

Future<Response> addItemHandler(Request request, Repository repo) async {
  try {
    final data = await request.readAsString();
    final json = jsonDecode(data);

    String? newId = await repo.addToList(json: json);
    if (newId != null) {
      return Response.ok(jsonEncode(newId),
          headers: {'Content-Type': 'application/json'});
    } else {
      return Response.internalServerError(
          body:
              jsonEncode({'message': 'Failed to add ${repo.itemAsString()}'}));
    }
  } catch (ex) {
    logger.e(
        "Error adding item to list of ${repo.itemAsString()}s: ${ex.toString()}");
    return handleError(ex,
        customMessage: 'Failed to add ${repo.itemAsString()}');
  }
}

Future<Response> getItemByIdHandler(
    Request request, String id, Repository repo) async {
  try {
    dynamic element = await repo.getElementById(id: id);
    return Response.ok(
      jsonEncode(repo.serialize(element)),
      headers: {'Content-Type': 'application/json'},
    );
  } catch (e) {
    logger.e(
        "Error fetching item with id: $id from list of ${repo.itemAsString()}s: $e");
    return handleError(e,
        customMessage: 'Failed to add ${repo.itemAsString()}');
  }
}

Future<Response> getListHandler(Request request, Repository repo) async {
  try {
    final List<Map<String, dynamic>> ownerList = await repo.getList();

    return Response.ok(
      jsonEncode(ownerList),
      headers: {'Content-Type': 'application/json'},
    );
  } catch (e) {
    if (e is FileSystemException) {
      // Handle file-related errors (e.g., file not found, permission issues)
      return Response.internalServerError(
          body: jsonEncode({'message': 'Error with file'}));
    } else {
      logger.e("Error fetching list of ${repo.itemAsString()}s: $e");
      return handleError(e,
          customMessage: 'fetching lit of ${repo.itemAsString()}');
    }
  }
}

Future<Response> updateItemHandler(
    Request request, String id, Repository repo) async {
  try {
    final data = await request.readAsString();
    final json = jsonDecode(data);

    bool success = await repo.update(json: json, id: id);
    if (success) {
      return Response.ok(null);
    } else {
      return Response.internalServerError(
          body: jsonEncode(
              {'message': 'Failed to update ${repo.itemAsString()}'}));
    }
  } catch (e) {
    logger.e(
        "Error updating item with ID $id in list of ${repo.itemAsString()}s: $e");
    return handleError(e,
        customMessage: 'updating ${repo.itemAsString()} with ID $id');
  }
}

Future<Response> removeItemHandler(
    Request request, String id, Repository repo) async {
  try {
    bool success = await repo.remove(id: id);
    if (success) {
      return Response.ok(null);
    } else {
      return Response.internalServerError(
          body: jsonEncode(
              {'message': 'Failed to remove ${repo.itemAsString()}'}));
    }
  } catch (e) {
    logger.e(
        "Error deleting item with ID $id in list of ${repo.itemAsString()}s: $e");
    return handleError(e,
        customMessage: 'deleting ${repo.itemAsString()} with ID $id');
  }
}
